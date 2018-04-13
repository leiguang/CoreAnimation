//
//  CAReplicatorLayer2_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/29.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CAReplicatorLayer]

import UIKit

class CAReplicatorLayer2_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        demo1() // 两个绿色方块，先平移，再旋转30° (观察instanceTransform效果)

        demo2() // 三个红色方块，组成三角形 (观察instanceTransform效果)
        
        demo3() // 3个蓝色圆形，组成的三角形排布
        
        demo4() // 类似于雷达的动画
        
        demo5() // 音量震动条
        
        demo6() // 从左到右缩放的动画
        
        demo7() // 跑马灯
    }
    
    // MARK: - 两个绿色方块，先平移，再旋转30° (观察instanceTransform效果)
    func demo1() {
        let size = CGSize(width: 50, height: 50)
        
        let circle = CALayer()
        circle.frame = CGRect(origin: .zero, size: size)
        circle.backgroundColor = UIColor.green.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 100, y: 100, width: size.width, height: size.height)
        replicatorLayer.backgroundColor = UIColor.lightGray.cgColor
        replicatorLayer.instanceCount = 2
        
        let t = CATransform3DMakeTranslation(size.width * 2, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DRotate(t, CGFloat.pi / 6, 0, 0, 1)
        
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
    }
    
    // MARK: - 三个红色方块，组成三角形 (观察instanceTransform效果)
    func demo2() {
        let size = CGSize(width: 50, height: 50)
        
        let circle = CALayer()
        circle.frame = CGRect(origin: .zero, size: size)
        circle.backgroundColor = UIColor.red.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 20, y: 200, width: size.width, height: size.height)
        replicatorLayer.backgroundColor = UIColor.lightGray.cgColor
        replicatorLayer.instanceCount = 3
        
        let t = CATransform3DMakeTranslation(size.width * 2, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DRotate(t, CGFloat.pi * 2 / 3, 0, 0, 1)
        
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
    }
    
    // MARK: - 3个蓝色圆形，组成的三角形排布
    // 示例：假如子layer是一个圆形layer，而我想实现一个正三角排布，下面这个instanceTransform的含义是，下一个复制layer会在上一个layer的参考系上先向x轴平移50像素，然后将参考系旋转120°，因为子layer的size和_rl的size相同，所以旋转以后子layer的位置并没有改变（如果size不同，则两个子layer的中心和_rl的中心诚成120°角），仅仅是改变了参考系（当前子layer的x轴在上一个子layer参考系的x轴的顺时针120°方向）
    func demo3() {
        let size = CGSize(width: 50, height: 50)
        
        let circle = CALayer()
        circle.frame = CGRect(origin: .zero, size: size)
        circle.backgroundColor = UIColor.blue.cgColor
        circle.cornerRadius = size.width / 2
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 200, y: 200, width: size.width, height: size.height)
        replicatorLayer.backgroundColor = UIColor.lightGray.cgColor
        replicatorLayer.instanceCount = 3
        
        let t = CATransform3DMakeTranslation(size.width * 2, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DRotate(t, CGFloat.pi * 2 / 3, 0, 0, 1)
        
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
    }

    // MARK: - 类似于雷达的动画
    func demo4() {
        let size = CGSize(width: 20, height: 20)
        
        let circle = CALayer()
        circle.frame = CGRect(origin: .zero, size: size)
        circle.backgroundColor = UIColor.orange.cgColor
        circle.cornerRadius = size.width / 2
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 100, y: 470, width: size.width, height: size.height)
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.addSublayer(circle)
        view.layer.addSublayer(replicatorLayer)
        
        // 放大动画
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = CATransform3DIdentity
        scale.toValue = CATransform3DMakeScale(5, 5, 1)
        // 透明度动画
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 1
        alpha.toValue = 0
        // 动画组
        let group = CAAnimationGroup()
        group.animations = [scale, alpha]
        group.duration = 2
        group.repeatCount = Float.greatestFiniteMagnitude
        circle.add(group, forKey: nil)
    }
    
    // MARK: - 音量震动条
    func demo5() {
        let size = CGSize(width: 10, height: 20)
        let count = 4
        let duration: Double = 0.8
        
        let layer = CALayer()
        layer.bounds = CGRect(origin: .zero, size: size)
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)   // 由于要保持layer底部不变，纵向朝上伸缩layer的高度，需要修改layer的锚点为(x: 0.5, y: 1), 这时position为 .zero
        layer.position = .zero
        layer.backgroundColor = UIColor.red.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 220, y: 520, width: size.width, height: size.height)
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceDelay = duration / Double(count)
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width * 1.5, 0, 0)
        replicatorLayer.addSublayer(layer)
        view.layer.addSublayer(replicatorLayer)
        
        // 缩放动画
        let anim = CABasicAnimation(keyPath: "transform.scale.y")
        anim.fromValue = 1
        anim.toValue = 5
        anim.duration = duration
        anim.autoreverses = true
        anim.repeatCount = Float.greatestFiniteMagnitude
        layer.add(anim, forKey: nil)
    }
    
    // MARK: - 从左到右缩放的动画
    func demo6() {
        let size = CGSize(width: 15, height: 15)
        let count = 10
        let duration: Double = 1

        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.backgroundColor = UIColor.cyan.cgColor

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 30, y: 600, width: size.width, height: size.height)
//        replicatorLayer.backgroundColor = UIColor.red.cgColor
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceDelay = duration / Double(count)
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width * 2, 0, 0)
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
    
    // MARK: - 跑马灯
    func demo7() {
        let size = CGSize(width: 520, height: 44)
        let duration: Double = 8
        
        let layer = CATextLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.foregroundColor = UIColor.cyan.cgColor
        layer.string = "  纸短情长啊，道不出太多涟漪，我的故事都是关于你啊~  "
        layer.fontSize = 18
        layer.alignmentMode = kCAAlignmentJustified
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 30, y: 660, width: 300, height: size.height)
        replicatorLayer.masksToBounds = true
        replicatorLayer.instanceCount = 2
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width, 0, 0)
        replicatorLayer.addSublayer(layer)
        view.layer.addSublayer(replicatorLayer)
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.fromValue = 0
        anim.toValue = -size.width
        anim.duration = duration
        anim.repeatCount = Float.greatestFiniteMagnitude
        anim.beginTime = CACurrentMediaTime() + 1
        layer.add(anim, forKey: nil)
    }
}
