+++
author = "Hugo Authors"
title = "如何在JDK中添加安全证书"
date = "2022-10-10"
description = "在企业内部的服务器会设置很多的私有的安全证书，为了访问企业内部的服务需要添加相关的安全证书"
tags = [
    "JAVA",
    "Tips", 
]
categories = [
    "JAVA",
]
+++

这两天需要使用公司内部的服务进行相关的部署，在设置完maven的镜像服务之后， 收到一个JDK抛出的异常。

``` txt
 sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.
 SunCertPathBuilderException: unable to find valid certification path to requested target

```

因为访问的服务器的链接是https， 应该JVM在SSL链接时候没有找到服务器的证书所造成的， 要解决这个问题需要将服务器的证书添加到JVM的配置中。

在JVM中缺省的证书存放路径如下 $JAVA_HOME/jre/lib/security/cacerts, 我们需要把服务器的证书添加到这个文件中。

在网上检索了一下， 发现要手工获取服务器端证书还是比较困难，需要在借助浏览器提供的证书导出功能， 而且这样做还特别容易出错。后来发现在Github上面有一个[现成的证书安装Java程序](https://github.com/escline/InstallCert)可以直接使用。 于是记录下了具体的使用步骤：

1. 下载InstallCert.java

``` txt
wget https://raw.githubusercontent.com/escline/InstallCert/master/InstallCert.java
```

1. 编译代码

``` txt
javac InstallCert.java
```

1. 执行程序

``` txt
java InstallCert [--proxy=proxyHost:proxyPort] <host>[:port] 
```

1. 将当前路径生成的 jssecacerts 文件拷贝到 $JAVA_HOME/jre/lib/security/cacerts

注意： 在win10 下，这个cacerts是被系统保护起来的， 需要手工替换文件。

### 参考资料

* [stackoverflow上的相关讨论](https://stackoverflow.com/questions/4062307/pkix-path-building-failed-unable-to-find-valid-certification-path-to-requested)
* [InstallCert代码](https://github.com/escline/InstallCert)
  