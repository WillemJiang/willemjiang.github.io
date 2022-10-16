+++
author = "Hugo Authors"
title = "红帽如何构建OpenShift4"
date = "2019-02-23"
description = "本文介绍红帽是如何已上游优先的方式进行OpenShift4产品."
tags = [
    "OpenShift",
]
categories = [
    "Redhat",
]
+++


众所周知，红帽的OpenShift是建立在Kubernetes 基础之上的， 但是红帽是如何将上游开发的Kubernetes整合在OpenShift之中的？ 很多人对这个问题都很感兴趣， 最近在伦敦举办的[OpenShift Commons](https://commons.openshift.org/)大会上， 红帽OpenShift产品经理 Mike Barrett向我们介绍OpenShift产品开发的细节。

本文对Mike的演讲前半部分进行了节选翻译，试图向大家展示红帽是如何在社区项目基础上构建企业级软件产品的，大家可以通过[此链接](https://www.youtube.com/watch?v=dYcArJHEBZ8)观看完整的演讲内容。

在通常情况下每一个OpenShift版本发布会经历4到5个Sprint，每个Sprint会持续3周， 这是一个比较快的发布周期。一般来说我们会用3个Sprint来修复bug，这样看来一般我们会有4个Sprint的时间来做下一个版本的规划。如下图所示，OpenShift的路线图基本上是按照季度来进行规划的。

![OpenShiftRoadMap](/images/openshift4/OpenShiftRoadMap.png)

对于上游Kubernetes的使用，基本上是和大家一样直接使用上游的产品，我们的升级周期很快。在一个OpenShift的产品开发周期内，我们会对上游Kubernetes进行两次rebase操作， 由于OpenShift有很多第三依赖， 在QE阶段，我们会一直关注Kubernetes的维护分支，通过Cherry Pick的方式将重要的bug fix移植到我们的产品分支上。 如果我们在QE阶段发现了bug， 我们会先在Kubernetes上游修复Bug，然后再将bug修复移植到我们产品分支中。 如果这个时候社区正在开发Kubernetes 1.12， 我们会先修复Kubernetes 1.12的bug，然后将相关补丁移植到我们现在基于Kubernetes 1.11 开发的版本上。 这样可以保证我们随时可以从社区开发的Kubernetes获取可用的版本（不用再升级的Kubernetes的时候重新再打补丁）。

![ReleaseAndFix](/images/openshift4/ReleaseAndFix.png)

更有意思的是随着时间的推荐，其他与OpenShift相关的模块也在不断发展，例如与OpenShift相关的容器实现RHEL也一直在修复Bug，修复CVE问题，不断向前发展，所以我们也在不断地rebase相关RHEL版本。同时我们还有一大票正在开发的中间件、运行时以及开发框架，因此我们需要持续集成相关的产品，保证系统稳定。这就要求我们的开发团队之间需要不断地获取到相关的组件并且进行集成测试。

![ContainerRefreshes](/images/openshift4/ContainerRefreshes.png)

OpenShift的构建系统(OpenShift Build System) 每天会产生400多个容器，我们会在400个容器之上构建我们的OpenShift产品，虽然我们直接从社区获取了Kubernetes，但是我们依托了这个构建系统来帮助我们构建企业级的Kubernetes，这是红帽构建企业级产品的特有价值。 我们的开发者每天会在Kubernetes上游贡献代码，目前我们是Kubernetes的第二大贡献者。 同时我们的开发者还是相关Kubernetes SIG的领导者，我们没有专门选择SIG方向，这些方向是代表了客户选择的，是由我们的客户每天向我们咨询的问题或者升级需要我们解决的问题中来。这些方向和生产系统密切相关，其中不但有认证相关的，也有与存储相关的，还有有和网络相关的内容，这些都是我们的客户在日常使用Kubernetes需要我们解决的实际问题。  

![SIG Leadership](/images/openshift4/SIGLeadership.png)

在此之外我们还做了很多与集成相关的工作。当你安装完OpenShift，你可以获取到非常完备的网络组件，让你能够很方便地与你的边缘网络进行集成；你还可以获得许多与企业应用部署相关的支持工具，同时我们还提供了很多缺省的安全支持， 以及缺省的Jenkins支持。

![OpenShift AddOns](/images/openshift4/AddOns.png)

那OpenShift4基石是什么？ 这里我想和大家分享几个数字。全球有超过1000的企业用户在免费使用OpenShift；32000 这是来自于OpenShift3的用户支持case数；17000+，这是红帽工程师在Kubernetes社区中的提交次数；500+，这是每年我们的咨询团队与全球3000强企业用户交互数；122，这是我们的工程团队在OpenShift中进行的各种发布的总和；250M+，这是我们花在收购各种用来完善OpenShift相关的技术所花费的美元（红帽有收购商业公司技术，并将其开源用来回馈社区的传统）；4000,这是用户在OpenShift.com上每天创建的pod数。 基于这些积累的经验我们决定在以下几个方面加强对OpenShift4的投资。

![OpenShift4](/images/openshift4/OpenShift4.0Thems.png)
