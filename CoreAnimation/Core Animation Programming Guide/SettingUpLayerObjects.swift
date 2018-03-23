//
//  SettingUpLayerObjects.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/19.
//  Copyright © 2018年 雷广. All rights reserved.
//


// MARK: - Setting up layer objects

/**
 
 改变视图的图层类非常简单， 清单2-1显示了一个例子。 你所要做的就是重写layerClass方法，并返回你想要使用的类对象。 在显示之前，视图调用layerClass方法并使用返回的类为其自身创建一个新的图层对象。 一旦创建，视图的图层对象就不能改变。
 示例：override class var layerClass : AnyClass { return CATiledLayer.self }
 Changing the layer class of a view is very straightforward; an example is shown in Listing 2-1. All you have to do is override the layerClass method and return the class object you want to use instead. Prior to display, the view calls the layerClass method and uses the returned class to create a new layer object for itself. Once created, a view’s layer object cannot be changed.
 
 
 
 CALayer子类及其用途：
 CALayer subclasses and their uses:
 1. CAEmitterLayer: 用于实现基于Core Animation的粒子发射器系统。 发射器层对象控制粒子的生成及其原点。(Used to implement a Core Animation–based particle emitter system. The emitter layer object controls the generation of the particles and their origin.)
 2. CAGradientLayer: 用于绘制填充图层形状的颜色渐变（在任何圆角的范围内）。(Used to draw a color gradient that fills the shape of the layer (within the bounds of any rounded corners).)
 3. CAMetalLayer: 用于使用Metal设置和销售 渲染图层内容的可绘制纹理。(Used to set up and vend drawable textures for rendering layer content using Metal.)
 4. CAEAGLLayer/CAOpenGLLayer: 用于设置使用OpenGL ES（iOS）或OpenGL（OS X）呈现图层内容的后备存储和上下文。(Used to set up the backing store and context for rendering layer content using OpenGL ES (iOS) or OpenGL (OS X).)
 5. CAReplicatorLayer: 当您想自动复制一个或多个子图层时使用。 复制器为您制作副本，并使用您指定的属性来更改副本的外观或属性。(Used when you want to make copies of one or more sublayers automatically. The replicator makes the copies for you and uses the properties you specify to alter the appearance or attributes of the copies.)
 6. CAScrollLayer: 用于管理由多个子图层组成的大型可滚动区域。(Used to manage a large scrollable area composed of multiple sublayers.)
 7. CAShapeLayer: 用于绘制一个三次贝塞尔样条曲线。 形状图层有利于绘制基于路径的形状，因为它们总是会形成一条清晰的路径，与绘制到图层后台存储的路径相反，在缩放时看起来不太好。 但是，清晰的结果确实涉及在主线程上渲染形状并缓存结果。(Used to draw a cubic Bezier spline. Shape layers are advantageous for drawing path-based shapes because they always result in a crisp path, as opposed to a path you draw into a layer’s backing store, which would not look as good when scaled. However, the crisp results do involve rendering the shape on the main thread and caching the results.)
 8. CATextLayer: 用于呈现纯文本或属性字符串。(Used to render a plain or attributed string of text.)
 9. CATiledLayer: 用于管理大图像，该图像可以分成更小的图块并单独渲染，支持放大和缩小内容。(Used to manage a large image that can be divided into smaller tiles and rendered individually with support for zooming in and out of the content.)
 10. CATransformLayer: 用于渲染真正的3D图层层次结构，而不是其他图层类实现的扁平层次结构。(Used to render a true 3D layer hierarchy, rather than the flattened layer hierarchy implemented by other layer classes.)
 11. QCCompositionLayer: 用于渲染Quartz Composer组合。（仅限OS X）(Used to render a Quartz Composer composition. (OS X only))
 


 由于图层只是用于管理位图图像的容器，因此可以将图像直接分配给图层的内容属性。 为图层分配图像非常简单，您可以指定想要在屏幕上显示的确切图像。 该图层使用您直接提供的图像对象，并且不会尝试创建该图像的自己的副本。 如果您的应用在多个位置使用相同的图像，此行为可以节省内存。
 Because a layer is just a container for managing a bitmap image, you can assign an image directly to the layer’s contents property. Assigning an image to the layer is easy and lets you specify the exact image you want to display onscreen. The layer uses the image object you provide directly and does not attempt to create its own copy of that image. This behavior can save memory in cases where your app uses the same image in multiple places.
 
 
 
 使用delegate来提供layer的内容
 如果layer的内容动态更改，则可以使用delegate对象在需要时提供和更新该内容。在显示时间，图层会调用delegate的方法来提供所需的内容：
 如果delegate实现displayLayer：方法，则该实现负责创建位图并将其分配给图层的内容属性。
 如果您的delegate实现了drawLayer：inContext：方法，Core Animation将创建一个位图，创建一个图形上下文以绘制该位图，然后调用delegate方法来填充位图。你所有的delegate方法所要做的就是绘制到提供的图形上下文中。
 delegate对象必须实现displayLayer：或drawLayer：inContext：方法。如果delegate同时实现了displayLayer：和drawLayer：inContext：两个方法，则该层仅调用displayLayer：方法。
 当layer被标记为要重新加载其内容时，将调用这两个delegate方法，通常由setNeedsDisplay方法触发。 典型的更新技术是设置图层的内容属性。
 Using a Delegate to Provide the Layer’s Content
 If the content of your layer changes dynamically, you can use a delegate object to provide and update that content when needed. At display time, the layer calls the methods of your delegate to provide the needed content:
 If your delegate implements the displayLayer: method, that implementation is responsible for creating a bitmap and assigning it to the layer’s contents property.
 If your delegate implements the drawLayer:inContext: method, Core Animation creates a bitmap, creates a graphics context to draw into that bitmap, and then calls your delegate method to fill the bitmap. All your delegate method has to do is draw into the provided graphics context.
 The delegate object must implement either the displayLayer: or drawLayer:inContext: method. If the delegate implements both the displayLayer: and drawLayer:inContext: method, the layer calls only the displayLayer: method.
 
 
 
 
 调整您提供的内容
 将图像分配给图层的内容属性时，图层的contentsGravity属性决定如何处理该图像以适应当前边界。默认情况下，如果图像大于或小于当前边界，图层对象将缩放图像以适合可用空间。如果图层边界的纵横比与图像的纵横比不同，则会导致图像失真。您可以使用contentsGravity属性来确保以最佳方式呈现您的内容。
 您可以分配给contentGravity属性的值分为两类：
 1. 基于位置的gravity常量允许您将图像固定到图层边界矩形的特定边或角，而不缩放图像。
 2. 基于比例的gravity常量可让您使用多种选项中的一种来拉伸图像，其中一些选项可保留高宽比，其中一些选项不会。
 Tweaking the Content You Provide
 When you assign an image to the contents property of a layer, the layer’s contentsGravity property determines how that image is manipulated to fit the current bounds. By default, if an image is bigger or smaller than the current bounds, the layer object scales the image to fit within the available space. If the aspect ratio of the layer’s bounds is different than the aspect ratio of the image, this can cause the image to be distorted. You can use the contentsGravity property to ensure that your content is presented in the best way possible.
 The values you can assign to the contentsGravity property are divided into two categories:
 1. The position-based gravity constants allow you to pin your image to a particular edge or corner of the layer’s bounds rectangle without scaling the image.
 2. The scaling-based gravity constants allow you to stretch the image using one of several options, some of which preserve the aspect ratio and some of which do not.
 
 
 
 处理高分辨率图像
 图层对底层设备的屏幕分辨率没有任何固有的知识。一个图层只是存储一个指向你的位图的指针，并以给定可用像素的最佳方式显示它。如果将图像分配给图层的内容属性，则必须通过将图层的contentsScale属性设置为适当的值来告诉Core Animation关于图像的分辨率。该属性的默认值为1.0，这适用于打算在标准分辨率屏幕上显示的图像。如果您的图像用于Retina显示，请将此属性的值设置为2.0（应该根据retina屏的scale来设置，可能2.0、3.0）。
 只有在您直接为您的图层分配位图时，才需要更改contentsScale属性的值。 UIKit和AppKit中的有图层支持的视图根据屏幕分辨率和视图管理的内容自动将图层的比例因子设置为适当的值。例如，如果您将NSImage对象分配给OS X中图层的内容属性，则AppKit会查看是否存在图像的标准和高分辨率变体。如果有，AppKit使用当前分辨率的正确变体并设置contentScale属性的值以匹配。
 Working with High-Resolution Images
 Layers do not have any inherent knowledge of the resolution of the underlying device’s screen. A layer simply stores a pointer to your bitmap and displays it in the best way possible given the available pixels. If you assign an image to a layer’s contents property, you must tell Core Animation about the image’s resolution by setting the layer’s contentsScale property to an appropriate value. The default value of the property is 1.0, which is appropriate for images intended to be displayed on standard resolution screens. If your image is intended for a Retina display, set the value of this property to 2.0.
 Changing the value of the contentsScale property is only necessary if you are assigning a bitmap to your layer directly. A layer-backed view in UIKit and AppKit automatically sets the scale factor of its layer to an appropriate value based on the screen resolution and the content managed by the view. For example, if you assign an NSImage object to the contents property of a layer in OS X, AppKit looks to see if there are both standard- and high-resolution variants of the image. If there are, AppKit uses the correct variant for the current resolution and sets the value of the contentsScale property to match.
 
 
 
 如果您将图层的背景色设置为不透明颜色，请考虑将图层的不透明属性(opaque)设置为YES。 这样做可以在合成屏幕上的图层时提高性能，并且不需要图层的后台存储来管理Alpha通道。 不过，如果图层也具有非零的圆角半径，则不得将图层标记为不透明。
 If you set your layer’s background color to an opaque color, consider setting the layer’s opaque property to YES. Doing so can improve performance when compositing the layer onscreen and eliminates the need for the layer’s backing store to manage an alpha channel. You must not mark a layer as opaque if it also has a nonzero corner radius, though.
 

 
 向图层添加阴影时，阴影是图层内容的一部分，但实际上是延伸到图层的边界矩形之外。因此，如果为该图层启用了masksToBounds属性，则阴影效果会在边缘被剪切。如果图层包含任何透明内容，则可能会导致一种奇怪的效果，即直接位于图层下方的阴影部分仍然可见，但延伸到图层之外的部分不会。如果你想要一个阴影，但也想使用边界遮罩，你可以使用两层而不是一层。将蒙版应用于包含内容的图层，然后将该图层嵌入到启用了阴影效果的大小完全相同的第二个图层中。
 When adding shadows to a layer, the shadow is part of the layer’s content but actually extends outside the layer’s bounds rectangle. As a result, if you enable the masksToBounds property for the layer, the shadow effect is clipped around the edges. If your layer contains any transparent content, this can cause an odd effect where the portion of the shadow directly under your layer is still visible but the part extending beyond your layer is not. If you want a shadow but also want to use bounds masking, you use two layers instead of one. Apply the mask to the layer containing your content and then embed that layer inside a second layer of the exact same size that has the shadow effect enabled.
 */
