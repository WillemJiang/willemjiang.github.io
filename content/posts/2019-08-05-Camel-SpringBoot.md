+++
author = "Hugo Authors"
title = "Apache Camel Spring Boot使用说明"
date = "2019-08-05"
description = "Apache Camel借助Spring Boot提供了一套微服务组合服务的开发框架。"
tags = [
    "Camel",
    "SpringBoot",
    "JAVA", 
]
categories = [
    "Camel",
    "JAVA",
]
+++


### Apache Camel Spring Boot

#### Camel应用初始化

Apache Camel 采用的是组件化的设计思想，通过[Camel Component](https://camel.apache.org/component.html)对接第三方的应用，Camel核心模块会扫描classpath 加载这些Camel Component。 Camel应用在启动的过程中，需要将应用涉及到的[路由（Route）](https://camel.apache.org/routes.html)，[节点 （Endpoint）](https://camel.apache.org/endpoint.html)，[类型转换器（TypeConverter）](https://camel.apache.org/type-converter.html)以及发送接收模板（[ProducerTemplate](https://camel.apache.org/producertemplate.html)， [ConsumerTemplate](https://camel.apache.org/polling-consumer.html)）加载到 [Camel上下文环境（CamelContext）](https://camel.apache.org/camelcontext.html)进行组装。

在Camel早期时代，Camel直接提供了一套XML的DSL来描述路由规则，以及配置Camel应用相关模块，这样我们只需要在应用程序入口创建Spring 应用，加载相关的XML配置文件就可以了。 Spring创建ApplicationContext时候会加载对应Camel路由规则，并完成有关CamelContext创建和组装工作。

随着Spring Boot的普及，大家逐步走上了通过标注和在starter依赖中加入很多自动配置模块的方式来配置相关组件的道路， Camel Spring Boot Starter 为Camel提供了一个自动配置组件。 通过自动配置不但将有Spring管理的Camel Routes组装到Camel Context中， 而且可以通过Autowire的方式向业务代码注入其他与Camel 应用运行相关的组件。

#### 如何管理Spring Boot与Apache Camel依赖

一般来说可以通过maven的依赖管理如下方式管理Spring Boot 以及Apache Camel的依赖。

```xml
<properties>
   <!-- 通过spring-boot 以及 camel的提供的 BOM管理依赖 -->
   <camel.version>2.24.1</camel.version>
   <spring-boot.version>2.1.6.RELEASE</spring-boot.version>
</properties>

<dependencyManagement>
   <dependencies>
      <dependency>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-dependencies</artifactId>
         <version>${spring-boot.version}</version>
         <type>pom</type>
         <scope>import</scope>
      </dependency>
      <dependency>
         <groupId>org.apache.camel</groupId>
         <artifactId>camel-spring-boot-dependencies</artifactId>
         <version>${camel.version}</version>
         <type>pom</type>
         <scope>import</scope>
      </dependency>
   </dependencies>
</dependencyManagement>
```

以下是典型的Apache Camel 应用的依赖包

```xml
<dependencies>
   <!-- Camel Spring Boot Starter 包依赖，   
  包含了Spring Boot以及Apache Camel Core的依赖 -->
   <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-spring-boot-starter</artifactId>
   </dependency>

   <!-- Camel应用涉到其他的Camel组件    
  大家可以从https://github.com/apache/camel/blob/master/components/readme.adoc
  获取有关Camel组件的信息-->
   <dependency>
       <groupId>org.apache.camel</groupId>
       <artifactId>camel-rabbitmq-starter</artifactId>
   </dependency>
</dependencies>
```

#### 配置Camel Context 以及加载路由规则

添加完相关的starter依赖之后，我们还需要定义相关的Camel路由规则。添加@Component，可以让Camel自动加载相关路由规则。 如果有多个路由规则，你可以通过定义多个RouterBuilder实例，或者在单个RouterBuilder的configure方法中定义多个 from的方式来实现。

```java
package com.example;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class MyRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        from("timer:foo")
          .to("log:bar");
    }
}
```

当然你可以通过@Configuration来对路由实例进行精确控制。

```java
@Configuration
public class MyRouterConfiguration {

  @Bean
  RoutesBuilder myRouter() {
    return new RouteBuilder() {

      @Override
      public void configure() throws Exception {
        from("jms:invoices")
          .to("file:/invoices");
      }
    };
  }
}
```

这样在Spring Boot 应用启动的时候就自动加载这些定义好的路由规则。 如果想阻塞Spring Boot的主线程的话，你可以通过加入 **spring-boot-starter-web**依赖，或者在Spring Boot应的配置文件(**application.properties, application.yaml**) 中添加 **camel.springboot.main-run-controller=true**。

#### 组装设置CamelContext

Apache Camel 的自动配置模块会提供一个配置好的CamelContext，这个CamelContext实例用**camelContext**在Spring应用上下文中进行注册，可以通过@Autowired注入到你的应用中。 这样可以基于CamelContext创建相关的服务或者组件。

```java
@Configuration
public class MyAppConfig {

  @Autowired
  CamelContext camelContext;

  @Bean
  MyService myService() {
    return new DefaultMyService(camelContext);
  }

}
```

如果预先对CamelContext做一些设置的话， 可以通过预先创建[CamelContextConfiguration](https://github.com/apache/camel/blob/master/components/camel-spring-boot/src/main/java/org/apache/camel/spring/boot/CamelContextConfiguration.java)的方式来进行配置。这样在Spring应用启动之前，Spring Boot会自动加载这些预先设置好的[CamelContextConfiguration](https://github.com/apache/camel/blob/master/components/camel-spring-boot/src/main/java/org/apache/camel/spring/boot/CamelContextConfiguration.java)实例，回调相关的配置方法。

```java
@Configuration
public class MyAppConfig {

  ...

  @Bean
  CamelContextConfiguration contextConfiguration() {
    return new CamelContextConfiguration() {
      @Override
      void beforeApplicationStart(CamelContext context) {
        // 在此编写Spring应用初始化之前，需要设置CamelContext的代码。
      }
    };
  }
```

#### 设置ConsumerTemplate和ProducerTemplate

Camel支持自动创建以及配置[ProducerTemplate](https://camel.apache.org/producertemplate.html)以及 [ConsumerTemplate](https://camel.apache.org/polling-consumer.html)。 如下展示的内容，你可以使用平常Spring管理的对象一样通过Autowired方式注入这些对象。

```java
@Component
public class InvoiceProcessor {

  @Autowired
  private ProducerTemplate producerTemplate;

  @Autowired
  private ConsumerTemplate consumerTemplate;
  public void processNextInvoice() {
    Invoice invoice = consumerTemplate.receiveBody("jms:invoices", Invoice.class);
    ...
    producerTemplate.sendBody("netty-http:http://invoicing.com/received/" + invoice.id());
  }
}
```

缺省情况下 ConsumerTemplate 和 ProducerTemplate缺省设置的endpoint的缓存大小是**1000**。你可以通过修改Spring属性文件的方式设置缓存大小。

```sh
camel.springboot.consumerTemplateCacheSize = 100
camel.springboot.producerTemplateCacheSize = 200
```

#### 编写单元测试

可以通过[CamelSpringBootRunner](https://github.com/apache/camel/blob/master/components/camel-test-spring/src/main/java/org/apache/camel/test/spring/CamelSpringBootRunner.java)来支持Spring Boot应用的单元测试， 下面是一个具体的例子大家可以参考一下。

```java
@ActiveProfiles("test")
@RunWith(CamelSpringBootRunner.class)
@SpringBootTest
@DirtiesContext(classMode = ClassMode.AFTER_EACH_TEST_METHOD)
@DisableJmx(true)
public class MyRouteTest extends CamelTestSupport {

  @Autowired
  private CamelContext camelContext;

  @Override
  protected CamelContext createCamelContext() throws Exception {
    return camelContext;
  }

  @EndpointInject(uri = "direct:myEndpoint")
  private ProducerTemplate endpoint;

  @Override
  public void setUp() throws Exception {
    super.setUp();
    RouteDefinition definition = context().getRouteDefinitions().get(0);
    definition.adviceWith(context(), new RouteBuilder() {
      @Override
      public void configure() throws Exception {
        onException(Exception.class).maximumRedeliveries(0);
      }
    });
  }

  @Override
  public String isMockEndpointsAndSkip() {
    return "myEndpoint:put*";
  }

  @Test
  public void shouldSucceed() throws Exception {
    assertNotNull(camelContext);
    assertNotNull(endpoint);

    String expectedValue = "expectedValue";
    MockEndpoint mock = getMockEndpoint("mock:myEndpoint:put");
    mock.expectedMessageCount(1);
    mock.allMessages().body().isEqualTo(expectedValue);
    mock.allMessages().header(MY_HEADER).isEqualTo("testHeader");
    endpoint.sendBodyAndHeader("test", MY_HEADER, "testHeader");

    mock.assertIsSatisfied();
  }
}
```

#### 参考资料

[Camel官方文档](https://camel.apache.org/spring-boot.html)

[Camel Spring Boot 示例代码](https://github.com/apache/camel/tree/master/examples/camel-example-spring-boot)
