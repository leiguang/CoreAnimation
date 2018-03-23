//
//  BuildingALayerHierarchy.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/20.
//  Copyright © 2018年 雷广. All rights reserved.
//


// [Building a Layer Hierarchy]

/**
 
 添加和插入子图层时，必须在子图层出现在屏幕上之前设置子图层的大小和位置。 您可以在将子图层添加到图层层次结构后修改其大小和位置，但应该习惯于在创建图层时设置这些值。
 您可以使用bounds属性设置子图层的大小，并使用position属性在其超级图层中设置其位置。 边界矩形的原点几乎总是（0，0），并且大小与点中指定的图层的大小无关。 位置属性中的值相对于图层的锚点进行解释，该锚点默认位于图层的中心。 如果不为这些属性赋值，Core Animation会将图层的初始宽度和高度设置为0，并将位置设置为（0，0）。
 重要提示：始终对图层的宽度和高度使用整数。
 
 When adding and inserting sublayers, you must set the size and position of the sublayer before it appears onscreen. You can modify the size and position of a sublayer after adding it to your layer hierarchy but should get in the habit of setting those values when you create the layer.
 You set the size of a sublayer using the bounds property and set its position within its superlayer using the position property. The origin of the bounds rectangle is almost always (0, 0) and the size is whatever size you want for the layer specified in points. The value in the position property is interpreted relative to the layer’s anchor point, which is located in the center of the layer by default. If you do not assign values to these properties, Core Animation sets the initial width and height of the layer to 0 and sets the position to (0, 0).
 Important: Always use integral numbers for the width and height of your layer.
 
 */

/**
 
 图层层次结构如何影响动画
 某些父图层属性可能会影响应用于其子图层的任何动画的行为。其中一个属性是速度属性，它是动画速度的倍数。该属性的值默认设置为1.0，但将其更改为2.0会使动画以原始速度的两倍运行，从而完成动画只需要一半的时间。该属性不仅影响其设置的图层，还影响该图层的子图层。这种变化也是可乘的。如果子图层和其父图层的速度均为2.0，则子图层上的动画将以其原始速度的四倍运行。
 大多数其他层更改以可预测的方式影响任何包含的子层。例如，将旋转变换应用到图层会旋转该图层及其所有子图层。同样，更改图层的不透明度会更改其子图层的不透明度。对图层大小的更改遵循(Adjusting the Layout of Your Layer Hierarchies)中所述的布局规则。
 
 How Layer Hierarchies Affect Animations
 Some superlayer properties can affect the behavior of any animations applied to its child layers. One such property is the speed property, which is a multiplier for the speed of the animation. The value of this property is set to 1.0 by default but changing it to 2.0 causes animations to run at twice their original speed and thereby finish in half the time. This property affects not only the layer for which it is set but also for that layer’s sublayers. Such changes are multiplicative too. If both a sublayer and its superlayer have a speed of 2.0, animations on the sublayer run at four times their original speed.
 Most other layer changes affect any contained sublayers in predictable ways. For example, applying a rotation transform to a layer rotates that layer and all of its sublayers. Similarly, changing a layer’s opacity changes the opacity of its sublayers. Changes to the size of a layer follow the rules for layout that are described in Adjusting the Layout of Your Layer Hierarchies.
 
 */

/**
 
 在 OS X 上可以使用 约束(Constraints) 来管理图层层次结构(包括平级的)。 （iOS上不能用，省略）
 Using Constraints to Manage Your Layer Hierarchies in OS X
 
 
 
 与视图不同，父图层不会自动剪裁位于边框矩形外的子图层的内容。 相反，父图层允许其子图层默认全部显示。 但是，可以通过将图层的masksToBounds属性设置为YES来重新启用裁剪。
 Unlike views, a superlayer does not automatically clip the contents of sublayers that lie outside its bounds rectangle. Instead, the superlayer allows its sublayers to be displayed in their entirety by default. However, you can reenable clipping by setting the masksToBounds property of the layer to YES.
 
 
 
 转换图层之间的坐标值
 有时，您可能需要将一个图层中的坐标值转换为不同图层中同一屏幕位置处的坐标值。 CALayer类提供了一组可以用于此目的的简单转换例程：
 convertPoint：fromLayer：
 convertPoint：toLayer：
 convertRect：fromLayer：
 convertRect：toLayer：
 除了转换点和矩形值之外，还可以使用convertTime：fromLayer：和convertTime：toLayer：方法在图层之间转换时间值。每个图层都定义了自己的本地时间空间，并使用该时间空间将动画的开始和结束与系统的其余部分同步。这些时间空间默认同步;但是，如果更改一组图层的动画速度，那么这些图层的时间空间会相应更改。您可以使用时间转换方法来解决任何此类因素，并确保两个图层的时间同步。
 Converting Coordinate Values Between Layers
 Occasionally, you might need to convert a coordinate value in one layer to a coordinate value at the same screen location in a different layer. The CALayer class provides a set of simple conversion routines that you can use for this purpose:
 convertPoint:fromLayer:
 convertPoint:toLayer:
 convertRect:fromLayer:
 convertRect:toLayer:
 In addition to converting point and rectangle values, you can also convert time values between layers using the convertTime:fromLayer: and convertTime:toLayer: methods. Each layer defines its own local time space and uses that time space to synchronize the beginning and ending of animations with the rest of the system. These time spaces are synchronized by default; however, if you change the animation speed for one set of layers, the time space for those layers changes accordingly. You can use the time conversion methods to to account for any such factors and ensure that the timing of both layers is synchronized.
 
 */

