+++
author = "Hugo Authors"
title = "Apache Camel 3.x升级指南"
date = "2019-11-27"
description = "Apache Camel 2.x 至 3.x 升级指南。"
tags = [
    "Camel",
    "JAVA", 
]
categories = [
    "Camel",
    "JAVA", 
]
+++

年初的时候写过一篇有关[Camel 3.x 的介绍](https://willemjiang.github.io/apache/camel/2019/01/12/apache-camel-introducation.html)。 Camel 3.0 在经历了4个里程版本以及3个RC版本之后，发布了[3.0正式版](https://camel.apache.org/blog/release-3-0-0.html)。我想现在困扰大家最大的问题就是Camel 3.0 带来哪些变化呢？如果要从Camel 2.x 升级到 Camel 3.x需要注意哪些事情呢？ 其实社区开发者一直在更新一份叫做[升级指南](https://github.com/apache/camel/blob/master/docs/user-manual/modules/ROOT/pages/camel-3-migration-guide.adoc)的文档，里面记录了Camel 3.x的最新修改。 下面我会结合我的理解把重点的内容翻译成中文展现给大家。

### JDK支持

Camel 3 开始支持 Java 11， Camel 3 的早期版本还会继续支持Java 8， 但在后续的版本中会根据社区的发展会不再支持Java 8。

在Java 11中， JDK缺省是不带JAXB模块依赖的，所以如果你需要使用XML DSL 或者是camel-jaxb 模块的话，需要在POM中添加相关JAXB的依赖。

```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-core</artifactId>
    <version>2.3.0.1</version>
</dependency>
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-impl</artifactId>
    <version>2.3.2</version>
</dependency>
```

### Camel-Core模块化

为了更好支持模块化，在Camel 3中， 将原有的camel-core模块分离成了以下12个子模块

- camel-api
- camel-base
- camel-caffeine-lrucache
- camel-cloud
- camel-core
- camel-jaxp
- camel-main
- camel-management-api
- camel-management-impl
- camel-support
- camel-util
- camel-util-json

使用Maven的用户仍然可以通过采用原有的 camel-core的依赖自动获取以上模块的依赖， 当然你可以通过添加子模块的来减少系统对不必要的class的依赖。 同时我们也将其他在camel-core模块中的组件移出到其他的独立的模块：

- camel-attachments
- camel-bean
- camel-browse
- camel-controlbus
- camel-dataformat
- camel-dataset
- camel-direct
- camel-directvm
- camel-file
- camel-language
- camel-log
- camel-mock
- camel-properties
- camel-ref
- camel-rest
- camel-saga
- camel-scheduler
- camel-seda
- camel-stub
- camel-timer
- camel-validator
- camel-vm
- camel-xpath
- camel-xslt
- camel-zip-deflater

### CamelContext的变化

  Camel 3.x 只支持一个应用一个的CamelContext设置，不在像Camel 2.x支持多个CamelContext设置。 这样在 `@EndpointInject`， `@Produce`， `@Consume`里面的 *context*属性都被去除掉了。 同样在camel-cdi中，已经不再支持`@ContextName`。   如果要实现多CamelContext的支持，需要自己管理CamelContext和相关组件的映射关系。

  Camel 3.x 的有关全局属性的设置进行了修改， *getProperties* 已经修改为 *getGlobalOptions*。

  Camel 3.x 对 JMX支持模块进行了调整，可以通过添加 camel-management-impl依赖的同时，采用以下代码获取ManagedCamelContext。

  ```java
  ManagedCamelContext managed =
     camelContext.getExtension(ManagedCamelContext.class);
  ```

  *CamelContext* 中的API也做了一些简化，主要是提供与最终用户相关的API的支持。一些高阶使用场景例如SPI，与组件开发相关的API都被放在了 *ExtendedCamelContext* 中，大家可以通过adapt的方式获取相关的扩展CamelContext。

  ```java
  ExtendedCamelContext ecc = context.adapt(ExtendedCamelContext.class);
  ```

  与目录（Catalog）相关的API都被移动到了这个新加的 *CatalogCamelContext* 接口中，大家可以通过下面的方式获取相关的实例

  ```java
  CatalogCamelContext ccc = context.adapt(CatalogCamelContext.class);
  ```

  为了保持命名的一致性ModelCamelContext 中的 *loadRouteDefinitions* 修改为 *addRouteDefinitions*， *loadRestDefinitions*修改为 *addRestDefinitions*。 大家可以通过ModelHelper这个工具类来找到对应的load方法。

### 应用代码迁移修改

#### Spring Boot starter Maven 坐标的变化

在Camel3 中， 有关Spring Boot Starters的 `groupId` 已经由 `org.apache.camel` 改变成 `org.apache.camel.springboot`。 大家升级的时候需要注意这点变化。

#### Main class

Camel的`Main`类已经有`camel-core`转移至`camel-main`模块中， 所以升级的时候请注意更新相关依赖。

#### XML DSL修改

- 在`<setHeader>` 中的 *headerName* 修改为 *name*
- 在`<setProperty>` 中的 *propertyName* 修改为 *name*
- 在`<aggregate>` 中的有关完成情况判断的表达式添加了 *Expression* 的后缀来避免命名冲突， *completionSize* 修改为 *completionSizeExpression*， *completionTimeout* 修改为 *completionTimeoutExpression*
- 在自定义负载均衡模式的`<custom>` 修改为`<customLoadBalance>`
- 在`<secureXML>` 与XML Security 相关的秘钥参数定义属性由 *keyOrTrustStoreParametersId* 修改为 *keyOrTrustStoreParametersRef*
- Zip数据格式定义由 `<zipFile>` 修改为`<zipfile>`
- 为了支持多种熔断方式`<hystrix>`替换成 `<circuitBreaker>`

#### 删除的组件

Camel3移除了多Camel2已经废弃的组件,例如`camel-http`, `camel-hdfs`, `camel-mina`, `camel-mongodb`, `camel-netty`, `camel-netty-http`, `camel-quartz` 以及 `camel-rxjava`，转而由新版本所代替，详细请参加下面的重命名组件。

- camel-jibx组件 因为不支持JDK8 而被移除
- camel-boon 因为不能再支持JDK9及以后的版本而被移除
- camel-jetty 不在提供producer功能， 可以使用camel-http组件(原名 camel-http4)来发送HTTP请求
- camel-zookeeper 中的 route policy功能已经删除， 请使用ZookeeperClusterService 或者 camel-zookeeper-master 组件。
- camel-script 因为JDK11 不再支持`java.script`, camel-script 组件已经被移除。
- camel-twitter 中的 twitter-streaming 组件因为Twitter的Stream API已经废弃所以删除。

#### 重命名的组件

以往Camel为了支持多个版本的第三方组件， 在组件名后还加入的版本号， 在Camel3中对这些新版本的组件进行了重命名，将组件名中的版本号去掉，以替换原有的老版本组件。

- camel-test 组件重命名为 camel-dataset-test， 并且从camel-core 移到 camel-dateset 模块中。
- camel-http4 组件重命名为camel-http组件， 支持http以及https两种协议。
- camel-hdfs2 组件重命名为camel-hdfs组件， 支持hdfs 协议。
- camel-mina2 组件重命名为camel-mina组件， 支持mina协议。
- camel-mongodb3 组件重命名为camel-mongodb， 支持的协议为mongodb。
- camel-netty4 组件重命名为 camel-netty，支持的协议为netty。
- camel-netty4-http 组件重命名为 camel-netty-http, 支持协议为netty-http。
- camel-quartz2 组件改名为 camel-quartz，支持的协议为 quartz。
- camel-rxjava2 组件重命名为 camel-rxjava。
- camel-jetty9 组件重命名为 camel-jetty, 支持协议为jetty。

#### API变化

- Message Attachment API

  有关处理附件的API从`org.apache.camel.Message` 转移到新的`camel-attachments`模块中的`org.apache.camel.attachment.AttachementMessage`。
  大家可以通过以下的代码来访问附件信息。

  ```java
    AttachementMessage am = exchange.getMessage(AttachmentMessage.class);
    am.addAttachement("myAtt", new DataHandler(...));
  ```

- Message Fault API

  由于Fault API只用于处理SOAP-WS fault消息，因此在`org.apache.camel.Message`中已经把fault API去掉了。 如果想在 `camel-cxf`以及`camel-spring-ws`组件中处理Fault消息的话，需要在相关组件或者节点层面打开`handleFault`参数来进行处理。

- Message getOut  

  hasOut和getOut这两个方法在Camel 3中已经被标准为遗弃方法， 推荐使用`Message`中提供的getMessage方法来获取需要处理的消息。（为了提供向前兼容性的保证，在Camel内部还是会针对区分了IN,OUT message的场景还是会使用支持的方法区分Out Message）。

- ActiveMQ

  `activemq-camel` 已从ActiveMQ迁入到Camel， 你可以使用`camel-activemq`组件与ActiveMQ交互，对应的组件名也从`org.apache.activemq.camel.comopnent.ActiveMQComponent`改名为`org.apache.camel.component.activemq.ActiveMQComponent`。

- API迁移变化

  在升级到Camel3 的过程可能会出现相关包迁移的问题，大家可以通过查找[相关文档](https://github.com/apache/camel/blob/master/docs/user-manual/modules/ROOT/pages/camel-3-migration-guide.adoc#moved-apis)获取详细信息。
