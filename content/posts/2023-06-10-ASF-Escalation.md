+++
author = "Hugo Authors"
title = "如何在ASF进行问题升级（翻译）"
date = "2023-06-10"
description = ""
tags = [
    "OpenSource",
    "Foundation" 
]
categories = [
    "ASF",
]
+++
Apache软件基金会（ASF）作为一个全球化的虚拟组织， 一直强调采用项目内部的共识自治的方式进行交流沟通。在项目发展的过程总会遇到这样或者那样的项目管理委员会无法解决的问题。 如何处理这些问题，如何在有效地在 ASF 内部提升这些问题的级别就成了大家比较关注的内容的。 笔者在2022年，2023年 ASF 担任董事会理事期间接触过一些升级处理的案例， 为了帮助Apache项目更好的理解相关升级操作需要注意的内容， 特地翻译了ASF提供的[问题升级指南](https://apache.org/board/escalation)。

## 如何在ASF升级问题

Apache项目习惯采用共识的方式来做决策，或者使用投票来更正式地记录对特定行动的批准（或否定）。但是当项目完全陷入僵局，或者你觉得在采取行动之前，重要问题没有被认真对待或全面讨论时，我们应该做些什么？

如果任何Apache项目参与者感到有严重问题得不到解决，那么这里有一个指南，介绍了在ASF组织中有效升级您的关注的问题正确方法。

## 升级

当项目无法做出重大决策，或者当个人贡献者或PMC的一部分认为项目没有适当地讨论关键问题时，您可能希望将关注点升级，以查看是否有其他调解帮助可用。

在Apache的其余志愿者中获取帮助的最佳方法是遵循以下步骤。

## 清楚地概述问题并附上参考资料

当社区存在分歧时，澄清根本问题非常重要。有些长时间而激烈的讨论线程，结果主要关注于无关紧要的问题或建议如何表达而实际上并不是关于手头的问题。每当一个问题值得升级时，也值得用您的时间清楚地重新陈述手头的问题。

* **清晰地**定义一个具体的问题或问题，用外部人员也能理解的术语。将对话集中在每个线程的一个问题上。不要假定读者知道项目历史或已经阅读了有关主题的每个电子邮件 - 包括表明有价值讨论的链接。

* 提供指向说明您情况的**Apache政策或最佳实践的URL参考**。一个项目中的口头规则可能不适用于另一个项目。如果没有具体的参考，很难判断某些东西是否真的是Apache的问题，或者仅仅是一个项目内部的分歧（在这种情况下升级无益）。如果您无法清楚地说明该问题为什么很重要，或者违反了Apache政策，那么升级不会有太大的帮助。

* 起草电子邮件，保存并**等待一夜**。编辑您的工作，仔细检查您是否以冷静，中立和事实的方式提出您的情况。您正在尝试帮助社区做出正确的决定；专注于项目的正确行动，并不着重于个人的倾向（尽管有时您可能需要提出有关不良行为的问题）。讨论可能影响社区健康的行为是好的；提出有关特定个人的问题很少有帮助。

当问题是重复出现或您知道正确答案时，这些步骤可能会让人感到沮丧！但在一个完全由志愿者领导的组织中，用指针清晰地重新框定问题很重要，以便整个社区有机会理解您的具体观点。我们都是志愿者，在社区中并不是每个人都有时间跟进所有对话。需要让社区的其他成员易于理解您的情况。

## 首先与项目或社区合作

在将问题升级到相关项目、孵化器项目或社区之外之前，请问自己：我是否真正穷尽了在这个社区内工作的所有途径？在将问题升级到项目之外之前，项目内部或关于项目的任何问题都应该先与项目自己的PMC全体在dev@（或private@）列表上讨论。

再次检查您是否清晰，冷静地表达了问题。确保区分您对问题的讨论和您对解决问题的建议 -- 在一个繁忙的项目中，这并不总是对所有人都清晰。

健康的Apache项目应该尽可能以包容的方式进行自我治理。无论是内部项目决策的问题，还是有关违反Apache政策或最佳实践的问题，项目的PMC是开始和继续讨论的合适场所。

当一个严重的问题涉及到外部公司（可能滥用项目的品牌或流程）时，可能需要外部帮助。但是任何对外部公司影响或滥用的升级都应该首先发送给PMC，以使他们有机会进行审核。

## 将问题升级到正确的邮件列表、官员或董事会

* 顶级项目PMC成员对行为、项目治理、项目不遵循Apache政策等问题应发送至Apache board@ 私有邮件列表，并抄送相关项目的private@列表。

* 孵化器孵化项目的行为、项目治理、孵化项目不遵循Apache政策等问题应发送至Apache孵化器general@或private@邮件列表，并抄送相关的private@podling列表。

* Apache基础设施的问题应首先升级到[基础设施管理员](https://whimsy.apache.org/roster/orgchart/infra-admin)。如果这样还不够，那么只有升级到[基础设施 VP](https://whimsy.apache.org/roster/orgchart/vp-infra)。

* 任何**品牌或商标问题**应发送至品牌管理委员会的私有列表，并抄送相关项目的private@列表。

* 任何法律问题或**来自律师的要求**应发送给[法律事务委员会](https://whimsy.apache.org/roster/orgchart/vp-legal)（如有需要，可在私有邮件列表上！）

* 正式的隐私、GDPR 或删除请求应发送给数据隐私 VP。

* 运营问题（筹款、会议等）应发送给总裁和EVP；[组织图](https://whimsy.apache.org/roster/orgchart/)对于查看直接向[总裁](https://whimsy.apache.org/roster/orgchart/president)或董事会报告的人员很有帮助。

有关更多指针，请参见[提供给Apache项目的服务列表](https://www.apache.org/board/services)。请注意，私有的 members@ 邮件列表永远不是升级项目问题的正确位置。

## 升级的特殊情况

根据严重性和紧急性，以下几种情况可能是以上指南的例外：

* 任何未得到解决的可能**披露安全问题**：如果其他途径不起作用，则立即升级以[确保安全团队知道问题](https://www.apache.org/security/)。

* 任何对**个人安全的可信威胁**应立即升级到当地执法部门或紧急人员。如果您在ApacheCon或其他ASF主办的活动中，请尽快通过询问任何事件工作人员联系会议组织者或规划委员会；否则，请联系ASF的总裁<president@apache.org>。

* 任何来自**法律顾问的法律传票**或要求应立即升级到[法律事务委员会](https://whimsy.apache.org/roster/orgchart/vp-legal)，以便ASF的律师进行审核。

如果您不愿意直接与相关人员合作，而出现了严重的行为**准则违规**现象，可以直接升级到[总裁或报告志愿者](https://www.apache.org/foundation/policies/conduct.html)。

## 只是寻求有关ASF的一些一般建议？

询问未涵盖在上述内容中的[一般公共问题的最佳位置是ComDev](https://community.apache.org/lists.html)。