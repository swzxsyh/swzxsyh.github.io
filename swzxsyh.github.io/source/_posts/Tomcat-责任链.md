---
title: Tomcat-责任链
date: 2022-07-07 01:41:26
tags:
---

# Tomcat责任链

![](./Tomcat-责任链/Tomcat责任链.jpg)

## Container

- Pipeline
  - Valve 1
  - Valve 2
  - Valve 3

## 对应关键节点

- Connector -&gt; StandardService
- StandardEngind
- EngineValve
- ErrorReportValve
  - getNext()
    - HostValve
- ContextValve
- WrapperValve
- FilterChain.doFilter
- servlet.service
