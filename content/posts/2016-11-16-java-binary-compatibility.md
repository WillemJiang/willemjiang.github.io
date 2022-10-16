+++
author = "Hugo Authors"
title = "Java二进制兼容问题"
date = "2016-11-12"
description = "代码库在演进的过程中，或多或少都存在方法，成员变量，以及包的修改。这些修改或多或少会对类库的调用代码产生一些影响。"
tags = [
    "Java",
]
categories = [
    "Java",
]
+++

####二进制兼容问题的由来

代码库在演进的过程中，或多或少都存在方法，成员变量，以及包的修改。这些修改或多或少会对类库的调用代码产生一些影响。由于Java代码是在运行时进行链接的，编译时的Class Path 和运行时的Class Path是可以完全不一样的。

如果链接的代码与编译时的代码不是一个版本，且两个版本存在二进制兼容问题，那客户端代码在运行的过程中就会抛出 java.lang.**IncompatibleClassChangeError**，或者如下的错误*NoSuchFieldError*, *NoSuchMethodError*, *IllegalAccessError*, *InstantiationError*, *VerifyError*, 
*NoClassDefFoundError* and *AbstractMethodError*.

这里提到的二进制兼容问题是指客户代码在运行时链接过程中，出现了与编译时不一致的情况。由于[Java的编译链接是分离的](https://willemjiang.github.io/blog/2006/java-link-post/)，这样编译时的Class Path 与运行时链接的Class Path是可以完全不一样的，如果客户代码使用的库版本差异很大的话，这样二进制兼容的问题是很容易出现的。

当出现了二进制兼容问题是，由于我们很少有机会修改库代码，解决的办法往往是重新编译调用相关类库的客户代码或者降级相应的类库的版本。

在笔者开发Apache Camel过程中遇到Spring 3.x ， Spring 4.x Test库的二进制兼容问题。由于Spring 4.x删除了一个Static方法的定义，我们没有办法在同时支持Spring 3.x 和 Spring 4.x, 只能选择缺省支持Spring3.x， 对于高版本单独发布Spring 4.x的编译版本。

二进制兼容的问题会给用户的使用带来很大的不方便，作为类库的开发人员，我们需要在API的演进过程中尽量避免出现二进制兼容的问题。 



#### 那些修改是会导致二进制兼容问题



如上描述，二进制兼容问题是出现在相关类库对外暴露的API端，如果一些API的修改与原有版本产生了冲突，就会对基于老版本编译的客户端产生很大的影响。

这里容易出现二进制兼容问题的修改如下：

*  删除了API包名。

*  将API包中一个public类型改成了非public类型。

*  修改了API中的public类型发生了改变，例如Class变成了Interface，或者Interface变成了Class。 

*  对需要客户端实现的接口进行了修改。

*  修改了API类型的参数顺序。

*  把一个非abstract类修改成为了abstract类。

*  降低方法的可见性例如把protected修改为了private，或者把public修改为protected。

*  修改了成员的属性，例如把非final 成员变成了final， 或者是非static的成员变成了static。

    ​

一般来说，上面的修改都是针对会被调用客户端对外可见的API来说的， 如果是内部包可见或者是私有方法或者成员的修改是不引起二进制兼容问题的。

如果大家想详细了解API演进和二进制兼容的的问题可以参考[1]。



#### 参考资料

\[1\]["Evolving Java-based APIs 2: Achieving API Binary Compatibility"](http://wiki.eclipse.org/Evolving_Java-based_APIs_2)