+++
author = "Hugo Authors"
title = "Apache Camel 2.22.0发布了"
date = "2018-07-15"
description = "Apache Camel 2.22.0 发布了，有哪些特性值的关注？"
tags = [
    "Camel",
    "Release"
]
categories = [
    "Java",
    "Camel",
]
+++


## 概述

Apache Camel 大约每个季度会发布一个新版本，Camel  2.22.0 如约在7月3号正式发布了。 这次版本发布最值得关注的更新是， Apache Camel 2.22.0 开始正式支持Spring Boot 2.x，当然考虑到维护问题 Apache Camel 2.22.0 不再支持Spring Boot 1.x， 这里建议Apache Camel的使用者尽快升级到Spring Boot 2.x。 如果现在还不想升级Spring Boot 1.x, 那就只能使用Camel 2.21.x （按照常规，Camel 2.21.x 在社区还会有半年左右的支持维护期）。值得一提的是[Spring Boot Start](https://start.spring.io/)已经支持Apache Camel， 如果使用Spring Boot 2.x会自动适配Camel 2.22.x版本。

Apache Camel 正式支持 Spring 5，由于Camel没有使用Spring5的独有特性，因此Apache Camel 2.22.0 依旧可以同Spring 4.x 一起使用，不过在后续的版本中会考虑修改Camel支持Spring的最低版本。

[ToD  EIP](https://github.com/apache/camel/blob/master/camel-core/src/main/docs/eips/toD-eip.adoc) 允许用户通过[表达式](https://github.com/apache/camel/blob/master/camel-core/src/main/docs/eips/expression.html)的方式来动态定义消息的接收节点，由于节点信息是动态创建了， 在Camel 2.22.0 中针对这部分进行了优化，如果消息接收节点是HTTP 节点的话， Camel会自动复用同一主机端口的连接，减少消息路由的系统负担。

[Rest DSL](http://camel.apache.org/rest-dsl.html)也在Camel 2.22.0里面进行优化。 首先是支持[Rest DSL](http://camel.apache.org/rest-dsl.html)支持对客户端的请求的Content-Type信息以及返回消息的Response-Type信息进行验证，其次是扩展了针对Swagger安全信息定义的支持，最后是 [Rest DSL](http://camel.apache.org/rest-dsl.html)的Producer端也支持通过endpointProperties的方式来进行配置了。

针对云化应用场景，Camel 2.22.0 也提供了一个新的[Service Registry](https://github.com/apache/camel/blob/master/camel-core/src/main/java/org/apache/camel/cloud/ServiceRegistry.java)的服务节点接口，支持将Camel的路由信息注册 Consul, etcd, Zookeeper常规的服务注册中心上的功能。 这样大家可以很方便地将定义好的Camel 路由以云化多实例应用的方式对外发布。

## 新增组件



在Apache Camel 2.22.0 中还新增加了如下的组件

- [camel-as2](https://github.com/apache/camel/blob/master/components/camel-as2/camel-as2-component/src/main/docs/as2-component.adoc) - 支持使用[AS2(Applicability Statement 2)协议](https://tools.ietf.org/html/rfc4130)进行传输。

- [camel-google-mail-stream](https://github.com/apache/camel/blob/master/components/camel-google-mail/src/main/docs/google-mail-stream-component.adoc) - 提供了采用流式方式访问 Google 邮箱。

- [camel-micrometer](https://github.com/apache/camel/blob/master/components/camel-micrometer/src/main/docs/micrometer-component.adoc) - 使用[Micrometer](http://micrometer.io/)来收集Camel内部的相关统计信息。

- [camel-mybatis-bean](https://github.com/apache/camel/blob/master/components/camel-mybatis/src/main/docs/mybatis-bean-component.adoc) - 支持使用[MyBatis](http://mybatis.org/) bean 标注的方式来对关系型数据库进行增删改查。

- [camel-service](https://github.com/apache/camel/blob/master/components/camel-service/src/main/docs/service-component.adoc) - 通过向服务注册中心获取访问示例来实现对多个服务实例的访问。

- [camel-web3j](https://github.com/apache/camel/blob/master/components/camel-web3j/src/main/docs/web3j-component.adoc) - 使用 [web3j](https://github.com/web3j/web3j) 客户端与[Ethereum](https://www.ethereum.org/)的相兼容的节点进行交互。

- [camel-rxjava2](https://github.com/apache/camel/blob/master/components/camel-rxjava2/src/main/docs/rxjava2-component.adoc) - 使用[RxJava2](https://github.com/ReactiveX/RxJava) 来实现Camel的响应式流组件。

- [camel-testcontainers](https://github.com/apache/camel/blob/master/components/camel-testcontainers/src/main/docs/testcontainers.adoc) - 支持使用[testcontainers](https://www.testcontainers.org) 来通过扩展[ContainerAwareTestSupport](https://github.com/apache/camel/blob/master/components/camel-testcontainers/src/main/java/org/apache/camel/test/testcontainers/ContainerAwareTestSupport.java) 采用docker方式启动相关的服务。



## 参考资料



1. [Apache Camel 2.22.0 Download](http://camel.apache.org/camel-2220-release.html)
2. [Apache Camel 2.22.0 Release Note](https://issues.apache.org/jira/secure/ReleaseNote.jspa?version=12342707&projectId=12311211)
3. [Claus Blog: Apache Camel 2.22 Released with Spring Boot 2 support](http://www.davsclaus.com/2018/07/apache-camel-222-released-with-spring.html)
