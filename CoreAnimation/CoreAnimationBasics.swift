//
//  CoreAnimationBasics.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/19.
//  Copyright © 2018年 雷广. All rights reserved.
//


// MARK: Core Animation Basics
/**
 
 Core Animation为动画应用的视图和其他视觉元素提供了一个通用系统。 核心动画不是视图的替代品。 相反，它是一种与视图集成的技术，可以为动画制作内容提供更好的性能和支持。 它通过将视图内容缓存到可由图形硬件直接操作的位图来实现此行为。 在某些情况下，这种缓存行为可能需要您重新思考如何呈现和管理您的应用内容，但大多数情况下您使用Core Animation时却并不知道它存在。 除了缓存视图内容外，Core Animation还定义了一种指定任意可视内容的方法，将该内容与视图集成，并与其他所有内容一起进行动画制作。
 Core Animation provides a general purpose system for animating views and other visual elements of your app. Core Animation is not a replacement for your app’s views. Instead, it is a technology that integrates with views to provide better performance and support for animating their content. It achieves this behavior by caching the contents of views into bitmaps that can be manipulated directly by the graphics hardware. In some cases, this caching behavior might require you to rethink how you present and manage your app’s content, but most of the time you use Core Animation without ever knowing it is there. In addition to caching view content, Core Animation also defines a way to specify arbitrary visual content, integrate that content with your views, and animate it along with everything else.
 
 
 与视图一样，图层管理几何，内容和视觉属性的信息。 与视图不同，图层不定义自己的外观。 一个层只管理位图相关的状态信息。 位图本身可以是由视图绘制生成或您指定的固定图像生成。 出于这个原因，您在应用程序中使用的图层被认为是模型对象，因为他们主要管理数据。 这个概念很重要，因为它会影响动画的行为。
 Like views, layers manage information about the geometry, content, and visual attributes of their surfaces. Unlike views, layers do not define their own appearance. A layer merely manages the state information surrounding a bitmap. The bitmap itself can be the result of a view drawing itself or a fixed image that you specify. For this reason, the main layers you use in your app are considered to be model objects because they primarily manage data. This notion is important to remember because it affects the behavior of animations.
 
 
 大多数图层不会在您的应用中执行任何实际的绘图。 相反，图层会捕获应用程序提供的内容并将其缓存在位图中，该位图有时称为后备存储。 当您随后更改图层的属性时，您所做的只是更改与图层对象关联的状态信息。 当更改触发动画时，Core Animation将图层的位图和状态信息传递给图形硬件，图形硬件完成使用新信息渲染位图的工作，如图所示。在硬件上操作位图做动画比在软件中更快。
 由于它操纵静态位图，因此基于图层(layer-based)的绘图与更传统的基于视图(view-based)的绘图技术有很大不同。 使用基于视图的绘图时，对视图本身的更改通常会导致调用视图的drawRect：方法以使用新参数重绘内容。 但以这种方式绘制是昂贵的，因为它使用主线程上的CPU来完成。 Core Animation尽可能地通过在硬件中操作缓存的位图，来实现相同或类似的效果，以避免这种开销。
 Most layers do not do any actual drawing in your app. Instead, a layer captures the content your app provides and caches it in a bitmap, which is sometimes referred to as the backing store. When you subsequently change a property of the layer, all you are doing is changing the state information associated with the layer object. When a change triggers an animation, Core Animation passes the layer’s bitmap and state information to the graphics hardware, which does the work of rendering the bitmap using the new information, as shown in Figur3 1-1. Manipulating the bitmap in hardware yields much faster animations than could be done in software.
 Because it manipulates a static bitmap, layer-based drawing differs significantly from more traditional view-based drawing techniques. With view-based drawing, changes to the view itself often result in a call to the view’s drawRect: method to redraw content using the new parameters. But drawing in this way is expensive because it is done using the CPU on the main thread. Core Animation avoids this expense by whenever possible by manipulating the cached bitmap in hardware to achieve the same or similar effects.
 
 
 在动画过程中，Core Animation会以硬件完成所有的逐帧绘制。
 During the course of an animation, Core Animation does all of the frame-by-frame drawing for you in hardware.
 
 
 基于点坐标(point-based)的最常见用途是指定图层的大小和位置，您可以使用图层的边界(bounds)和位置(position)属性进行确定。 bounds定义了图层本身的坐标系，并包含了图层在屏幕上的大小。 position属性定义了图层相对于其父坐标系的位置。 尽管图层具有frame属性，但该属性实际上是从bounds和position属性中的值导出的，并且使用频率较低。
 Among the most common uses for point-based coordinates is to specify the size and position of the layer, which you do using the layer’s bounds and position properties. The bounds defines the coordinate system of the layer itself and encompasses the layer’s size on the screen. The position property defines the location of the layer relative to its parent’s coordinate system. Although layers have a frame property, that property is actually derived from the values in the bounds and position properties and is used less frequently.
 
 
 使用Core Animation的应用程序有三组图层对象。每一组图层对象在使应用程序的内容出现在屏幕上时具有不同的作用：
 模型图层树(model layer tree)中的对象（或简称为“图层树(layer tree)”）是您的应用与最多的对象交互的对象。此树中的对象是存储任何动画的目标值的模型对象。无论何时更改图层的属性，都可以使用这些对象之一。
 呈现树(presentation tree)中的对象包含任何正在运行的动画的当前值。尽管layer tree对象包含动画的目标值，但presentation tree中的对象反映了屏幕上显示的当前值。你不应该修改这个树中的对象。相反，您可以使用这些对象来读取当前的动画值，也许可以从这些值开始创建一个新的动画。
 渲染树(render tree)中的对象执行实际的动画，并且对于Core Animation是私有的。
 An app using Core Animation has three sets of layer objects. Each set of layer objects has a different role in making the content of your app appear onscreen:
 Objects in the model layer tree (or simply “layer tree”) are the ones your app interacts with the most. The objects in this tree are the model objects that store the target values for any animations. Whenever you change the property of a layer, you use one of these objects.
 Objects in the presentation tree contain the in-flight values for any running animations. Whereas the layer tree objects contain the target values for an animation, the objects in the presentation tree reflect the current values as they appear onscreen. You should never modify the objects in this tree. Instead, you use these objects to read current animation values, perhaps to create a new animation starting at those values.
 Objects in the render tree perform the actual animations and are private to Core Animation.
 
 
 但是，应用程序可以根据需要 直接将图层对象layer objects（即未与视图view关联的图层）添加到图层分层结构中。 您可以在不需要使用视图view所有开销的内容上这样做，以优化应用程序的性能。
 However, an app can add additional layer objects—that is, layers not associated with a view—into the layer hierarchy as needed. You might do this in situations to optimize your app’s performance for content that does not require all the overhead of a view.
 
 
 图层layers不能代替您的应用视图views - 也就是说，您无法仅基于图层对象创建可视界面。 layers为您的views提供基础设施。 具体而言，layers可以更轻松，更高效地绘制视图内容并进行动画处理，并在此过程中保持较高的帧速率。 但是，有很多layers没有做到的事情。 layers不处理事件、绘制内容、参与响应者链或做许多其他事情。 因此，每个应用程序都必须有一个或多个views来处理这些交互。
 Layers are not a replacement for your app’s views—that is, you cannot create a visual interface based solely on layer objects. Layers provide infrastructure for your views. Specifically, layers make it easier and more efficient to draw and animate the contents of views and maintain high frame rates while doing so. However, there are many things that layers do not do. Layers do not handle events, draw content, participate in the responder chain, or do many other things. For this reason, every app must still have one or more views to handle those kinds of interactions.
 
 
 在iOS中，每个视图都由相应的图层对象支持，但在OS X中，您必须确定哪些视图应该具有图层。...
 In iOS, every view is backed by a corresponding layer object but in OS X you must decide which views should have layers.
 
 
 注意：对于图层支持的视图，建议尽可能操作视图而不是图层。在iOS中，视图只是图层对象的薄包装，所以对图层进行的任何操作通常都可以正常工作。但是在iOS和OS X中，操纵图层而不是视图可能不会产生所需的结果。本文尽可能指出这些缺陷，并试图提供帮助您解决问题的方法。
 Note: For layer-backed views, it is recommended that you manipulate the view, rather than its layer, whenever possible. In iOS, views are just a thin wrapper around layer objects, so any manipulations you make to the layer usually work just fine. But there are cases in both iOS and OS X where manipulating the layer instead of the view might not yield the desired results. Wherever possible, this document points out those pitfalls and tries to provide ways to help you work around them.
 
 
 除了与视图关联的图层外，还可以创建没有相应视图的图层对象。您可以将这些独立图层对象嵌入到应用中的任何其他图层对象中，包括与视图关联的图层对象。您通常使用独立的图层对象作为特定优化路径的一部分。例如，如果您想在多个位置使用相同的图像，则可以加载图像一次，并将其与多个独立图层对象相关联，然后将这些对象添加到图层树中。然后，每个图层都会引用源图像，而不是尝试在内存中创建该图像的自己的副本。
 In addition to the layers associated with your views, you can also create layer objects that do not have a corresponding view. You can embed these standalone layer objects inside of any other layer object in your app, including those that are associated with a view. You typically use standalone layer objects as part of a specific optimization path. For example, if you wanted to use the same image in multiple places, you could load the image once and associate it with multiple standalone layer objects and add those objects to the layer tree. Each layer then refers to the source image rather than trying to create its own copy of that image in memory.
 */

