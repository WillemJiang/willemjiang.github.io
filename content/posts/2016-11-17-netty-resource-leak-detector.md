+++
author = "Hugo Authors"
title = "如何排查Netty内存泄露问题？"
date = "2016-11-16"
description = "最近我帮着处理了一个有关Camel Netty4内存泄露的问题，起初只是帮着Review相关的PR，随着工作内容的深入发现了一个暗藏有两年多的内存泄露的Bug。整个除虫的过程很有意思，其中涉及到了在代码里面捕捉Log事件，利用Netty的内存检测工具寻找内存使用的问题等等。"
tags = [
    "Netty",
    "MemoryLeak",
    "Java",
]
categories = [
    "JAVA",
]
+++

最近我帮着处理了[一个有关Camel Netty4内存泄露的问题](https://issues.apache.org/jira/browse/CAMEL-10409)，起初只是帮着Review相关的[PR](https://github.com/apache/camel/pull/1268)，随着工作内容的深入发现了一个暗藏有两年多的内存泄露的[Bug](https://issues.apache.org/jira/browse/CAMEL-10480)。整个除虫的过程很有意思，其中涉及到了在代码里面捕捉Log事件，利用Netty的内存检测工具寻找内存使用的问题等等。

#### 预备知识

Netty的ByteBuf是一个在Netty编程中经常被使用到的对象，Netty4开始对通过[引用计数](http://netty.io/wiki/reference-counted-objects.html)的方式对这样的对象进行管理。如果这类对象的引用计数为0的话，也就是说这些对象已经不再被使用的话，Netty就可将这类对象放回到相关的资源池。

这样的功能听起来好像和GC的功能很类似，为什么我们不能依赖GC实现这样的功能呢？ 原因是GC的实时性没有这么强，而且从程序代码内部很难直接获取到对象的引用情况。

下面我们简单看看ByteBuf的引用计数是如何工作的：

初始化时，引用计数为1：

```java
ByteBuf buf = ctx.alloc().directBuffer();
assert buf.refCnt() == 1;
```

当调用释放操作时，相关的引用计数会-1， 如果引用计数为0， 释放操作会释放内存，或者是把对象放到对象池中：

```java
assert buf.refCnt() == 1;
// 如果引用计数为0， release() 调用返回 true .
boolean destroyed = buf.release();
assert destroyed;
assert buf.refCnt() == 0;
```

如果想延长引用对象的生命周期，可以通过retain方法将引用计数+1

```java
ByteBuf buf = ctx.alloc().directBuffer();
assert buf.refCnt() == 1;
buf.retain();
assert buf.refCnt() == 2;
boolean destroyed = buf.release();
assert !destroyed;
assert buf.refCnt() == 1;
```

对于一个引用计数为0 的对象进行操作的时候，会抛出引用计数的异常

```java
assert buf.refCnt() == 0;
try {
  buf.writeLong(0xdeadbeef);
  throw new Error("should not reach here");
} catch (IllegalReferenceCountExeception e) {
  // Expected
}
```

由于Netty内部的Handler在处理ByteBuf的过程中已经使用 try … finally 进行释放了，如果你对Handler进行扩展的话，一般的用户处理逻辑是不会看到相关的内存对象的释放方法的。

```java
public void channelRead(ChannelHandlerContext ctx, Object msg) {
    ByteBuf buf = (ByteBuf) msg;
    try {
        ...
    } finally {
        buf.release();
    }
}
```

由于我们需要显式地管理引用计数（GC并不知道Netty的引用计数的实现内容），如果代码逻辑在处理的过程中出现问题（忘记释放内存了，或者是对释放后的内存对象进行操作），就很容易出现内存泄露或者是引用计数的错误。

#### 内存泄露检测工具

为了方便我们检测内存泄露的问题，Netty提供了一个缺省的内存检测的实现[ResourceLeakDetector](https://netty.io/4.0/api/io/netty/util/ResourceLeakDetector.html) 。[ResourceLeakDetector](https://netty.io/4.0/api/io/netty/util/ResourceLeakDetector.html)会跟踪引用计数对象的使用情况，并将相关的引用计数对象的使用栈存储下来供开发人员除虫之用。由于引用对象追踪会耗费多的资源，因此对系统会有比较大的影响。运行Netty应用的时候，Netty缺省会采用Simple模式，即采用1%抽样来追踪相关资源分配。如果出现内存泄露，会输入相关log信息，并显示最近相关内存使用情况。

```txt
ERROR io.netty.util.ResourceLeakDetector - LEAK:
 ByteBuf.release() was not called before it's garbage-collected.
```

 对于常规的Netty应用来说，如果出现了上面的错误日志，Netty会建议打开ADVANCED监测模式，去获取更多和内存泄露相关的信息。 一般来说这样的操作会给系统带来比较大的负担，[有人做过统计ADVANCED模式与SIMPLE方式相比，会把系统变慢10倍。](http://logz.io/blog/netty-bytebuf-memory-leak/)

作为开发人员，我们经常会在单元测试里面把泄露级别设置成为PARANOID，就是让资源泄露检测工具对每个Buffer都进行追踪。

```java
System.setProperty("io.netty.leakDetection.maxRecords", "100");
System.setProperty("io.netty.leakDetection.acquireAndReleaseOnly", "true");
ResourceLeakDetector.setLevel(ResourceLeakDetector.Level.PARANOID);
```

#### camel-netty4的内存泄露问题

了解了上面的有关Netty ByteBuff的问题之后，要了解camel-netty4的内存泄露问题就比较简单了。

对于camel-netty4 组件来说，最近就有用户报了内存泄露的问题， Claus前些时候提供了相关的[修复](https://issues.apache.org/jira/browse/CAMEL-9040)，主要修复的内容就是在CamelExchange执行完毕的时候，如果相关的内存对象引用计数>0,就调用相关方法释放内存。 这样的解决似乎有点太粗暴了，有时候会造成内存的多次释放的问题。 于是Vitalii提出了新的[解决方案](https://issues.apache.org/jira/browse/CAMEL-10409)，其核心内容就是就是把Netty引用计数释放的问题交给Netty自己来做。

由于Netty的内存检测模块是通过Log的方式输出内存检测信息的，对于我们的单元测试来说不太方便，于是 Vitalii[配置](https://github.com/apache/camel/blob/master/components/camel-netty4/src/test/resources/log4j2.properties#L28-L32)了一个log4j2的[LogCaptureAppender](https://github.com/apache/camel/blob/master/components/camel-netty4/src/test/java/org/apache/camel/component/netty4/LogCaptureAppender.java)，采用直接截取Log事件的方式在[单元测试完毕](https://github.com/apache/camel/blob/master/components/camel-netty4/src/test/java/org/apache/camel/component/netty4/BaseNettyTest.java#L77-L100)的时候检测是否存在内存泄露的问题。 这样就给写我们的单元测试检测Netty内存溢出提供了极大的便利。

借助这样的Netty提供的内存检测工具以及camel-netty4的单元测试工具，我能在比较快的时间内定位到相关的[内存泄露问题](https://github.com/apache/camel/commit/e56cc97612a07cedd5c67ff3c3b1e22bee525dfb)。
