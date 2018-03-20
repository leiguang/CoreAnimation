//
//  AnimatingLayerContentViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/20.
//  Copyright © 2018年 雷广. All rights reserved.
//


// [Animating Layer Content]

import UIKit

class AnimatingLayerContentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fadeAnim_implicity()
        fadeAnim_explicitly()
        pathAnim()
        groupAnim()
        viewAnim()
    }

    
    // MARK: - 隐式动画 (Animating a change implicitly)
    func fadeAnim_implicity() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPoint(x: 150, y: 150)
        layer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer)
        
        // 延迟1s执行，否则视图还没呈现 看不见效果
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            layer.opacity = 0   // 系统默认动画duration: 0.25s
        }
    }
    
    // MARK: - 显示动画 (Animating a change explicitly)
    func fadeAnim_explicitly() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPoint(x: 250, y: 150)
        layer.backgroundColor = UIColor.green.cgColor
        view.layer.addSublayer(layer)
        
        // Animating a change explicitly
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0
        fadeAnim.duration = 1.0
        layer.add(fadeAnim, forKey: "opacity")    // 这个key也可以填nil，在移除指定动画方法removeAnimation(forKey: )的时候需要用到这个key。 (The special key kCATransition is automatically used for transition animations. You may specify nil for this parameter.)
        
        // 显示动画不会修改model layer的值。如果不加这句，动画结束后会还原到opacity = 1.0的初始状态 (Unlike an implicit animation, which updates the layer object’s data value, an explicit animation does not modify the data in the layer tree. Explicit animations only produce the animations. )
        // Change the actual data value in the layer to the final value.
        layer.opacity = 0
    }
    
    // MARK: - 弹跳小球 (Using a Keyframe Animation to Change Layer Properties)
    func pathAnim() {
        // 紫色圆球 (两种创建方式，效果一样)
        // 1. 使用CAShapeLayer + UIBezierPath 创建圆球
        let path = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 25, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.position = CGPoint(x: 100, y: 400)
        layer.path = path.cgPath
        layer.fillColor = UIColor.purple.cgColor
        view.layer.addSublayer(layer)
        
        
        // 2. 使用CALayer + Core Graphics 创建圆球
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50), false, UIScreen.main.scale)
//        let ctx = UIGraphicsGetCurrentContext()!
//        ctx.addArc(center: CGPoint(x: 25, y: 25), radius: 25, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//        ctx.setFillColor(UIColor.purple.cgColor)
//        ctx.fillPath()
//        let image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
//        let layer = CALayer()
//        layer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
//        layer.position = CGPoint(x: 100, y: 400)
//        layer.contents = image.cgImage
//        view.layer.addSublayer(layer)
        
        
        // 移动路径 (Creating a bounce keyframe animation)
        // create a UIBezierPath that implements two arcs (a bounce)
        let movePath = UIBezierPath()
        movePath.move(to: CGPoint(x: 100, y: 400))
        movePath.addQuadCurve(to: CGPoint(x: 200, y: 400), controlPoint: CGPoint(x: 150, y: 100))
        movePath.addQuadCurve(to: CGPoint(x: 300, y: 400), controlPoint: CGPoint(x: 250, y: 100))
        // Create the animation object, specifying the position property as the key path.
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = movePath.cgPath
        anim.duration = 5.0
        anim.autoreverses = true
        layer.add(anim, forKey: "position")
    }
    
    // MARK: - 使用动画组，改变边框颜色和大小 (像边框颜色宽度、contents内容、矩阵变换、位置等属性都是可动画的。参见：Specifying Keyframe Values)
    func groupAnim() {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPoint(x: 100, y: 500)
        view.layer.addSublayer(layer)
        
        // Animation 1
        let widthAnim = CAKeyframeAnimation(keyPath: "borderWidth")
        widthAnim.values = [1.0, 10.0, 5.0, 30.0, 0.5, 15.0, 2.0, 50, 0.0]
        widthAnim.calculationMode = kCAAnimationPaced
        // Animation 2
        let colorAnim = CAKeyframeAnimation(keyPath: "borderColor")
        colorAnim.values = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.green.cgColor]
        colorAnim.calculationMode = kCAAnimationPaced
        // Animation group
        let group = CAAnimationGroup()
        group.animations = [widthAnim, colorAnim]
        group.duration = 5.0
        // Add the animation group to the layer.
        layer.add(group, forKey: "BorderChanges")
    }
    
    // MARK: - Animating a layer attached to an iOS view (参见：Rules for Modifying Layers in iOS)
    func viewAnim() {
        let v = UIView(frame: CGRect(x: 200, y: 450, width: 100, height: 100))
        v.backgroundColor = .cyan
        view.addSubview(v)
        
        // 其中 backgroundColor动画执行1.0s； position动画3.0s
        UIView.animate(withDuration: 1.0) {
            // Change the backgroundColor implicitly.
            v.layer.backgroundColor = UIColor.red.cgColor   // The UIView class disables layer animations by default but reenables them inside animation blocks.

            // Change the position explicitly.
            let anim = CABasicAnimation(keyPath: "position")
            anim.fromValue = v.layer.position
            anim.toValue = CGPoint(x: v.layer.position.x + 50, y: v.layer.position.y + 50)
            anim.duration = 3.0
            v.layer.add(anim, forKey: "AnimateFrame")
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}



// MARK: - Animating Layer Content

/**
 
 指定关键帧动画的时间
 关键帧动画的时间安排和步调比基本动画更复杂，您可以使用几个属性来控制它：
 
 calculateMode属性定义用于计算动画定时的算法。此属性的值会影响其他与时间相关的属性的使用方式。
 线性和立方体动画 - 也就是说，calculateMode属性设置为kCAAnimationLinear或kCAAnimationCubic的动画 - 使用提供的时间信息生成动画。这些模式为您提供对动画时间的最大控制。
 Paced动画 - 也就是说，calculateMode属性设置为kCAAnimationPaced或kCAAnimationCubicPaced的动画不依赖于keyTimes或timingFunctions属性提供的外部时间值。相反，定时值是隐式计算的，以便为动画提供恒定的速度。
 离散动画 - 也就是说，calculateMode属性设置为kCAAnimationDiscrete的动画 - 导致动画属性从一个关键帧值跳到下一个关键帧值，而不进行任何插值。此计算模式使用keyTimes属性中的值，但忽略了timingFunctions属性
 keyTimes属性指定应用每个关键帧值的时间标记。仅当计算模式设置为kCAAnimationLinear，kCAAnimationDiscrete或kCAAnimationCubic时才使用此属性。它不适用于节奏动画。
 timingFunctions属性指定用于每个关键帧段的时间曲线。 （该属性替换继承的timingFunction属性。）
 如果您想自己处理动画计时，请使用kCAAnimationLinear或kCAAnimationCubic模式以及keyTimes和timingFunctions属性。 keyTimes定义应用每个关键帧值的时间点。所有中间值的时间由定时功能控制，这允许您将缓入或缓出曲线应用到每个段。如果您没有指定任何定时功能，则定时是线性的。
 
 Specifying the Timing of a Keyframe Animation
 The timing and pacing of keyframe animations is more complex than those of basic animations and there are several properties you can use to control it:
 
 The calculationMode property defines the algorithm to use in calculating the animation timing. The value of this property affects how the other timing-related properties are used.
 Linear and cubic animations—that is, animations where the calculationMode property is set to kCAAnimationLinear or kCAAnimationCubic—use the provided timing information to generate the animation. These modes give you the maximum control over the animation timing.
 Paced animations—that is, animations where the calculationMode property is set to kCAAnimationPaced or kCAAnimationCubicPaced—do not rely on the external timing values provided by the keyTimes or timingFunctions properties. Instead, timing values are calculated implicitly to provide the animation with a constant velocity.
 Discrete animations—that is, animations where the calculationMode property is set to kCAAnimationDiscrete—cause the animated property to jump from one keyframe value to the next without any interpolation. This calculation mode uses the values in the keyTimes property but ignores the timingFunctions property
 The keyTimes property specifies time markers at which to apply each keyframe value. This property is used only if the calculation mode is set to kCAAnimationLinear, kCAAnimationDiscrete, or kCAAnimationCubic. It is not used for paced animations.
 The timingFunctions property specifies the timing curves to use for each keyframe segment. (This property replaces the inherited timingFunction property.)
 If you want to handle the animation timing yourself, use the kCAAnimationLinear or kCAAnimationCubic mode and the keyTimes and timingFunctions properties. The keyTimes defines the points in time at which to apply each keyframe value. The timing for all intermediate values is controlled by the timing functions, which allow you to apply ease-in or ease-out curves to each segment. If you do not specify any timing functions, the timing is linear.
 
 */

/**
 
 正在运行时停止显式动画
 
 动画通常会一直运行直到它们完成，但是如果需要，可以使用以下技术之一提前阻止动画：
 
 要从图层中移除单个动画对象，请调用图层的removeAnimationForKey：方法以移除动画对象。此方法使用传递给addAnimation：forKey：方法的键来标识动画。此时您指定的key不能为nil。
 要从图层中移除所有动画对象，请调用图层的removeAllAnimations方法。此方法立即删除所有正在进行的动画，并使用其当前状态信息重绘该图层。
 注意：您无法直接从图层中删除隐式动画。
 当您从图层中移除动画时，Core Animation将通过使用其当前值重绘图层来响应。由于当前值通常是动画的结束值，因此可能会导致图层的外观突然跳跃。如果您希望图层的外观保持原来位于动画最后一帧的位置，可以使用呈现树presentation tree中的对象获取这些当前值并将它们设置为图层树中的对象。
 
 有关暂时暂停动画的信息，请参阅清单5-4。
 
 Stopping an Explicit Animation While It Is Running
 
 Animations normally run until they are complete, but you can stop them early if needed using one of the following techniques:
 
 To remove a single animation object from the layer, call the layer’s removeAnimationForKey: method to remove your animation object. This method uses the key that was passed to the addAnimation:forKey: method to identify the animation. The key you specify must not be nil.
 To remove all animation objects from the layer, call the layer’s removeAllAnimations method. This method removes all ongoing animations immediately and redraws the layer using its current state information.
 Note: You cannot remove implicit animations from a layer directly.
 When you remove an animation from a layer, Core Animation responds by redrawing the layer using its current values. Because the current values are usually the end values of the animation, this can cause the appearance of the layer to jump suddenly. If you want the layer’s appearance to remain where it was on the last frame of the animation, you can use the objects in the presentation tree to retrieve those final values and set them on the objects in the layer tree.
 
 For information about pausing an animation temporarily, see Listing 5-4.
 

 */

/**
 
 如果一个layer属于一个带有layer的view，推荐的创建动画的方法是使用UIKit或AppKit提供的基于视图的动画接口。有许多方法可以直接使用Core Animation界面对图层进行动画制作，但是如何创建这些动画取决于目标平台。
 If a layer belongs to a layer-backed view, the recommended way to create animations is to use the view-based animation interfaces provided by UIKit or AppKit. There are ways to animate the layer directly using Core Animation interfaces but how you create those animations depends on the target platform.
 
 
 由于iOS视图总是具有layer，因此UIView类本身直接从层对象派生大部分数据。因此，您对该图层所做的更改也会自动反映在视图对象中。此行为意味着您可以使用Core Animation或UIView界面来进行更改。
 如果您想使用Core Animation类来启动动画，则必须从基于视图的动画块中发出所有Core Animation调用。 UIView类默认禁用图层动画，但在动画块内重新启用它们。因此，您在动画块外进行的任何更改都不会生成动画。清单3-5显示了一个如何显式地隐式更改图层的不透明度及其位置的示例。在这个例子中，myNewPosition变量被事先计算并被块捕获。两个动画同时开始，但不透明动画以默认计时运行，而位置动画以其动画对象中指定的时间运行。(示例在本页viewAnim()方法中)
 
 Because iOS views always have an underlying layer, the UIView class itself derives most of its data from the layer object directly. As a result, changes you make to the layer are automatically reflected by the view object as well. This behavior means that you can use either the Core Animation or UIView interfaces to make your changes.
 If you want to use Core Animation classes to initiate animations, you must issue all of your Core Animation calls from inside a view-based animation block. The UIView class disables layer animations by default but reenables them inside animation blocks. So any changes you make outside of an animation block are not animated. Listing 3-5 shows an example of how to change a layer’s opacity implicitly and its position explicitly. In this example, the myNewPosition variable is calculated beforehand and captured by the block. Both animations start at the same time but the opacity animation runs with the default timing while the position animation runs with the timing specified in its animation object.
 
 */

/**
 
 请记住更新视图约束作为动画的一部分
 如果您使用基于约束的布局规则来管理视图的位置，则必须删除可能会干扰动画的任何约束，作为配置该动画的一部分。 约束会影响您对视图的位置或大小所做的任何更改。 它们也会影响视图与其子视图之间的关系。 如果您正在对这些项目的更改进行动画制作，则可以删除约束，进行更改，然后应用所需的任何新约束。
 Remember to Update View Constraints as Part of Your Animation
 If you are using constraint-based layout rules to manage the position of your views, you must remove any constraints that might interfere with an animation as part of configuring that animation. Constraints affect any changes you make to the position or size of a view. They also affect the relationships between the view and its child views. If you are animating changes to any of those items, you can remove the constraints, make the change, and then apply whatever new constraints are needed.
 
 For more information on constraints and how you use them to manage the layout of your views, see Auto Layout Guide.
 
 */
