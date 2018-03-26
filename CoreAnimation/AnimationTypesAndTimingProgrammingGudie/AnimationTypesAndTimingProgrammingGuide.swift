//
//  AnimationTypesAndTimingProgrammingGuide.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/26.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: [Animation Types and Timing Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Animation_Types_Timing/Introduction/Introduction.html#//apple_ref/doc/uid/TP40006668-SW1)

/**
 
 本文档描述了涉及Core Animation使用的时间和动画类的基本概念。 Core Animation是一个Objective-C框架，它将高性能合成引擎与简单易用的动画编程接口相结合。
 
 本文档由以下部分组成：
 1. Animation Class Roadmap：动画类和时序协议的概述。
 2. Timing, Timespaces, and CAAnimation：详细描述了Core Animation和抽象CAAnimation类的时序模型。
 3. Property-Based Animations：基于属性的动画描述了基于属性的动画：CABasicAnimation和CAKeyframeAnimation。
 4. Transition Animation：描述了转换动画类CATransition。
 
 
 
 核心动画提供了一组可以在您的应用程序中使用的富有表现力的动画类：
 
 1. CAAnimation是所有动画子类的抽象类。 CAAnimation采用CAMediaTiming协议，为动画提供简单的持续时间，速度和重复次数。 CAAnimation也采用CAAction协议。这个协议提供了一个标准化的手段来响应layer所触发的动作来启动动画。
 CAAnimation类还将动画的计时定义为CAMediaTimingFunction的一个实例。定时功能将动画的步骤描述为简单的贝塞尔曲线。linear timing function指定动画的速度在其持续时间内是均匀的，而ease-in timing function会使动画在接近完成时加快。
 2. CAPropertyAnimation是CAAnimation的抽象子类，它通过指定"key path"来为图层的属性提供动画支持。
 3. CABasicAnimation是CAPropertyAnimation的一个子类，为图层属性提供了简单的插值。
 4. CAKeyframeAnimation（CAPropertyAnimation的一个子类）为关键帧动画提供支持。您可以指定要动画的图层属性的key path，表示动画每个阶段值的数组值，以及关键帧时间和定时函数的数组。动画运行时，每个值都是使用指定的插值轮流设置的。
 5. CATransition提供影响整个图层内容的过渡效果。在动画制作时，它会淡化，推动或显示图层内容。在OS X上，通过提供自己的自定义核心图像过滤器，可以扩展已存在的转换效果。
 6. CAAnimationGroup允许将一组动画对象分组在一起并且同时运行。
 图1显示了动画类层次结构，并总结了通过继承可用的属性。(https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Animation_Types_Timing/Art/animations_info_2x.png)
 
 
 // 关于 Media Timing Protocol中属性的解释 如 speed、duration、repeating、beginTime、timeOffset、Fill Mode。 其中对于CALayer遵守了CAMediaTiming协议，应用在layer上时，“beginTime”和“timeOffset”属性的具体用法我还不理解。
 
 // 介绍了 CAMediaTimingFunction、Basic Animations、Keyframe Animations、Transition Animation的使用。其示例在[Core Animation Programming Guide]中都有使用过
 
 */

