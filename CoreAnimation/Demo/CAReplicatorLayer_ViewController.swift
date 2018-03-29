//
//  CAReplicatorLayer_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/28.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CAReplicatorLayer]

/**
 
 CAReplicatorLayer是"根据子图层来创建指定数量的子图层副本" 的图层，每个副本可能会应用几何，时间和颜色转换。
 
 属性：
 1. instanceCount: 子layer复制的个数（是包含源layer的总个数），默认为1。
 2. instanceDelay: 在子layer进行动画的前提下，下一个复制layer的动画执行延迟, 默认为0。
 3. preservesDepth: 定义此图层是否将其子图层展平到其平面中，默认是false。如果为true，则与CATransformLayer行为类似，并具有相同的限制。
 
 4. instanceColor: 将此颜色和源对象的颜色相乘，默认是白色。例如 源layer的背景色是红色(1, 0, 0, 1), instanceColor的颜色RGBA为(1, 1, 1, 0.5)，相乘后得到透明度为0.5的红色(1, 0, 0, 0.5)。
    Defines the color used to multiply the source object. Animatable. Defaults to opaque white.
 5. instanceRedOffset: 设置每个复制图层相对上一个复制图层的红色偏移量(默认为0)。 例如：instanceRedOffset = -0.2 则 每次红色component减少0.2
 6. instanceGreenOffset: 设置每个复制图层相对上一个复制图层的绿色偏移量(默认为0)。
 7. instanceBlueOffset: 设置每个复制图层相对上一个复制图层的蓝色偏移量(默认为0)。
 8. instanceAlphaOffset: 设置每个复制图层相对上一个复制图层的透明度偏移量(默认为1)。
 
 
 注意：经试验，这四个offset 好像只能为 负数 [-1 ~ 0] 之间才有效果（即递减）。
    如instanceAlphaOffset = -0.2，即当前图层实例的alpha值 = 上一个图层实例的alpha - 0.2。
    API中的说明：“The instanceRedOffset is added to the red color component of instance k-1 to produce the modulation color of instance k.”  难道意思是递减才产生的效果？不是很理解。。。
 
 */

/**
 
 注意：属性“instanceTransform”的使用细节:
 1.在使用CATransform3DRotate的时候，CAReplicatorLayer的frame一定要设置成子layer一样的size，否则计算会非常麻烦；并且在旋转后，参考系也跟随旋转。
 2.在为子layer添加动画的时候，也要考虑到变换的参考系。
 
 */

/**

 总结了两种方式做子layer的圆形rotate位置布局：
 1.设置replicatorLayer的subLayer的位置，再做instanceTransform的rotate。(如 demo3)
 2.直接赋值instanceTransform，在tarnsform中先做Translation再加入rotate。(如 demo5)
 推荐用方式1，可以看到方式1中的demo3，是围绕着replicatorLayer为圆点(解除replicatoLayer的背景色注释可以观察到)， 而方式2的demo5中红点(replicatorLayer)位置在上方 不便于确定位置.
 
*/


import UIKit

class CAReplicatorLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo1() // 横排红色渐变色块
        
        demo2() // 横排 + 竖排 渐变色块
        
        demo3() // 闪烁的黄色圆
        
        demo4() // 转圈的绿色圆
        
        demo5() // 转圈缩放的正方形
    }
    
    // MARK: - 横排红色渐变色块
    func demo1() {
        let instanceCount = 5
        let squareSize = CGSize(width: 50, height: 50)
        let squareMargin = 5
        
        // 初始方块为白色
        let redSquare = CALayer()
        redSquare.backgroundColor = UIColor.white.cgColor
        redSquare.frame = CGRect(origin: .zero, size: squareSize)
        
        // replicator layer
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 50, y: 100, width: squareSize.width, height: squareSize.height)
        replicatorLayer.instanceCount = instanceCount
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(squareSize.width + CGFloat(squareMargin), 0, 0)
        
        // 渐变为红色（redSquare原始背景是白色，现在递减绿色和蓝色component，就逐渐变成了红色）
        let offsetStep = -1 / Float(instanceCount)
        replicatorLayer.instanceGreenOffset = offsetStep
        replicatorLayer.instanceBlueOffset = offsetStep
        
        // 将redSquare作为replicatorLayer的子图层
        replicatorLayer.addSublayer(redSquare)
        view.layer.addSublayer(replicatorLayer)
        
        
        // 添加动画
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.valueFunction = CAValueFunction(name: kCAValueFunctionTranslateX)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 2
        redSquare.add(anim, forKey: nil)
    }
    
    // MARK: - 横排 + 竖排 渐变色块
    func demo2() {
        let rowCount = 5
        let colCount = 5
        let squareSize = CGSize(width: 50, height: 50)
        let squareMargin = 5
        
        // 初始方块为白色
        let redSquare = CALayer()
        redSquare.backgroundColor = UIColor.white.cgColor
        redSquare.frame = CGRect(origin: .zero, size: squareSize)
        
        // 第一排5个 replicator layer
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(origin: .zero, size: squareSize)
        replicatorLayer.instanceCount = colCount
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(squareSize.width + CGFloat(squareMargin), 0, 0)
        
        // 渐变为红色（redSquare原始背景是白色，现在递减绿色和蓝色component，就逐渐变成了红色）
        let offsetStep = -1 / Float(colCount)
        replicatorLayer.instanceGreenOffset = offsetStep
        replicatorLayer.instanceBlueOffset = offsetStep
        
        // 将redSquare作为replicatorLayer的子图层
        replicatorLayer.addSublayer(redSquare)
        
        
        // 将第一排的replicator layer作为整体，再竖着复制5个
        let outerReplicatorLayer = CAReplicatorLayer()
        outerReplicatorLayer.frame = CGRect(x: 50, y: 200, width: squareSize.width, height: squareSize.height)
        outerReplicatorLayer.instanceCount = rowCount
        outerReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, squareSize.width + CGFloat(squareMargin), 0)
        outerReplicatorLayer.instanceRedOffset = -1 / Float(rowCount)
        
        outerReplicatorLayer.addSublayer(replicatorLayer)
        view.layer.addSublayer(outerReplicatorLayer)
    }
    
    // MARK: - 闪烁的黄色圆
    func demo3() {
        let count = 20
        let size = CGSize(width: 10, height: 10)
        let duration: Double = 1
        
        let circle = CALayer()
        circle.frame = CGRect(origin: CGPoint(x: 50, y: 0), size: size)
        circle.backgroundColor = UIColor.orange.cgColor
        circle.cornerRadius = size.width / 2
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 100, y: 550, width: size.width, height: size.height)
//        replicatorLayer.backgroundColor = UIColor.red.cgColor // 解除注释来观察原点效果
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(count), 0, 0, 1)
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
        
        // 添加动画
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = duration
        anim.repeatCount = Float.greatestFiniteMagnitude
        circle.add(anim, forKey: nil)
        
        
    }
    
    // MARK: - 转圈的绿色圆
    // 只在demo3中添加了最后一句代码，设置每个复制layer的动画延迟时间"replicatorLayer.instanceDelay = ..."
    func demo4() {
        let count = 20
        let size = CGSize(width: 10, height: 10)
        let duration: Double = 1
        
        let circle = CALayer()
        circle.frame = CGRect(origin: CGPoint(x: 50, y: 0), size: size)
        circle.backgroundColor = UIColor.green.cgColor
        circle.cornerRadius = size.width / 2
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 250, y: 550, width: size.width, height: size.height)
//        replicatorLayer.backgroundColor = UIColor.red.cgColor // 解除注释来观察原点效果
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(count), 0, 0, 1)
        replicatorLayer.instanceDelay = duration / Double(count)
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
        
        // 添加动画
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = duration
        anim.repeatCount = Float.greatestFiniteMagnitude
        circle.add(anim, forKey: nil)
    }
    
    // MARK: - 转圈缩放的正方形
    func demo5() {
        let size = CGSize(width: 15, height: 15)
        let count = 15
        let duration: Double = 1
        
        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.backgroundColor = UIColor.cyan.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 160, y: 630, width: size.width, height: size.height)
        replicatorLayer.backgroundColor = UIColor.red.cgColor
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceDelay = duration / Double(count)
        let t = CATransform3DMakeTranslation(size.width * 2, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DRotate(t, CGFloat.pi * 2 / CGFloat(count), 0, 0, 1)
        replicatorLayer.addSublayer(layer)
        view.layer.addSublayer(replicatorLayer)
        
        // 缩放动画
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = CATransform3DIdentity
        anim.toValue = CATransform3DMakeScale(0.1, 0.1, 1)
        anim.duration = duration
        anim.repeatCount = Float.greatestFiniteMagnitude
        layer.add(anim, forKey: nil)
    }
}
