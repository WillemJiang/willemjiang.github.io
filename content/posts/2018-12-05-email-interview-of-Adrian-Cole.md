+++
author = "Hugo Authors"
title = "专访Zipkin项目Leader Adrain Cole"
date = "2018-12-05"
description = "最近有幸通过Email采访了Zipkin项目的主要开发维护人员 Adrian Cole， 和他聊了一下有关 Zipkin项目的背景以及用户是如何使用Zipkin构建分布式追踪系统。特别值得一提的是Adrian一直在世界各地举办分布式追踪的workshop，通过sites（局点）文档收集到了大量用户在使用Zipkin构建分布式追踪系统一手资料。"
tags = [
    "Zipkin",
    "JAVA", 
]
categories = [
    "OpenSource",
]
+++


最近有幸通过Email采访了Zipkin项目的主要开发维护人员 Adrian Cole， 和他聊了一下有关 Zipkin项目的背景以及用户是如何使用Zipkin构建分布式追踪系统。特别值得一提的是Adrian一直在世界各地举办分布式追踪的[workshop](https://cwiki.apache.org/confluence/display/ZIPKIN/Workshops)，通过[sites](https://cwiki.apache.org/confluence/display/ZIPKIN/Sites) （局点）文档收集到了大量用户在使用Zipkin构建分布式追踪系统一手资料。

现在，先简单介绍一下Adrian， Adrian一直在从事云计算相关开源项目的开发， 是开源项目[Apache jclouds](https://jclouds.apache.org/)和[OpenFeign](https://github.com/OpenFeign)的创始人。 最近几年，他专注于分布式跟踪领域，是[OpenZipkin](https://github.com/openzipkin/) 项目的主要开发维护人员。 Adrian目前在Pivotal Spring Cloud OSS团队工作。在加入Pivotal之前，他还在Twitter（Zipkin的诞生地），Square，Netflix工作过。



### 总所周知Zipkin项目起源于Twitter， 您能给我们介绍一下项目的相关背景吗？



Zipkin是由Twitter内部构建的分布式追踪项目，于2012年开源。它最初被称为BigBrotherBird，因此即使在今天，Zipkin定义http消息头也被命名为“B3”。 Twitter早期因为业务发展迅猛，经常会出现系统过载情况。每当出现这种情况时，用户会看到一条[搁浅的鲸鱼](http://www.yiyinglu.com/failwhale/cn/)显示在页面上。 Zipkin这个名字也与鲸鱼有关，因为Zipkin是鱼叉的意思，构建初衷是为了追踪“搁浅的鲸鱼”相关的系统延迟问题。Zipkin的成功除了和Twitter的的品牌加持有关，其他因素也起到很大作用：一是Zipkin包含了客户端、服务器、用户界面等所有分布式追踪需要的组件；此外，Twitter Engineering上一篇介绍Zipkin的[博客](https://blog.twitter.com/engineering/en_us/a/2012/distributed-systems-tracing-with-zipkin.html)也引起了轰动。随着时间的推移，Zipkin业界知名的分布式追踪工具 。



### 分布式调用追踪对微服务监控的价值，为什么大家要为微服务建这样的追踪系统？



这里我想引用Netflix的[局点文档](https://cwiki.apache.org/confluence/display/ZIPKIN/Netflix)（Zipkin的用户使用报告）中的描述来总结分布式追踪系统的价值：

​	*“ 其商业价值在于为系统提供了一个操作层面的可视化界面，同时提升开发人员的生产效率。”*

对于微服务系统来说，如果没有分布式追踪工具的帮助，要了解各个服务之间的调用关系是相当困难的。 即使对于非常资深的工程师来说，如果只依靠追踪日志文件，分析系统监控信息，也是很难快速定位和发现微服务系统问题的。 分布式调用追踪系统可以帮助开发人员或系统运维人员及时了解应用程序及其底层服务的执行情况，以识别和解决性能问题或者是发现错误的根本原因。分布式追踪系统可以在请求通过应用系统时提供端到端的视图，显示应用程序底层组件相关调用关系，从而帮助开发人员分析和调试生产环境下的分布式应用程序。



### 在业界已经大量采用微服务架构的今天，Zipkin在工业界微服务系统问题追踪方面扮演了很重要的角色，您能给我们介绍一下业界是如何使用Zipkin项目的吗？

在回答这个问题之前，我们先简单介绍一下[Zipkin的系统架构](https://zipkin.io/pages/architecture.html)。Zipkin包含了前端收集以及后台存储展示两部分。为了追踪应用的调用情况，我们需要在应用内部设置相关的追踪器来记录调用执行的时间以及调用操作相关的元数据信息。一般来说这些追踪器都是植入到应用框架内部的，用户应用程序基本感知不到它的存在。如下图所示当被监控的客户端向被监控的服务器端发送消息时，被监控客户端和被监控服务器端的追踪器会分别生成一个叫做Span的信息通过报告器（Report）发送到Zipkin后台。一次跨多个服务的调用一般会包含多个Span信息，这些Span信息是通过客户端与服务器之间传输的[消息头](https://github.com/openzipkin/b3-propagation)进行关联的。 后台会通过收集器（collector）接收Span消息，并进行相关分析关联，然后将数据通过存储模块存储通过查询API起来供UI展示。

![Zipkin architecture](https://zipkin.io/public/img/architecture-1.png)

Zipkin在项目开源之初就包含了一个完整的追踪解决方案方便大家上手，同时通过[传输协议](https://github.com/openzipkin/zipkin-api)以及相关[消息头](https://github.com/openzipkin/b3-propagation)开源， Zipkin很容易集成到用户的监控系统中。这让Zipkin能够在众多的追踪系统中脱颖而出，成为工业界最常用的追踪工具。

在2015年的时候我们发现不是所有人都有分布调用追踪的系统使用经验，他们不太了解如何成功搭建分布式追踪系统需要做哪些工作。因此我们整理了很多业界使用Zipkin的相关局点资料，并在Google Drive上创建了相关[文档目录](https://drive.google.com/drive/u/1/folders/0B0tSnQT3uGdAflJLdEFhVzl6dEtrN0tPOFhmclFpOFJ5a01nZnFZaXdxdUJ2TUJfOGxhWUE)存放这些资料。考虑到大家访问Google Drive可能会不太方便，后来我们创建了[ wiki](https://cwiki.apache.org/confluence/display/ZIPKIN/Sites)来分享如何使用Zipkin，让更多人了解其他人是如何使用Zipkin来解决追踪系统中存在的问题的。

在这里你可以看到像[Netflix](https://cwiki.apache.org/confluence/display/ZIPKIN/Netflix)这样的大厂是如何使用Zipkin以及Elasticsearch处理每天高达5TB的追踪数据，[Ascend Money](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=95651348) 是如何将公有云和私有云结合在一起使用Zipkin，[ Line](https://cwiki.apache.org/confluence/display/ZIPKIN/LINE) 是如何将Zipkin与[armeria](https://github.com/line/armeria)结合进行异步调用追踪的，以及[Sound Cloud](https://cwiki.apache.org/confluence/display/ZIPKIN/SoundCloud) 是[如何结合Kubernetes Pod 的元数据信息清理Zipkin追踪数据的](https://developers.soundcloud.com/blog/using-kubernetes-pod-metadata-to-improve-zipkin-traces)。这里我们也欢迎更多的中国用户能够在此分享你们使用Zipkin的经验。

对了，如果你是Zipkin用户, 请抽空给我们的[代码仓库](https://github.com/openzipkin/zipkin)加星，这是对我们最大的鼓励。

### 我们知道Zipkin项目目前在生产环境中大量使用，他们是直接使用这些项目还是依据自己的需要对项目进行了相关的修改？

因为Zipkin项目运作是建立在用户吃自己的狗粮 (使用自己开发的软件）的基础上， 很多新工具都是先在用户内部使用，然后开源变成通用项目。 例如[zipkin-forwarder](https://github.com/ascendcorp/zipkin-forwarder)这个项目就是Ascend结合自己的业务需要实现的跨多个数据中心转发数据实验性项目。 Yelp实现了一个[Zipkin代理](https://github.com/drolando/zipkin-mux)用来读取多个Zipkin集群的数据。 LINE在内部开发了一个代号为“project lens”的项目来替换Zipkin UI。

现在Zipkin的使用案例很多，不同使用案例对应的架构也不相同。这并不是说用户没有直接采用Zipkin 项目。例如[Mediata](https://cwiki.apache.org/confluence/display/ZIPKIN/Medidata)就在他们的局点文档中描述了他们直接使用Zipkin的发行版，没有进行任何修改。


### Zipkin项目缺省是支持中等规模的使用场景， 为了支持更大规模的使用场景，我们需要做些什么？


大规模的使用场景意味着更多的数据量，大规模用户通常会从成本以及处理或清理数据的能力来考虑这个问题。 例如，[SoundCloud](https://cwiki.apache.org/confluence/display/ZIPKIN/SoundCloud)实现了[基于kubernetes元数据清理数据的工具](https://developers.soundcloud.com/blog/using-kubernetes-pod-metadata-to-improve-zipkin-traces)。 以往几乎所有Zipkin大型局点都将追踪数据存储在Cassandra。 现在，像[Netflix](https://cwiki.apache.org/confluence/display/ZIPKIN/Netflix)这样的大型局点开始采用Elasticsearch来存储数据 。 几乎所有大型局点都使用Kafka来进行大规模的数据传输。 出于考虑效率的原因，较小的站点会采用不同的传输方式。 例如，[Infostellar](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=95655004)使用[Armeria](https://github.com/line/armeria) （一个类似于gRPC的异步效RPC库）来传输数据。


大多数成熟局点也会担心数据大小而使用采样的方式来解决问题。因为我们很难为不同类型的局点设计一个通用工具，Zipkin为大家提供了多种采样选择，其中包括基于http请求的表达式的配置方式，也有支持开发客户端[速率限制采样器](https://github.com/openzipkin/brave/pull/819)。 例如，使用Spring的局点有时会使用配置服务器实时推送采样率，这样可以在不干扰通常的低采样率的情况下抓取有趣的痕迹。



大多数局点使用客户端采样来避免启动无用的跟踪。 例如，spring cloud sleuth的默认策略不会为健康检查等管理流量创建跟踪。  这些是通过http路径表达式完成的。 一些基于百分比的采样（例如1％或更少的流量）在数据激增时仍然存在问题。即使采样率为1％，当流量达到1000％的时候也可能会出现问题。因此，我们始终建议对系统进行冗余配置，也就是说不仅要为正常流量分配带宽和存储空间，还要提供一定的余量。但这不是一个最好的解决方案，我们开玩笑的将其称为OPP （over-provision and pray，美国流行歌曲名），通过冗余保障还有祈祷来帮我们应对数据激增的问题。



值得注意的是许多局点站并不打算“演进”到自适应（自动）采样。 例如，Yelp在定制的无索引的廉价存储中进行100％的数据消费。这样可以在不干扰通常的低采样率的情况下直接抓取有趣的痕迹。当然在Zipkin社区中有相[关自适应采样配置的设计讨论](https://cwiki.apache.org/confluence/display/ZIPKIN/Firehose+mode)，以突出问题区域而不会增加基本采样率的复杂性。自适应是一个有趣的话题，绝对可以应对数据激增问题，但大家通常会用不同的方法来实现自适应。欢迎大家就这个问题与我深入讨论。



### 目前Zipkin在线局点日常处理span的数据流大概是多少？ Zipkin缺省能支持存储一个月的数据吗？在Zipkin的存储方面你有什么好的建议？



Yelp处理的Span数据可能是最多的，因为它们会将100％的数据集中到专用存储群集中。但是他们也没有公布数字。Netflix的系统大约会将240 MB /秒的span数据推送到后台（大家可以算算这里有多少条span信息），一般来说一条Span数据通常不会超过1KiB，甚至远远低于1KiB。



关于数据存储，大多数网站出于成本的考虑只保留数天的数据。不过有些用户自己提供“最喜欢的追踪”功能来长时间保留追踪数据。关于Span大小，我们建议大家使用brave或zipkin-go等工具中自带的默认值，然后根据大家的具体需求添加一些数据标签（决定是否保留数据）来提升资源利用率。



我们也不建议把span作为日志记录器。 OpenTracing开了这个坏头，他们把日志工具和分布式追踪API相混淆，甚至在Span中的API定义了“[microlog](https://github.com/opentracing/basictracer-go/blob/master/raw.go#L33)”。据我所知没有一个追踪系统能在系统内部把常规日志记录工作做得很好的，因为追踪系统和常规日志记录系统是两个完全不同的系统， 这样做只会损害追踪系统运行效率。



我们建议大家根据自己的需要选择最佳的存储方式。 例如，[Infostellar](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=95655004)直接将追踪数据转发到Google Stackdriver上进行存储。 如果你更熟悉Elasticsearch而不是Cassandra，那么请使用Elasticsearch，反之亦然。 但是我们建议大家不要使用MySQL，因为我们的MySQL架构不是为了高性能而编写的。



### Zipkin是如何对接分析系统（[Amazon X-Ray](https://aws.amazon.com/xray),[ Apache SkyWalking](http://skywalking.apache.org/) or[ Expedia HayStack](https://github.com/ExpediaDotCom/haystack)）的？对此你有什么好的建议？



你提到的所有项目都是通过接收Zipkin数据实现集成的，[Infostellar](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=95655004)在这方面有比较好的网站文档可以参考。



[SkyWalking](http://skywalking.apache.org/)也提供了接入Zipkin数据的集成方式。[ SkyWalking](http://skywalking.apache.org/)可以接受Zipkin格式的数据，这样无论是Zipkin的探针，还是其他工具，如Jaeger，只要使用相同格式的工具都可以接入到[SkyWalking](http://skywalking.apache.org/)中。需要指出的是现在很多追踪工具都支持Zipkin格式，通过支持Zipkin格式可以很容易完成对其他追踪系统的集成工作。



我对[Haystack](https://github.com/ExpediaDotCom/haystack)与Zipkin集成工作的有一定的了解。他们通过Hotels.com提供的[Pitchfork](https://github.com/HotelsDotCom/pitchfork)这个工具，将数据分别发送给Zipkin和[Haystack](https://github.com/ExpediaDotCom/haystack)。Haystack的系统可以对Zipkin数据进行服务图聚合等处理，这样就不需要使用Zipkin的UI来处理数据了。



### OpenZipkin是什么？这些年Zipkin社区是怎么发展起来的？如何加入到Zipkin社区中？



2015年，社区有人呼吁[把项目迁移到一个更开放的地方](https://groups.google.com/forum/#!msg/zipkin-dev/hug_bWIqdLY/gli4Qe1RrQAJ)，以便更快地发展项目。我们经过三个月的努力，于2015年7月在Github上成立了“[OpenZipkin](https://github.com/openzipkin/)”小组。社区在此之后快速发展，大量用户在社区中交流他们在构建分布式追踪系统所遇到的问题和挑战。当社区决定把首选语言定为Java而不是Scala后，我们重新编写了服务器。我们有许多[示例项目](https://github.com/openzipkin/sleuth-webmvc-example)帮助大家上手，而且我们认为与他人交流是最好的学习方式。如果你不熟悉追踪，最容易参与的方法就是参与到我们的[gitter](https://gitter.im/openzipkin/zipkin)讨论中来。



### Zipkin最近加入ASF孵化器，这对于Zipkin来说意味着什么？



Zipkin发展了一段时间后，CNCF联系我们加入，而我们考虑的是加入阿帕奇软件基金会（ASF)或者什么也不加入。当时的社区看不到加入基金会的好处，我们当时选择了什么不加入基金会。然而，社区不断发展壮大，我们也有责任成长。特别是当我们通过SkyWalking的在ASF孵化对ASF有了更深入的了解。 因为基金会要求旗下项目站在厂商中立的角度来考虑问题的，这样可以帮助Zipkin站在社区的角度上考虑如何独立发展。ASF的文化和我们也更匹配，因此Zipkin于今年8月份刚成为阿帕奇孵化器项目。
