+++
author = "Hugo Authors"
title = "使用Quarkus开发Java云原生应用"
date = "2018-08-04"
description = "本文介绍红帽最近开源的Quarkus项目，该项目通过借助GraalVM提供的AOT技术，可以将大多数的Java代码在不做修改的情况下转换成本地可执行程序，从而降低系统的启动时间已经内存消耗。"
tags = [
    "Quarkus",
    "JAVA", 
]
categories = [
    "JAVA",
    "Quarkus",
]
+++


## Java应用的云原生化痛点

![image-jvm-problems.png](/images/quarkus/image-jvm-problems.png)

Java技术栈作为企业级开发的利器已经发展了快二十多年，大家基于Java技术栈开发了大量的应用。随着云原生架构的普及，越来越多的用户开始使用容器技术来运行微服务应用程序。借助容器技术构建的通用轻量级虚拟机已经帮助我们屏蔽了底层操作系统的差别，JVM的加载Java字节码解释执行所带来的一次编译到处运行优势逐渐变成了劣势。微服务架构的引入，将我们的服务颗粒度变得越来越小，轻量且能快速启动的应用能够更好的适应容器化环境。 以我们目前常规的Spring Boot Java应用来说，一般Restful服务的jar包大概是30M左右， 如果我们将JDK运行时以及相关应用打包成docker镜像文件大概是140M左右。而常规的Go 语言的可执行程序生成镜像包一般不会超过50M。  如何让原有臃肿的Java应用瘦身，易于容器化成为Java应用云原生化需要解决的问题。

![image-jvm-run-time-consuming]({{ site.url }}{{ site.baseurl }}//assets/images/quarkus/image-jvm-run-time-consuming.png)

上图展示的是一个典型的Java应用各模块执行时间的分布情况，大家可以看到，从JVM启动到真的应用程序执行需要经历VM加载，字节码文件加载，以及JVM为了提升效率，借助JIT(just in time)及时编译技术对解释执行的字节码进行局部优化，通过编译器生成本地执行代码的过程，同时还需要加上了JVM内部垃圾回收所耗费的时间。 这样一来典型的Java应用加载时间一般都是秒级起步，如果遇到比较大的应用初始花费几分钟都是正常的。 以往由于我们很少重新启动Java应用，Java应用启动时间长的问题一般很少暴露出来。但是在云原生应用场景下，我们会经常不断重启应用来实现滚动升级或者无服务应用场景。 Java应用启动时间长的问题就变成了Java应用云原生化亟待解决的问题。

## 通过GraalVM 提升Java应用执行效率

![image-graalvm](/images/quarkus/image-graalvm.png)

之前JVM为了提升效率，借助JIT(just in time)及时编译技术对解释执行的字节码进行局部优化，通过编译器生成本地执行代码提升应用执行效率。[GraalVM](https://www.graalvm.org/)是Oracle实验室开发的新一代的面向多种语言的JVM即时编译器，在性能以及多语言互操作性上有比较好的表现。与Java HotSpot VM相比，Graal借助内联，逃逸分析以及推出优化技术可以提升2至5倍的[性能提升](https://medium.com/graalvm/stream-api-performance-with-graalvm-be6cfe7fbb52)。

![image-grralvm-aot1](/images/quarkus/image-graalvm-aot1.png)

 如果我们能够直接将Java应用编译成本地执行文件，可以极大提升Java应用启动速度同时降低为了支持动态特性而带来的内存消耗。GraalVM项目借助AOT技术为我们提供了native-image工具，能够将大多数的Java代码在不做修改的情况下转换成本地可执行程序。

 ![image-graalvm-aot2](/images/quarkus/image-graalvm-aot2.png)

不幸的是GraalVM提供的静态编译功能，只能针对其编译时能够看得的封闭世界进行优化，对于那些使用了反射、动态加载、以及动态代理的代码是无能为力的。为了能让我们日常的Java应用能够正常运行起来，需要我们对应用所使用到的框架和类库进行相关修改适配。由于Java代码所使用的类库很多，这部分的工作量还是相当巨大的，虽然GraalVM已经推出超过一年多的时间，但是还是很少见到大规模Java应用转移到这个平台之上。

## Quarkus介绍

![image-quarkus-introduction](/images/quarkus/image-quarkus-introduction.png)

红帽最近开源的Quarkus项目，借助开源社区的力量，通过对业界广泛使用的框架进行了适配工作，并结合云原生应用的特点，提供了一套端到端的Java云原生应用解决方案。

![image-quarkus-extensions](/images/quarkus/image-quarks-extensions.png)

Quarkus[采用扩展(Extension)](https://quarkus.io/guides/extension-authors-guide)的方式接入第三方的Java库，以最近刚刚release了[0.2.0](https://github.com/apache/camel-quarkus/releases/tag/0.0.2) [camel-quarkus](https://github.com/apache/camel-quarkus/) 为例，针对Apache Camel core 有关加载Camel组件的部分进行[比较大量扩展](https://github.com/apache/camel-quarkus/tree/master/extensions/core/runtime/src/main/java/org/apache/camel/quarkus/core/runtime)，同时Apache Camel 3.0 也针对组件的动态加载进行了优化。

## 如何安装使用Quarkus

- 选择一个适合的IDE

- 安装JDK 1.8+, 设置 JAVA_HOME

- 安装GraalVM，设置GRAALVM_HOME

- 配置C语言开发环境

  - Linux 安装GCC
  - macOS 执行 xcode-select —install
  - windows GraalVM本地编译版本[刚刚提供支持](https://dev.to/skhmt/creating-a-native-executable-in-windows-with-graalvm-3g7f)，需要按照Windows SDK。

- 安装Docker

  - 可以编译docker native image

  最近基于Quarkus写了两个简单的Web应用 [notification-service](https://github.com/WillemJiang/smart-park-demo/tree/master/notification-service) 和 [visitor-service](https://github.com/WillemJiang/smart-park-demo/tree/master/visitor-service) ，后续我会再写一篇文章，把相关的开发细节介绍给大家。值得一提是通过这个[docker文件](https://github.com/WillemJiang/smart-park-demo/blob/master/visitor-service/src/main/docker/Dockerfile.native)构建的基于alpine构建Linux X86本地镜像不到30M，这应该是我见到过的最小的Java应用的镜像了。

  最后附上有关Quarkus的相关资源，希望能够对大家有所帮助。

- [Quarkus Github](https://github.com/quarkusio)
- [Quarkus 快速入门](https://quarkus.io/get-started/)
- [Quarkus 用户手册](https://quarkus.io/guides/)
- [Quarkus 实例代码](https://github.com/quarkusio/quarkus-quickstarts)
