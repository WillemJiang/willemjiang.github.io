+++
author = "Hugo Authors"
title = "Apache Camel介绍"
date = "2019-01-13"
description = "Apache Camel作为集成项目的利器已经被业界广泛采用，本文将从使用场景以及背后的故事介绍ApacheCamel，最后向大家介绍Apache Camel 3.x的最新进展。"
tags = [
    "Zipkin",
    "JAVA", 
]
categories = [
    "JAVA",
    "Camel",
]
+++


![Apache Camel logo](/images/camel-logo-medium-d.png)

随着企业云化转型的到来，越来越多的企业用户还是将他们的应用往云上迁移，由于云化迁移不是一蹴而就的，通过集成的方式将云上云下系统打通就变成了一个企业云化应用转型的首要问题。

在集成项目中大家面临的问题主要分为两类，一类是要对特有协议进行适配，一类是要结合业务规则编写相应的处理逻辑。从表面看这两类问题的开发量并不大，大家用几百行代码就能解决两个系统的互联互通的问题， 但是由于应用集成涉及到环境复杂，如果不对需要集成的交互协议进行抽象，不对上层的业务逻辑进行建模，很难提升代码的复用度。当需要同时对十几个甚至几十个系统进行集成时，传统的开发方式效率十分低效。

### Apache Camel 是什么？

[Apache Camel](http://camel.apache.org/) 作为集成项目的利器，针对应用集成场景的抽象出了一套消息交互模型，通过组件的方式进行第三方系统的接入，目前Apache Camel已经提供了300多种组件能够接入HTTP，JMS，TCP，WS-*，WebSocket 等多种传输协议。Apache Camel结合[企业应用集成模式（EIP）](http://www.eaipatterns.com/toc.html)的特点提供了消息路由，消息转换等[领域特定语言（DSL）](https://en.wikipedia.org/wiki/Domain-specific_language)，极大降低了集成应用的开发难度。Apache Camel通过URI的方式来定义需要集成的应用节点信息，用户可以按照业务需求使用DSL快速编写消息路由规则，而无需关注集成协议的细节问题。与传统的[企业集成服务总线（ESB）](https://en.wikipedia.org/wiki/Enterprise_service_bus)相比，Apache Camel的核心库非常小巧（是一个只有几M的jar包），可以方便地与其他系统进行集成。

下面这段Apache Camel的用户介绍来自[Claus Ibsen](https://twitter.com/davsclaus)最近写的一篇[非常有意思的Camel介绍文章](https://medium.com/@davsclaus/apache-camel-explained-to-luke-skywalker-d8ed3366e0f3)。

> Apache Camel项目从成立到现在以及差不多12年历史了，目前这个项目被广泛应用在制造业，企业信息系统，或者政府应用中。
>
>  在美国，[FAA](https://www.faa.gov/)就使用Camel来处理航班控制，所以任何坐飞机在美国领空飞行的旅客（大概占全世界15%）都会用到Camel。
>
>  Camel也被广泛应用在美国的银行和金融企业中， 如果你使用银行转账，或者信用卡刷卡时，Camel就有可能在后台帮你在银行间传输这些交易数据。
>
> 如果你是Netflix的订阅用户，Camel会参与你的订单支付的操作。 如果你使用了[UPS](https://www.ups.com)提供的快递服务，那么Camel同样会帮你追踪你的包裹信息。

### Apache Camel的小历史

Apache Camel的前身是[Apache ServiceMix](http://servicemix.apache.org/)项目的 EIP组件，当时[Apache ActiveMQ](https://activemq.apache.org/)作为当红的消息中间件急需一个好的编程界面来提高用户易用性。 就这样[James Strachan](https://twitter.com/jstrachan)在Apache ActiveMQ 项目下创建了Camel子项目，并且与2007年6月发布了 Apache Camel 1.0 版本。 当时我在IONA参与的是[Apache CXF](http://cxf.apache.org/)开发工作，当时Camel社区需要与Apache CXF进行集成提供WS*的解决方案。 于是我在2007年的夏天开始参与Apache Camel的开发，前后提交了很多Patch，2008年春节前我正式被邀请成为Apache ActiveMQ的[committer](http://activemq.apache.org/team.html)，可以直接给Apache Camel提交代码。

Apache Camel是在2009年前后毕业成为Apache顶级项目（拥有camel.apache.org独立域名)，由于需要更改包名以及名字空间，同时Apache Camel  API也进行了比较大改动，经过3个里程碑发布，Apache Camel社区于2009年8月发布了 2.0 版本。 之后Apache Camel差不多一个季度一个第二位小版本的速度持续发展，直到2011年Camel 2.7.0发布之后，因为Camel已经发展了大量的社区用户，很多人已经将Camel应用于生产系统中，为了配合用户的生产的需要，我们制定了两个季度一个小版本，不定期的第三位bug修复版本的发布策略。

虽然社区有人在谈论Camel 3.0版本的发布，但是由于Camel之前定义的DSL以及API都比较稳定，我们一直都没有开始Apache Camel 3.x的开发。 直到2018年10月， [Guillaume Nodet](https://twitter.com/gnodet) [向大家展示了新的Camel 3.x分支](http://camel.465427.n5.nabble.com/HEADS-UP-Camel-3-x-branch-td5824287.html)，才真正宣告Apache Camel 3.x 时代的到来。

### Apache Camel 3.x

从Camel 2.x 到 Camel 3.x 的十年的时间，技术发展迅猛集成市场也发生了很大的变化。十年前 SOA是一个非常时髦的名词，各大企业都在建设自己的ESB来进行应用集成；现在大家谈得更多是微服务，云原生，大而全的ESB开始被小而专的基于Serverless架构的Lamda所替代，更多应用集成是通过几行简单的胶水代码实现，至于这些胶水代码在那运行已经不是开发人员要考虑的问题。云化支持是Camel 3.x需要解决的首要问题。

在云原生环境下， 应用大多采用容器化方式按需运行，这就要求应用需要快速启动。在Apache Camel 云化路线图中，我们首先需要解决的问题是[如何提高Camel应用的启动速度](https://issues.apache.org/jira/browse/CAMEL-12688)。由于Apache Camel的200多个组件都是基于Java写的，所以Camel 3.x会继续挖掘JDK的潜力，例如JDK 9 所提供的模块化支持给启动我们带来一线生机，我们可以根据业务需要定制相关的Camel应用版本，裁剪不必要的部分来进一步提升Camel应用的执行效率。十年前ServiceMix 4基于OSGi内核构建ESB的主要工作就是由[Guillaume Nodet](https://twitter.com/gnodet)完成的， 现在Camel 3.x模块化工作也是由他一手操办。

在云原生时代，按业务需求弹性的伸缩成为云化应用的基本功能，对于Apache Camel来说也不例外，因此在去年中的时候[Nicola Ferraro](https://twitter.com/ni_ferraro)发起一个名为[camel-k](https://github.com/apache/camel-k)的项目。 该项目的目标是让Apache Camel应用更好地在Kubernetes环境下运行。用户可以通过kamel指令将camel应用部署到Kubernetes集群中。[camel-k](https://github.com/apache/camel-k)通过借助[knative](https://github.com/knative/)项目[eventing](https://github.com/knative/eventing)的支持，让我们可以像编写serverless 函数那样定义camel 路由规则，而无需考虑部署和按需进行弹性伸缩的问题。大家可以通过[这篇文章](https://www.nicolaferraro.me/2018/10/15/introducing-camel-k/)了解有关camel-k的详细信息。

目前Apache Camel的云化支持才刚刚开始， 预计在2019年夏天Apache Camel会有发布3.0版本，如果大家对Camel云化感兴趣的话，想参与到Camel 3.x的开发或者是想将Camel应用到生产系统中，可以[关注Camel社区的讨论](https://lists.apache.org/list.html?users@camel.apache.org)，并与我联系，我将尽我所能帮助大家。
