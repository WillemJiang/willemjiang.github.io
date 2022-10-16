+++
author = "Hugo Authors"
title = "Camel基本概念"
date = "2019-04-28"
description = "介绍了Camel的基本概念"
tags = [
    "Camel",
    "JAVA", 
]
categories = [
    "JAVA",
    "Camel",
]
+++

## Camel的核心概念

Apache Camel诞生已经有12年历史， 其核心模块一直都比较稳定，核心API基本没有什么变化。本文将从Camel最基本的概念入手，希望能帮助大家快速了解Camel。

### CamelContext

CamelContext是对Camel 运行时的一个抽象，其中包含了有个路由规则相关的信息配置，用户可以通过CamelContext获取与Camel运行时相关的信息，并对路由规则进行相关的管理。

![image-CamelContext](/images/camel/image-camel-camelcontext.png)

一般来说一个应用里面会有一个CamelContext 对象。一个典型的Camel 应用按照下面几个步骤执行。

1. 创建一个CamelContext对象。
2. 向CamelContext对象中添加自定义的Endpoints或者是Components。
3. 向CamelContext对象中添加路由规则(Routes)以及控制策略。
4. 同时加载classpath 中的数据格式(Data formats)，语言模块(Languages)以及类型转换模块(Type Converters)。
5. 调用CamelContext的start() 方法，这样可以启动Camel内部有关消息发送，接收，以及处理所使用的线程。
6. 当调用CamelContext的stop() 方法时，Camel 会将妥善关闭所有Endpoint和Camel内部的线程。



### Components

Component 是一个容易混淆的名词，可能使用EndpointFactory会更合适，因为Component是创建Endpoint实例的工厂类。例如如果一个Camel应用使用了几个JMS 队列，那么这个应用首先需要创建一个叫JmsComponent（实现了Component接口）的实例，你可以在此配置有关JMS连接的信息，然后应用会调用这个JMSComponent对象的createEndpoint()方法来创建一个JmsEndpoint对象（这个对象实现了Endpoint接口）。事实上，应用代码并没直接调用Component.createEndoint() 方法，而是CamelContext对象通过找到对应的Component对象（我马上会在后续的文章中介绍）,并调用createEndpoint() 方法来实现的。

```java
myCamelContext.getEndpoint(
    "pop3://john.smith@mailserv.example.com?password=myPassword");
```

在getEndpoint()中使用的参数就是URI。这个URI的前缀(: 之前的那部分内容）描述了一个组件的名字，CamelContext对象内部维护着一个组件名字与Component对象的映射表（Camel catalog中存储了名字与Component依赖之间的关系)。对于上面给定的URI例子来说，CamelContext对象会根据pop3前缀找到MailComponent类，然后CamelContext对会调用MailComponent的createEndpoint("pop3://john.smith@mailserv.example.com?password=myPassword") 方法。在createEndpoint()方法中， 将把URI分割成一组参数列表，这些参数将被用来设置生成的Endpoint对象的属性。

在上一小节中， 我提到的CamelContext对象维护了一个组件名到Component对象的映射表。但这个映射表是如何产生的呢？这里可以在通过代码调用CamelContext.addComponent(String componentName, Component component)来实现。 下面的例子就是展示了如何给一个MailComponent对象注册上三个不同的名字。
```java
Component mailComponent =
       new org.apache.camel.component.mail.MailComponent();
myCamelContext.addComponent("pop3", mailComponent);
myCamelContext.addComponent("imap", mailComponent);
myCamelContext.addComponent("smtp", mailComponent);
```    

第二个方法也是最常用的方法，就是通过CamelContext对象来实现一个懒初始化。这个方法依赖于一套Camel内部的定义Component发现机制， 开发者只要在实现Component接口的时候按照这一机制设置进行设置，就可以保证CamelContext能够在类加载路径中发现这一Component。这里我们假设你所写的Component类名为 com.example.myproject.FooComponent， 并且你想让Camel自动将这个component和"foo”这个名字相对应。为了做到这一点，你需要先写一个叫做"META-INF/services/org/apache/camel/component/foo" 属性文件， 注意这个文件没有".properties"作为后缀名，在这个属性文件中只有一个class的条目，而这个条目的只就是你所写的类的全名。如下所示

`META-INF/services/org/apache/camel/component/foo`

`class=com.example.myproject.FooComponent`

如果你还想让Camel将上面的类和”bar” 这个名字联系起来，那你需要在同样的目录下在创建一个相同内容叫bar的文件。一旦完成了这些配置， 你可以把 com.example.myproject.FooComponent class和这些配置文件一同打成一个jar 包，然后把这个jar包放你的CLASSPATH中。这样Camel就会通过分析这些属性文件的class 项目，通过使用Java 反射API创建这个指定的类的实例。

正如我在Endpoint中说描述的， Camel提供了对多种通信协议提供了开箱即用的支持。这种支持是建立在实现了Component接口的类以及让CamelContext对象自动建立映射关系的配置文件基础之上的。

在这一节的开始， 我使用的这个例子来调用CamelContext.getEndpoint()。
```java
myCamelContext.getEndpoint("
    pop3://john.smith@mailserv.example.com?password=myPassword");
```    

在最开始举这个例子的时候，我说这个getEndpoint()方法的参数是一个URI。我这么说是因为Camel的在线问答以及Camel的源代码就把这个参数声明为一个URI。在现实生活中，这个参数是按照URL来定义的。这是因为Camel会从参数中通过一个简单的算法查找第一：来分析出组件名。为了了解其中的奥妙，大家可以回想一下我在前面 URL，URI，URN和IRI是什么中谈到的 一个URI可以是URL或者URN。 现在让我们来看一下下面的getEndpoint()调用。
```java
myCamelContext.getEndpoint("pop3:...");
myCamelContext.getEndpoint("jms:...");
myCamelContext.getEndpoint("urn:foo:...");
myCamelContext.getEndpoint("urn:bar:...");
```    

Camel会先找出这些component的标识，例如 "pop3", "jms", "urn" 和 "urn"。如果"urn:foo" 和"urn:bar" 能够别用来识别component，或者是使用"foo" 和"bar" （这一可以跳过这个"urn:"前缀）。所以在实际的编程中，大家更喜欢使用URL来制定一个Endpoint（使用":..."来描述的字符串）而不是用一个URN（ 使用"urn::..."来描述的字符串）。正因为我们没有完全按照URN的规定的参数来调用getEndpoint() 方法， 所以这个方法的参数更像一个URL而不是一个URI。

### Endpoint

Endpoint这个词以前经常被用来描述进程间通信。例如，在客户端与服务器之间的通讯，客户端是一个Endpoint和服务器是另外一个Endpoint。根据不同的情况下，一个Endpoint可能指的地址，如一个TCP通信的（主机：端口）对，也可能是指与这个地址相对应的一个软件实体。例如，如果大家使用“ www.example.com:80 ”来描述一个Endpoint。这些Endpoint可能是指实际的端口上的主机名称（即地址） ，也可能是指与地址相关的的网页服务器（即在这个地址之上运行的软件地址） 。通常情况下，这种地址和在这个地址之上运行的软件之间的区别并不是一个重要问题。

一些中间件技术可以使一些软件实体的绑定在相同的物理地址上。例如， CORBA是一种面向对象的远程过程调用（ RPC ）的中间件标准。如果一个CORBA的服务器进程包含几个对象，客户端可以与这些在同一物理地址（主机：端口）之上的任意对象进行通讯 ，但当客户端想与特定对象进行通讯是， 需要指定这个对象的逻辑地址（在CORBA中称为IOR）。 IOR是由物理地址（主机：端口） ，以及一个唯一识别的对象在其服务器进程标识所组成。 （IOR还包含了与此本次讨论无关其他一些额外的信息。）当谈论CORBA的时候，有些人可能会使用“endpoint”来描述CORBA的服务器的物理地址，而其他人可能使用Endpoint来描述一个CORBA对象的逻辑地址，和其他人可能会使用这个词来描述下面这些：

- CORBA的服务器进程的物理地址（主机：端口）
- CORBA对象的逻辑地址（主机：端口加上编号）
- CORBA的服务器进程（相对重量级的软件实体）
- 一个基于CORBA对象（一个轻量级的软件实体）

正因为如此，你可以看到Endpoint这个词至少在两方面是模糊的。首先，它可能是指一个地址或联络软件实体在该地址。其次，粒度上可能是模糊的：一个重量级与轻量级的软件实体，或物理地址与逻辑地址。了解了Endpoint这个名词在不同场景下的不同描述可以帮助我们更好地理解为什么Camel中的Endpoint。

Camel中的Endpoint支持许多不同的通信技术。以下是Camel所支持Endpoint：

- 一个JMS队列。
- 一个Web服务。
- 一个文件。文件可能听起来不是一个典型的Endoint端点。但是你可以这么想，一些应用系统会把信息写到一个文件中，然后另一个应用程序可能读取该文件获得这一信息。
- 一个FTP服务器。
- 一个电子邮件地址。客户可以发送邮件到电子邮件地址，和一台服务器可以读取的这个从邮件服务器传入的邮件。
- 一个POJO （普通旧Java对象）。

### Message与Exchange

Message 接口提供了一个对单个消息的抽象，这些消息可以是一个请求，回复或者是一个异常。

对于每个Camel是支持的通讯技术来说，都需要提供一个Message接口的实现。例如JmsMessage就提供了一个Message接口的JMS实现. 在message接口中提供一个get/set方法来访问message id, body 以及message中每个单独header。

而exchange接口则表示了对message exchange的抽象， 也就是说一个请求消息以及与之对应的应答消息或者异常消息肯定会与一个Exchange相关联。对于Camel来说，请求和应答以及异常消息都分别被称为in, out 。

![Exchange&Message](/images/camel/image-camel-ExchangeAndMessage.png)

对于每个Camel所支持的通信技术来说来说，都需要一个实现了Exchang接口的的类。 例如JmsExchange 类就提供了一个Exchange接口的JMS实现。对于Exchange接口来说它提供的公共的API很有限。 但是对于实现Exchange的具体的类来说，它可以添加很多与其支持的通讯协议相关操作。

应用层的程序应该很少直接访问Exchange（或者是实现Exchange的类）。由于Camel很多类都大量使用了有关（Exchange）的泛型定义，所有你会在很多的类和方法中看到Exchange接口的身影，最常见的就是Processor这个接口，通过实现Processor我们可以很方便地对传入的Exchange进行相关的处理。

```java
public interface Processor {

    /**
     * Processes the message exchange
     *
     * @param exchange the message exchange
     * @throws Exception if an internal processing error has occurred.
     */
    void process(Exchange exchange) throws Exception;
}
```
