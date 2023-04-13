+++
author = "Hugo Authors"
title = "ApacheCon Asia 2021 集成主题介绍"
date = "2021-06-12"
description = "ApacheCon Asia 2021 集成主题介绍"
tags = [
    "Integration",
    "ApacheCon", 
]
categories = [
    "ApacheCon",
]
+++

## ApacheCon Asia 集成议题介绍

[ApacheCon Asia 2021](https://apachecon.com/acasia2021/zh/) 将于 8月6日至 8月8日在线上举行。 作为本次[集成主题](https://apachecon.com/acasia2021/zh/tracks/integration.html)的出品人， 笔者将向大家介绍[集成主题](https://apachecon.com/acasia2021/zh/tracks/integration.html)相关议题，目前大会报名已开启，欢迎大家[报名注册](https://www.huodongxing.com/event/3600137190322)。

集成就是将基于各种不同平台、用不同方案建立的异构系统整合在一起的方法和技术。 在ASF最有名的应用集成项目就是[Apache Camel](https://camel.apache.org/)有多种个项目提供了多种集成解决方案。这次[ApacheCon Asia 2021](https://apachecon.com/acasia2021/zh/) [集成主题](https://apachecon.com/acasia2021/zh/tracks/integration.html)给大家带来针对[Apache Camel](https://camel.apache.org/)项目的最新资讯，现在就随着我的脚步一窥究竟吧！

对于还不太了解[Apache Camel](https://camel.apache.org/)的朋友，建议大家可以关注[Claus](https://twitter.com/davsclaus) 和 [Andrea](https://twitter.com/oscerd2) 给大家带来的 [Apache Camel 3：下一代的企业集成](https://apachecon.com/acasia2021/zh/sessions/1071.html) 。[Claus](https://twitter.com/davsclaus) 和 [Andrea](https://twitter.com/oscerd2) 是[Apache Camel](https://camel.apache.org/)的主力开发，[Claus](https://twitter.com/davsclaus) 还是[Camel in Action](https://www.manning.com/books/camel-in-action-second-edition?)的作者。 他们主导了[Apache Camel](https://camel.apache.org/) 3的开发，因此在这个演讲中他们会介绍很多关于Camel 3的最新开发进展，以及Camel家族的新成员：

* [Camel K](https://camel.apache.org/camel-k/latest/) 是一个可以部署在K8S上面的无服务器集成平台，实现了低代码/无代码功能，并可以借助集成模式的力量迅速将大量Camel连接器拼接在一起。
* [Camel Quarkus](https://camel.apache.org/camel-quarkus/latest/) 将  [Apache Camel](https://camel.apache.org/manual/latest/index.html)集成能力与它的 [组件库](https://camel.apache.org/components/3.10.x/index.html)  和  [Quarkus 运行时](https://quarkus.io/) 有机地整合在一起了，这样我们可以在做应用集成开发的过程中也能享受到[Quarkus](https://quarkus.io/) 提供的应用加载的性能提升， [开发者乐趣](https://quarkus.io/vision/developer-joy) 以及 [容器优先](https://quarkus.io/vision/container-first)的好处。

通过使用 [Knative](https://knative.dev/)、[Quarkus](https://quarkus.io/) 的快速运行时和[Camel K](https://camel.apache.org/camel-k/latest/) ；我们可以实现一个面向云原生的无服务集成平台：如自动扩展、收缩为零以及基于事件的通信能力，以及[Apache Camel](https://camel.apache.org/)的强大集成能力。大家可以通过 [Christina Lin](https://twitter.com/Christina_wm)的[构建和维护一支Camel军团来解决你的云原生问题](https://apachecon.com/acasia2021/zh/sessions/1070.html)通过具体的示例从IDE工具、测试框架、扩展实例、配置、CI/CD流程到最后的监控，向大家展示使用[Camel Quarkus](https://camel.apache.org/camel-quarkus/latest/) 和[Camel K](https://camel.apache.org/camel-k/latest/)如何来开发一个云原生集成应用。

想了解[Camel Quarkus](https://camel.apache.org/camel-quarkus/latest/) 实现细节的小伙伴可以关注由冯征带来了 [Camel Quarkus介绍](https://apachecon.com/acasia2021/zh/sessions/1072.html)，他将从介绍[Camel Quarkus](https://camel.apache.org/camel-quarkus/latest/) 的基本理念，以及如何通过利用[Quarkus](https://quarkus.io/)的构建时间优化来提提升程序加载性能的。

随着事件驱动架构在云化网络服务的流行， 越来服务将通过事件响应的方式进行整合，最近 [Nicola Ferraro](https://twitter.com/ni_ferraro) 在[Camel K](https://camel.apache.org/camel-k/latest/) 基础上实现了一套非常方便的[Kamelets](https://camel.apache.org/camel-k/latest/kamelets/kamelets.html)。 开发者可以通过[Kamelets](https://camel.apache.org/camel-k/latest/kamelets/kamelets.html) 借助[Apache Camel](https://camel.apache.org/)提供的300多个组件，使用yaml定义自己的云化应用集成脚本，并借助 [Camel K](https://camel.apache.org/camel-k/latest/) 提供的工具部署到k8s上。想进一步了解Kamelets使用细节的话， 欢迎关注  [Nicola Ferraro](https://twitter.com/ni_ferraro) 的演讲 [从Camel到Kamelets：事件驱动型应用程序的新连接器](https://apachecon.com/acasia2021/zh/sessions/1073.html)。

[Jupyter](https://jupyter.org/) 是一个交互式笔记本，它本质是一个 Web应用程序，通过创建和共享程序文档，支持实时代码编写和运行。[Tadayoshi Sato](https://twitter.com/tadayosi) 将Camel Route也集成进了[Jupyter](https://jupyter.org/) 中， 这样我们就可以通过[Jupyter](https://jupyter.org/) 交互文档的方式向初学者展示Camel Route示例，并且让大家能基于交互式网页进行动手实践。想了解具体的实现细节的小伙伴可以关注一下[Tadayoshi Sato](https://twitter.com/tadayosi)的演讲  [使用脚本来进行集成 -- 利用Apache Camel和JBang轻松实现集成](https://apachecon.com/acasia2021/zh/sessions/1074.html)。

除了上面介绍的有关[Apache Camel](https://camel.apache.org/)的酷炫功能，我们还邀请了到了其他讲师来为大家分享[华为云ROMA是如何使用Apache  Camel](https://apachecon.com/acasia2021/zh/sessions/1075.html)， [Apache项目ARM构建](https://apachecon.com/acasia2021/zh/sessions/1089.html)，以及[和Apache Open Meeting 集成相关的议题](https://apachecon.com/acasia2021/zh/sessions/1089.html)， 大家可以访问[集成主题](https://apachecon.com/acasia2021/zh/tracks/integration.html)页面获取更多的与议题相关的信息。

## 关于ApacheCon

ApacheCon是Apache软件基金会的官方全球系列会议。自1998年以来，ApacheCon一直吸引着各个层次的参与者，在350多个Apache项目及其不同的社区中探索 "今日的技术"。在2020年和2021年，ApacheCon活动通过会议、主题演讲、真实世界的案例研究、社区活动等，在线上以虚拟的方式展示无处不在的Apache项目和以及最新的创新。欲了解更多信息，请访问 <http://apachecon.com/> 和 <https://twitter.com/ApacheCon> 。
