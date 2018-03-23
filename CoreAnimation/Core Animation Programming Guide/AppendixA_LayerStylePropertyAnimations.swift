//
//  AppendixA_LayerStylePropertyAnimations.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/23.
//  Copyright © 2018年 雷广. All rights reserved.
//

// [Appendix A: Layer Style Property Animations]

/**
 
 以下CALayer属性指定图层的几何图形：
 The following CALayer properties specify a layer’s geometry:
 bounds
 position
 frame (computed from the bounds and position and is not animatable)
 anchorPoint
 cornerRadius
 transform
 zPosition
 
 
 以下CALayer属性影响图层背景的显示：
 The following CALayer properties affect the display of a layer’s background:
 backgroundColor
 backgroundFilters (not supported in iOS)
 
 
 具有圆角半径的图层不会自动剪裁其内容; 然而，将图层的masksToBounds属性设置为YES才会导致图层剪切到其角半径。
 Layers with a corner radius do not automatically clip their contents; however, setting the layer’s masksToBounds property to YES does cause the layer to clip to its corner radius.
 
 
 以下CALayer属性影响图层内容的显示：
 The following CALayer properties affect the display of a layer’s content:
 contents
 contentsGravity
 masksToBounds

 
 以下CALayer属性影响图层子图层的显示：
 The following CALayer properties affect the display of a layer’s sublayers:
 sublayers
 masksToBounds
 sublayerTransform

 
 请注意，超出图层边界的内容和子图层将呈现在边框下方。
 Notice that content and sublayers that are outside the layer’s bounds are rendered underneath the border.
 
 
 以下CALayer属性影响图层边框的显示：
 The following CALayer properties affect the display of a layer’s borders:
 borderColor
 borderWidth
 
 
 以下CALayer属性指定了图层内容过滤器：
 (平台注意：在iOS中，图层忽略您分配给它们的任何过滤器。)
 The following CALayer property specifies a layers content filters:
 filters
 compositingFilter
 (Platform Note: In iOS, layers ignore any filters you assign to them.)

 
 以下CALayer属性影响图层阴影的显示：
 The following CALayer properties affect the display of a layer’s shadow:
 shadowColor
 shadowOffset
 shadowOpacity
 shadowRadius
 shadowPath
 
 
 以下CALayer属性指定图层的不透明度：
 The following CALayer property specifies the opacity of a layer:
 opacity

 
 
 Mask Properties (可以理解为盖住什么就显示什么，mask可以有alpha)
 您可以使用遮罩来遮盖图层内容的全部或部分。 蒙版本身就是一个图层对象，其alpha通道用于确定什么是遮蔽的以及显示的是什么。 遮罩层内容的不透明部分允许底层内容显示，而透明部分部分或完全遮蔽底层内容。 图A-9显示了一个样本图层与一个遮罩层和两个不同的背景。 在左侧版本中，该图层的不透明度设置为1.0。 在右侧的版本中，图层的不透明度设置为0.5，从而增加了通过图层的蒙版部分传输的背景内容的数量。
 You can use a mask to obscure all or part of a layer’s contents. The mask is itself a layer object whose alpha channel is used to determine what is blocked and what is transmitted. Opaque portions of the mask layer’s contents allow the underlying layer content to show through while transparent portions partially or fully obscure the underlying content. Figure A-9 shows a sample layer composited with a mask layer and two different backgrounds. In the left version, the layer’s opacity is set to 1.0. In the right version, the layer’s opacity is set to 0.5, which increases the amount of background content that is transmitted through the masked portion of the layer.
 
 以下CALayer属性指定图层的遮罩：
 The following CALayer property specifies the mask for a layer:
 mask
 
 */
