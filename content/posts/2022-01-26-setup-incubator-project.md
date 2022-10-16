+++
author = "Hugo Authors"
title = "ASF孵化器项目初始化"
date = "2022-01-25"
description = "作为Mentor初始化ASF孵化器项目需要做的工作"
tags = [
    "Incubator",
    "ASF", 
]
categories = [
    "ASF",
]
+++

## ASF孵化器项目初始化工作

### 前期准备
* 需要完成[孵化提案](https://incubator.apache.org/guides/proposal.html)撰写的工作
* 完成捐献提案在[IPMC](https://lists.apache.org/list.html?general@incubator.apache.org)的讨论和投票的工作
* 操作人员有 PMC Chair 或者 Apache Member 有权限

### 创建项目步骤
 [ASF孵化导师指南](https://incubator.apache.org/guides/mentor.html#podling_bootstrap)中列举了项目初始化需要做到操作。

### 更新项目注册信息
1. svn checkout https://svn.apache.org/repos/asf/incubator/public/trunk/content/projects/
2. 参照最近创建的项目，创建一个新的孵化项目状态xml文件，更新其中信息。
3. 有关项目的其他扩展信息可以通过在[此目录](https://svn.apache.org/repos/asf/incubator/public/trunk/content/podlings/)下添加yaml文件的方式来添加。
4. 更新 [podlings.xml](https://svn.apache.org/repos/asf/incubator/public/trunk/content/podlings.xml) 文件。 具体操作详见 [ASF 导师指南](https://incubator.apache.org/guides/mentor.html )

更新完毕之后，incubator的网站会通过[这个job任务](https://ci-builds.apache.org/job/Incubator/job/Incubator-GIT-Site-part-2/)触发，请确保您权限已经设置好。
如果网站在构建过程中遇到格式错误，需要修正格式错误之后才能生成新的网站。

如果网站构建任务执行正确，您可以通过访问 [projects](https://incubator.apache.org/projects/) 找到相关的项目页面信息。

### 项目域名与基础实施
1. 在ASF Infra 建立相关podling项目建立的JIRA
2. 查看DNS以及LDAP的设置情况
3. [参考指导](https://incubator.apache.org/guides/mentor.html#request_email_lists)创建邮件列表

### 代码库迁移及网站建立
* 如果是公司雇佣贡献的代码需要完成 SGA 以及 CLA 的签署工作
* 代码库在迁移到ASF的repo之前需要完成[相关的清理工作](https://incubator.apache.org/guides/transitioning_asf.html)
* 通过 Infra JIRA 与Infra团队联系代码库迁移操作
* [建立孵化器项目网站注意事项](https://incubator.apache.org/guides/sites.html)
