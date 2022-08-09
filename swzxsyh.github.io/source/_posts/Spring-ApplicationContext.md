---
title: Spring-ApplicationContext
date: 2022-07-07 01:03:52
tags:
---

# Spring ApplicationContext

> ApplicationContext 是一个BeanFactory，但额外实现一些功能

- ApplicationContext管理Bean能力是由什么支持的

  使用DefaultListableBeanFactory实现ApplicationContext管理能力

- DefaultListableBeanFactory具有什么能力

  各种Post处理

  DefaultListableBeanFactory实现各种BeanDefinitionRegistry



<!-- more -->

## BeanFactory

- **DefaultListableBeanFactory**（各种Post处理）
  - ApplicationContext
  - **组合模式**

## Environment

- Apollo/Nacos -- EnvironmentPostProcessor#postProcessorEnvironment(Early-BootStrap)
  - 初始化配置

## MessageSource

- 国际化

## EventPublish

- 领域事件
  - 领域、主链路
  - 注意重启（在主链路落库，通过重试处理一致性，避免节点重启异常）

## Resource

- resources目录
  - 工具



