//
//  Introduction.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/19.
//  Copyright © 2018年 雷广. All rights reserved.
//


// MARK: [Core Animation Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514-CH1-SW1)

// [Introduction]


/**
 
层级关系：
    UIKit / AppKit
    Core Animation
  Metal   Core Graphics
    Graphics Hardware
 
 
 
 Core Animation将大部分实际的绘图工作交给板载图形硬件来加速渲染。 这种自动图形加速可实现高帧率和流畅的动画效果，而不会增加CPU的负担并减慢应用程序的运行速度。
 All you have to do is configure a few animation parameters (such as the start and end points) and tell Core Animation to start. Core Animation does the rest, handing most of the actual drawing work off to the onboard graphics hardware to accelerate the rendering. This automatic graphics acceleration results in high frame rates and smooth animations without burdening the CPU and slowing down your app.
 
 
 如果您正在编写iOS应用程序，则无论您是否知道，都已经有使用到Core Animation了。 如果您正在编写OS X应用程序，则可以非常轻松地利用Core Animation。 Core Animation位于AppKit和UIKit之下，并紧密集成到Cocoa和Cocoa Touch的视图工作流中。 当然，Core Animation也具有接口，可以扩展应用视图所显示的功能，并可以更好地控制应用的动画。
 If you are writing iOS apps, you are using Core Animation whether you know it or not. And if you are writing OS X apps, you can take advantage of Core Animation with extremely little effort. Core Animation sits beneath AppKit and UIKit and is integrated tightly into the view workflows of Cocoa and Cocoa Touch. Of course, Core Animation also has interfaces that extend the capabilities exposed by your app’s views and give you more fine-grained control over your app’s animations.
 
 
 核心动画本身不是一个绘图系统。 它是用于在硬件中合成和操纵应用内容的基础设施。 这个基础架构的核心是图层对象，您可以使用它来管理和操作您的内容。 图层将您的内容捕获到位图中，该位图可由图形硬件轻松操纵。 在大多数应用程序中，图层用作管理视图内容的方式，但您也可以根据需要创建独立图层。
 Core Animation is not a drawing system itself. It is an infrastructure for compositing and manipulating your app’s content in hardware. At the heart of this infrastructure are layer objects, which you use to manage and manipulate your content. A layer captures your content into a bitmap that can be manipulated easily by the graphics hardware. In most apps, layers are used as a way to manage the content of views but you can also create standalone layers depending on your needs.
 
 
 大多数使用Core Animation创建的动画都涉及修改图层的属性。 与视图类似，图层对象具有边界矩形，屏幕上的位置，不透明度，变换以及可以修改的许多其他可视化属性。 对于大多数这些属性，更改属性的值会导致创建隐式动画，从而将图层从旧值动画到新值。 如果您希望更好地控制最终的动画行为，您还可以显式地动画这些属性。
 Most of the animations you create using Core Animation involve the modification of the layer’s properties. Like views, layer objects have a bounds rectangle, a position onscreen, an opacity, a transform, and many other visually-oriented properties that can be modified. For most of these properties, changing the property’s value results in the creation of an implicit animation whereby the layer animates from the old value to the new value. You can also explicitly animate these properties in cases where you want more control over the resulting animation behavior.
 
 
 隐式层动画是使用action对象实现的，动作对象是实现预定义接口的通用对象。 Core Animation使用action对象来实现通常与图层关联的默认动画集。 您可以创建自己的action对象来实现自定义动画或使用它们来实现其他类型的行为。 然后将您的操作对象分配给图层的某个属性。 当该属性更改时，Core Animation将检索您的操作对象并告诉它执行其操作。
 Implicit layer animations are achieved using action objects, which are generic objects that implement a predefined interface. Core Animation uses action objects to implement the default set of animations normally associated with layers. You can create your own action objects to implement custom animations or use them to implement other types of behaviors too. You then assign your action object to one of the layer’s properties. When that property changes, Core Animation retrieves your action object and tells it to perform its action.
 */
