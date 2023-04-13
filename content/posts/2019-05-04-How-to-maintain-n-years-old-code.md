+++
author = "Hugo Authors"
title = "如何维护n年前写的代码"
date = "2019-05-04"
description = "要写出机器理解的代码其实不难，但是要写出大部分人能够理解并且易于维护的代码就很有挑战了。因为Apache Camel这个项目已经发展了12年，有大量的历史代码还在发挥着自己的作用，这就意味着我们需要一直维护这些有十多年历史的代码。 今天我这篇文章就是给大家分享一些避免给自己或者别人挖坑的心得，希望能对大家有所帮助。"
tags = [
    "OpenSource",
    "Code", 
]
categories = [
    "OpenSource",
]
+++


要写出机器理解的代码其实不难，但是要写出大部分人能够理解并且易于维护的代码就很有挑战了。 不知道大家有没有试图维护过自己几年前写过的代码，我想绝大多数程序员可能会说你这样的场景不可能发生在我的身上。没有人会去维护自己几年前的代码，因为要么我已经换工作了， 把这活扔给那个新来的倒霉蛋了；要么我的代码没有这么核心早就被不断推到重来的代码所替换掉了，总之你说的这种情况是不会发生在我身上的。  

但是我说的事情的确发生了，原因很简单。因为[Apache Camel](https://camel.apache.org)这个项目已经发展了12年，有大量的历史代码还在发挥着自己的作用，这就意味着我们需要一直维护这些有十多年历史的代码。 今天我这篇文章就是给大家分享一些避免给自己或者别人挖坑的心得，希望能对大家有所帮助。

### 问题现场描述

要让我们的代码可维护除了需要代码写的浅显易懂，还需要借助一些工具来帮助我们记录与开发相关的上下文信息。这些上下文信息和我们看病的病例一样可以让我们通过阅读这些上下文信息在任何时间都能回到问题现场，帮助我们找到问题的关键。

在Apache Camel使用[JIRA](https://issues.apache.org/jira/projects/CAMEL/issues)来跟踪相关的问题，通过使用[JIRA](https://issues.apache.org/jira/projects/CAMEL/issues)我们可以详细记录问题发生的状况，以及问题发生的版本，相关的修复的代码提交记录，如果这个问题由多人同时处理，我们会通过JIRA所提供的问题评论机制互相交流信息，并记录一些重要信息。 这样任何一个围观者都可以非常容易地获取到与这个问题相关的上下文信息。

![image-jira-the-problem](/images/jira/image-jira-the-problem.png)

大家可以通过 [CAMEL-12451](https://issues.apache.org/jira/browse/CAMEL-12451)进入到问题现场。这是一个内存泄露的问题， 问题的提交者Filippov描述了内存泄露的发生场景是怎么样的，并给出了一个复现代码，以及他的猜测。 这部分的内容相当重要，因为有效的充分信息可以降低我们的交互成本，让你的问题能够更快被解答。试想一下如果你建的问题只有一句“这个怎么不工作？”，我想是没有人能够回答你提出的问题的。

因为我虽然维护[camel-cxf](https://github.com/apache/camel/blob/master/components/camel-cxf/src/main/docs/cxf-component.adoc)组件有很长时间，但是最近三年都没有再维护这部分代码，当时见到这个问题就想试一下看看自己的手是不是生疏了。 看完这个问题我的脑子里大概能复现[CXF Interceptor](https://cxf.apache.org/docs/interceptors.html)的调用场景，但是对于那个关键的 "org.apache.cxf.oneway.robust" property 的含义以及后续的操作我是一点都想不起来了。 这个时候我该怎么办呢？当时我第一想到是问问以前的同事吧，可能他们还记得。 于是我点开微信给前同事发了个消息，问他还清楚这个事情吗？ 他的回复比较简单，”这个我也记不清楚了。“  这下有点傻眼了，要是我回过头去读之前的代码可能要花费一天甚至几天的时间才能找到修复的方法，这样一来，原本是想花几个小时练手的活变成了一个要一周时间的大活了。有没有办法多快好省地把问题解决了，这时我想起了之前维护Camel经常使用的一招问问Google看看。

### 时光机器

于是我在Google的搜索框中"org.apache.cxf.oneway.robust"，有几个在cxf-user 邮件列表中讨论的邮件映入我的眼帘。这也许就是解决问题的关键。

![image-jira-google-search](/images/jira/image-jira-google-search.png)

 对于Apache的项目来说，我们会使用邮件列表讨论与项目开发相关的问题，很多时候一个解决方案的来龙去脉以及后续遇到的问题都会在邮件列表里展现出来， 通过阅读这些邮件我们如同坐了时光机器可以随时跳到问题讨论的现场。大概阅读完几篇有关oneway robust的描述，找到一个关键的信息，就是在客户端发起请求的时候，“oneway robust”有一个很特殊的处理规则来保证客户端能够收到服务端发出的soap fault 消息，如下图红框所示。为了实现这部分的功能，CXF会在自己的Interceptor处理链中加入特别的处理方式处理请求消息，这样也就解释了为什么会产生内存泄露了。

![image-the-key-of-issue](/images/jira/image-jira-key-of-issue.png)

通过查看CXF OutgoingChainInterceptor的代码，验证了之前的推断，我找到了修复问题的关键是要保证Camel的UnitOfWork能够在“oneway robust”的情况下也能正常被调用，很快就把问题给修复了。 当修复完问题之后，我在 [CAMEL-12451](https://issues.apache.org/jira/browse/CAMEL-12451) 的评论区中添加的相关记录。 这样如果其他人想要验证我的修复补丁或者是想把相关的修复移植到其他的版本中都能有据可查。

![image-comments](/images/jira/image-jira-comments.png)

### 小结

本文结合实际案例展示了开源社区是如何通过JIRA，邮件列表记录维护相关的问题的上下文信息，通过这些信息我们可以高效地维护历史代码。
