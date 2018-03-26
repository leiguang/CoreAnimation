//
//  ImprovingAnimationPerformance.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/23.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [Improving Animation Performance]

/**
 
 提高动画性能
 核心动画是改善基于应用的动画帧速率的好方法，但它的使用并不能保证提高性能。 特别是在OS X中，您仍然必须选择使用Core Animation行为的最有效方法。 与所有与性能相关的问题一样，您应该使用Instruments工具来衡量和跟踪您的应用程序的性能，以确保性能得到改善并且不会退化。
 Improving Animation Performance
 Core Animation is a great way to improve the frame rates for app-based animations but its use is not a guarantee of improved performance. Especially in OS X, you must still make choices about the most effective way to use Core Animation behaviors. And as with all performance-related issues, you should use Instruments to measure and track the performance of your app over time so that you can ensure that performance is improving and not regressing.
 

 
 为您的OS X视图选择最佳重绘策略
 即使视图是layer-backed的，NSView类的默认重绘策略也会保留该类的原始绘图行为。 如果您在应用中使用图层支持的视图，则应检查重绘策略选项并选择能够为您的应用提供最佳性能的视图。 在大多数情况下，默认策略不是可能提供最佳性能的策略。 相反，NSViewLayerContentsRedrawOnSetNeedsDisplayDisplay策略更有可能减少应用程序的绘制量并提高性能。 其他政策也可能为特定类型的观点提供更好的表现。
 有关视图重绘策略的更多信息，请参阅OS X视图的图层重绘策略影响性能。
 Choose the Best Redraw Policy for Your OS X Views
 The default redraw policy for the NSView class preserves the original drawing behavior of that class, even if the view is layer-backed. If you are using layer-backed views in your app, you should examine the redraw policy choices and choose the one that offers the best performance for your app. In most cases, the default policy is not the one that is likely to offer the best performance. Instead, the NSViewLayerContentsRedrawOnSetNeedsDisplay policy is more likely to reduce the amount of drawing your app does and improve performance. Other policies might also offer better performance for specific types of views.
 For more information on view redraw policies, see The Layer Redraw Policy for OS X Views Affects Performance.
 

 
 有几种方法可以使您的图层实现更高效。 然而，与任何这样的优化一样，在尝试优化之前，您应该始终测量代码的当前性能。 这为您提供了一个可以用来确定优化是否正常工作的基线。
 General Tips and Tricks
 There are several ways to make your layer implementations more efficient. As with any such optimizations, though, you should always measure the current performance of your code before attempting to optimize. This gives you a baseline against that you can use to determine if the optimizations are working.
 
 1.尽可能使用不透明层
 将图层的不透明(opaque)属性设置为YES可让Core Animation知道它不需要维护图层的Alpha通道。 没有Alpha通道意味着合成器不需要将图层的内容与背景内容混合，这可以节省渲染过程中的时间。 但是，此属性主要与作为层支持视图一部分的图层或Core Animation创建底层图位图的情况有关。 如果将图像直接分配给图层的内容属性，那么不管opaque属性中的值如何，该图像的Alpha通道都会保留 (即如果图像是透明的，那么即使opaque=true, 图像还是会保留透明度)。
 Use Opaque Layers Whenever Possible
 Setting the opaque property of your layer to YES lets Core Animation know that it does not need to maintain an alpha channel for the layer. Not having an alpha channel means that the compositor does not need to blend the contents of your layer with its background content, which saves time during rendering. However, this property is relevant primarily for layers that are part of a layer-backed view or situations where Core Animation creates the underlying layer bitmap. If you assign an image directly to the layer’s contents property, the alpha channel of that image is preserved regardless of the value in the opaque property.

 
 2.为CAShapeLayer对象使用更简单的路径
 CAShapeLayer类通过在复合时间将您提供的路径渲染到位图图像中来创建其内容。优点是该层始终以尽可能最好的分辨率绘制路径，但这种优势需要花费额外的渲染时间。如果您提供的路径非常复杂，则对该路径进行栅格化(rasterizing)可能会过于昂贵。如果图层大小频繁变化（因此必须频繁重绘），则花费的时间可能会增加并成为性能瓶颈。
 减少形状图层绘制时间的一种方法是将复杂的形状分解成更简单的形状。在合成器中使用更简单的路径并将多个CAShapeLayer对象叠加层叠可以比绘制一条大型复杂路径快得多。这是因为绘图操作发生在CPU上，而合成发生在GPU上。然而，与这种性质的任何简化一样，潜在的性能收益取决于您的内容。因此，在优化之前测量代码的性能尤为重要，以便您有用于比较的基准。
 Use Simpler Paths for CAShapeLayer Objects
 The CAShapeLayer class creates its content by rendering the path you provide into a bitmap image at composite time. The advantage is that the layer always draws the path at the best possible resolution but that advantage comes at the cost of additional rendering time. If the path you provide is complex, rasterizing that path might get too expensive. And if the size of the layer changes frequently (and thus must be redrawn frequently), the amount of time spent drawing can add up and become a performance bottleneck.
 One way to minimize drawing time for shape layers is to break up complex shapes into simpler shapes. Using simpler paths and layering multiple CAShapeLayer objects on top of one another in the compositor can be much faster than drawing one large complex path. That is because the drawing operations happen on the CPU whereas compositing takes place on the GPU. As with any simplifications of this nature, though, the potential performance gains are dependent on your content. Therefore, it is especially important to measure the performance of your code before optimizing so that you have a baseline to use for comparisons.

 
 3.为相同图层明确设置图层内容
 如果您在多个图层对象中使用相同的图像，请自行加载图像并将其直接分配给这些图层对象的内容属性。 将内容分配给content属性可防止该层为内存分配内存。 相反，该图层使用您提供的图像作为其后备存储。 当几个图层使用相同的图像时，这意味着所有这些图层共享相同的内存，而不是为自己分配图像副本。
 Set the Layer Contents Explicitly for Identical Layers
 If you are using the same image in multiple layer objects, load the image yourself and assign it directly to the contents property of those layer objects. Assigning an image to the contents property prevents the layer from allocating memory for a backing store. Instead, the layer uses the image you provide as its backing store. When several layers use the same image, this means that all of those layers are sharing the same memory rather than allocating a copy of the image for themselves.
 

 4.始终将图层大小设置为整数值
 为获得最佳效果，请始终将图层对象的宽度和高度设置为整数值。 虽然使用浮点数指定图层边界的宽度和高度，但最终将使用图层边界来创建位图图像。 指定宽度和高度的整数值简化了Core Animation必须执行的工作，以创建和管理后备存储和其他图层信息。
 Always Set a Layer’s Size to Integral Values
 For best results, always set the width and height of your layer objects to integral values. Although you specify the width and height of your layer’s bounds using floating-point numbers, the layer bounds are ultimately used to create a bitmap image. Specifying integral values for the width and height simplifies the work that Core Animation must do to create and manage the backing store and other layer information.
 
 
 5.根据需要使用异步图层呈现
 您在delegate的drawLayer中执行的任何drawLayer:inContext:方法或您的视图的drawRect：方法通常在应用程序的主线程中同步发生。 但是，在某些情况下，同步绘制内容可能无法提供最佳性能。 如果您注意到您的动画效果不佳，则可以尝试在图层上启用drawsAsynchronously属性，将这些操作移至后台线程。 如果你这样做，确保你的绘图代码是线程安全的。 与往常一样，在将其放入生产代码之前，应始终测量绘图的性能。
 Use Asynchronous Layer Rendering As Needed
 Any drawing that you do in your delegate’s drawLayer:inContext: method or your view’s drawRect: method normally occurs synchronously on your app’s main thread. In some situations, though, drawing your content synchronously might not offer the best performance. If you notice that your animations are not performing well, you might try enabling the drawsAsynchronously property on your layer to move those operations to a background thread. If you do so, make sure your drawing code is thread safe. And as always, you should always measure the performance of drawing asynchronously before putting it into your production code.
 
 
 6.向图层添加阴影时指定阴影路径
 让Core Animation确定阴影的形状可能会很昂贵，并会影响应用程序的性能。 不是让Core Animation确定阴影的形状，而是使用CALayer的shadowPath属性明确指定阴影形状。 当您为此属性指定路径对象时，Core Animation将使用该形状绘制和缓存阴影效果。 对于形状永远不会改变或很少改变的图层，这可以通过减少Core Animation完成的渲染量来大大提高性能。
 Specify a Shadow Path When Adding a Shadow to Your Layer
 Letting Core Animation determine the shape of a shadow can be expensive and impact your app’s performance. Rather than letting Core Animation determine the shape of the shadow, specify the shadow shape explicitly using the shadowPath property of CALayer. When you specify a path object for this property, Core Animation uses that shape to draw and cache the shadow effect. For layers whose shape never changes or rarely changes, this greatly improves performance by reducing the amount of rendering done by Core Animation.
 
 */
