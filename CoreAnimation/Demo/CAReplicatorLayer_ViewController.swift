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

import UIKit

class CAReplicatorLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo1() // 横排渐变
        
        demo2() // 横排 + 竖排 渐变
        
        demo3() //
    }
    
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
    
    func demo3() {
        
    }
    
}