+++
author = "Hugo Authors"
title = "Apache ServiceComb Pack 0.5.0 新特性"
date = "2019-08-27"
description = "Apache ServiceComb Pack 0.5.0 新特性介绍"
tags = [
    "ServiceComb",
    "PACK",
    "JAVA",
    "Release", 
]
categories = [
    "JAVA",
]
+++


## ServiceComb Pack 0.5.0 新功能介绍

[ServiceComb Pack 0.5.0](https://github.com/apache/servicecomb-pack) 已经[发布](http://servicecomb.apache.org/release/pack-downloads/)了， 在这个版本中我们有好几个重大更新，例如使用状态机来管理事务的执行状态， 新的Saga事务管理UI，以及Omega端的异步事务支持。大家可以在此查阅到详细的[版本更新日志](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12321626&version=12345242)。

### 为什么要使用状态机管理事务状态

在ServiceComb Pack 中一个分布式事务是由多个相关联的本地事务所组成， Omega负责追踪本地的事务运行情况，并将事务执行事件发送到Alpha端， Alpha作为事务协调器，会根据接收的事务事件在后台维护一套事务的状态信息，并根据预先定义的规则与Omega之间进行协调。

在0.5.0之前的版本我们是将事务执行事件都存放在数据库中，由后台的扫描程序来判断事务的执行状态。这样做的好处是数据接收和处理分离，但是坏处是随着业务复杂度的提升，扫描器依赖的SQL就会变得很复杂。 另外使用扫描器我们很难提供集群支持。因此在[张磊](https://github.com/coolbeevip)的主导下，ServiceComb Pack 开始探索使用状态机来管理事务的状态。

### Saga 事务状态机实现

ServiceComb Pack Alpha 收到 Omega 发送的事务消息（全局事务启动、全局事务停止，全局事务失败，子事务启动，子事务停止，子事务失败等等）后完成一些动作（等待、补偿、超时）和状态切换。这些状态转换可以构建在Akka的有限状态机模型（FSM）之上，一个 FSM 可以描述成一组具有如下形式的关系 :

**State(S) x Event(E) -> Actions (A), State(S')**

这些关系的意思可以这样理解：

> 如果我们当前处于状态S，发生了E事件，则我们应执行操作A，然后将状态转换为S’。

下图为Saga事务信息的状态转换图，通过这个转换图我们可以很方便地描述。

![image-saga-state-diagram](/images/pack/saga_state_diagram.png)

由于状态机的设计必须遵许已知的事件类型和顺序，而事件的发送又依赖于开发者对于 Omega 组件的使用，为了避免未知的情况出现而导致的不可控情况，本设计遵循以下约定

- 状态机只处理已知的有序事件组合情况
- 对于未知的事件组合情况统一将状态设置成 SUSPENDED 并结束
- 对于 SagaTimeoutEvent 事件统一将状态设置成 SUSPENDED 并结束
- 状态机内部会记录完整的事件记录以及状态转换记录，以便于问题的分析以及手动补偿。

目前 Alpha的状态机已经具备代替基于表扫描的功能， 并且在如下方面有比较好的提升：

* 性能提升一个数量级，事件吞吐量每秒1.8w+，全局事务处理量每秒1.2k+
* 内置健康指标采集器，可清晰了解系统瓶颈
* 通过多种数据通道适配实现集群高可用
* 向前兼容原有 gRPC 协议
* 全新的可视化监控界面
* 开放全新的 API

大家可以参见ServiceComb Pack 的[状态机使用手册](https://github.com/apache/servicecomb-pack/blob/master/docs/fsm/fsm_manual_zh.md)获取详细的使用配置信息。

### Saga异步事务支持

最近在ServiceComb 社区中有大量的有关异步调用的支持的咨询，因此我们结合大家的述求在业务代码层提供了有关一些API来显示传递事务上下文信息，以及配合异步调用的场景结束整个Saga事务。

#### 显式传递事务上下文信息

在ServiceComb Pack 中，Saga事务以及与之相关的本地子事务是通过本地事务ID以及全局事务ID联系在一起的。在缺省情况下，Omega端采用ThreadLocal的方式存储事务的上下文（[OmegaContext](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/OmegaContext.java)）信息。但是在异步环境下，特别是当调用线程发生了切换，如果事务上下文不能在这些线程中顺利传播，Omega端是无法正确进行事务追踪的。在ServiceComb Pack 0.5.0 中，我们引入了[TransactionContext](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContext.java)让用户可以在业务逻辑方法中显示传递与事务相关的上下文信息。

1. 在事务创建函数中获取[TransactionContext](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContext.java), 在调用线程切换后的业务代码将TransactionContext传递进业务代码.

   ```java
   private TransactionContext localTxContext;
   @Autowired
   OmegaContext omegaContext;

   @SagaStart
   public void foo(BarCommand cmd) {
     localTxContext = omegaContext.getTransactionContext();
     // There maybe some thread change
     someRpc.asyncSend(cmd, localTxContext);
   }
   ```

2. Omega 会分析 TransactionContext类型的参数，将相关的上下文传递下去

   ```java
   @Compensable
   public void asyncSend(BarCommand cmd, TransactionContext injectedTxContext) {
     // Omega can setup the Omega context with injectedTxContext instance
   }
   ```



如果事务调用跨越了进程，我们可以通过[ServiceComb Pack Transport](https://github.com/apache/servicecomb-pack/tree/master/omega/omega-transport)的方式来进行传递。 但是如果[ServiceComb Transport](https://github.com/apache/servicecomb-pack/tree/master/omega/omega-transport)还没有实现相关的业务代码，或者是相关的Transport没有提供对应传递Context的接口，那我们应该怎么做？

[TransactionContextProperties](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContextProperties.java) 就是用来解决这一问题的。 简单来说就是你可以扩展你的业务对象，通过实现[TransactionContextProperties](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContextProperties.java)接口使其支持传递本地事务ID以及全局事务ID。这样你的业务对象就具备了事务调用信息传播的能力， 在Omega端会自动分析事务标注函数中的参数，将[TransactionContextProperties](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContextProperties.java)信息注入到OmegaContext中。

Service A, 向JMS服务端发送扩展事务信息的业务指令，

```java
public class BarCommand {}
public class BarCommandWithTxContext
  extends BarCommand implements TransactionContextProperties {
  // setter getter for globalTxId
  // setter getter for localTxId
}

@SagaStart
public void foo() {
  // Create the BarCommand with TransactionContextProperties
  BarCommandWithTxContext cmdWithTxContext = new BarCommandWithTxContext(cmd);
  cmdWithTxContext.setGlobalTxId(omegaContext.globalTxId());
  cmdWithTxContext.setLocalTxId(omegaContext.localTxId());
  messageBroker.sendCommand(cmdWithTxContext);
}

```

Omega会检测调用参数是否实现[TransactionContextProperties](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/TransactionContextProperties.java)接口，如果实现了会将调用信息刷新到[OmegaContext](https://github.com/apache/servicecomb-pack/blob/master/omega/omega-context/src/main/java/org/apache/servicecomb/pack/omega/context/OmegaContext.java)中，这样Service B 可以按照原来的方式处理业务。

JMS Listener方法

```java
@Compensable
public void listen(BarCommandWithTxContext cmdWithTxContext) {
  // Omega will setup the transaction if the parameter implements the TransactionContextProperties
}
```



#### 手动结束Saga事务

通常情况下，`@SagaStart`标注的函数发起分布式事务同步调用，调用执行结束，函数返回。我们可以通过函数返回来判断整个Saga事务是否结束。 由于异步服务调用的引入，让我们无法根据`@SagaStart`标注的调用探知Saga事务结束的时间， 于是我们在ServiceComb Pack 0.5.0 中引入了`@SagaEnd` 这一标注让用户显示指定某个函数结束即标志整个Saga事务调用结束。

使用`@SagaEnd` 标注之前，需要设置 `@SagaStart`中的`autoClose`属性，该属性用于控制`@SagaStart`所标记的方法执行完成后是否自动发送SagaEndedEvent（默认值为`true`）。当`autoClose=false`时你需要使用`@SagaEnd`标注哪个函数结束之后发送`SagaEndedEvent`，比如：

Service A:

```java
@SagaStart(autoClose=false)
public void foo() {
  restTemplate.postForEntity("http://service-b/bar", ...);
}
```

Service B:

```
@GetMapping("/bar")
@Compensable
@SagaEnd
public void bar() {
  ...
}
```

注意，目前@SagaEnd标注只支持一个异步调用的情况，由于在多个异步调用的过程中，多个异步调用的结束时间是不确定的， 我们无法@SagaEnd标注到最后一个结束的函数上来通知Omega事务调用已结束。

### 小结

在ServiceComb Pack 0.5.0 中为了提升性能以及更好地支持集群模式我们采用有限状态机来追踪分布式事务的执行情况，为了支持异步调用，我们尝试向业务层暴露一些传递事务调用信息的接口。后续我们还将在社区中探索Akka的集群方案， 欢迎大家使用，并加入到我们的[开发队伍](http://servicecomb.apache.org/cn/developers/contributing)中来。
