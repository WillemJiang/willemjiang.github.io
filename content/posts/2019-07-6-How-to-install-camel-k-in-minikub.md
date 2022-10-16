+++
author = "Hugo Authors"
title = "如何在minikube上安装camel-k"
date = "2019-07-06"
description = "本文主要介绍在minikube上如何安装camel-k。"
tags = [
    "Camel",
    "JAVA", 
]
categories = [
    "Camel",
]
+++


[Apache Camel-K](https://github.com/apache/camel-k/)这个项目是在2018年8月份开始启动的， 通过[Operator](https://github.com/operator-framework/operator-sdk)的方式将Camel路由规则部署到K8S集群中。 使用过Camel的朋友应该知道Camel的内核不大，提供了实现了EIP模式的实现，但是Camel的第三方组件很多，为了能够让Camel路由规则运行起来，我们需要在工程文件中加入这些第三方的依赖。 为此Camel-K内部会根据需要加载的Camel路由规则自动生成工程文件，并完成编译，以及docker 镜像的生成工作，最后在K8S集群中完成相关的部署工作。

![image-20190706215407435](/images/camel/image-camel-k.png)

### 安装minikube

对于k8s的开发者来说，要拥有一个k8s的集群还是挺不容易的一件事， minikube可以让我们在自己的笔记本电脑上通过一台虚拟机就能把k8s运行起来（当然只是单节点）。

大家可以通过参考minikube的[安装文档](https://kubernetes.io/docs/tasks/tools/install-minikube/)来安装minikube。

运行minikube需要注意以下几点：

1. minikube 缺省使用~/.minikube/machine 来存储于虚拟机相关文件。
2. cache目录~/.minikube/cache会包含k8s安装相关的文件，如果你需要在其他的环境下安装minikube，可以考虑拷贝cache目录下面文件来提高minikube的启动效率。

下面给出的脚本是如何创建camelk需要的minikube 虚拟机的

```
KUBERNETES_VERSION=v1.12.0
MEMORY=10240
CPUS=4
DISK_SIZE=50g
# blow away everything in the camelk profile for a clean install
echo "Deleting the camelk profile"
minikube delete --profile camelk

# configure camelk profile
echo "Create the profile of camelk and do some setup work"
minikube profile camelk
minikube config set kubernetes-version ${KUBERNETES_VERSION}
minikube config set memory ${MEMORY}
minikube config set cpus ${CPUS}
minikube config set disk-size ${DISK_SIZE}

# enable the local registry
minikube addons enable registry

# start minikube
echo "Starting the minikube"
minikube start -p camelk --vm-driver hyperkit --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"

```

因为minikube启动k8s的时候，需要从gcr.io上面下载镜像，如果在国内因为众所周知的原因，我们需要通过设置代理的方式才能下载相关的镜像， 这里我需要配置一下本地的HTTP代理， 由于minikube的 NO_PROXY 只支持单一IP设置，我们需要将minikube使用的local registry地址去掉。

```
export HOST_IP=192.168.1.100
export HTTP_PROXY=http://${HOST_IP}:1087
export HTTPS_PROXY=http://${HOST_IP}:1087
# Using kubectl get services to look up the docker registry address
# Check k8s registry sevice address, add it into NO_PROXY list
# In this case, we need to add 10.111.125.6 into NO_PROXY
export NO_PROXY=localhost,127.0.0.1,10.111.125.6
```

由于在minikube中需要先启动k8s之后才能知道本地docker registry的地址， 因此我们需要在第二次启动minikube的时候， 才能把minikube本地的docker registry地址加进去。

你可以通过使用minikube stop停止minikube所在的虚拟机，在通过设置代理环境变量的方式更新需要关闭代理的信息。

### 安装Camel-K

Camel-K 包含了kamel命令行指令以及operator的镜像文件以及builder镜像，大家可以通过camel-k github release页面下载到相关的二进制文件，通过运行kamel命令安装operator以及builder镜像。

大家设置kamel执行路径之后，可以通过`kamel install`下面的命令安装camel-k 运行时。

可以使用`kamel reset`重置当前的camel-k的安装。

使用`kamel run xxx `来上传相关的camel 路由规则。

有关Camel-K的详细安装可以参见[Camel-K安装文档](https://github.com/apache/camel-k#installation)。
