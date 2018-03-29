//
//  CAEmitterLayer_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/27.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CAEmitterLayer] 粒子系统


/**

 具体使用可参考文章[CAEmitterLayer精解](https://www.jianshu.com/p/197c2257f597)
 该文章十分详细地讲解了CAEmitterLayer中 发射形状、方向、速度、大小、颜色变化、旋转、时间等的使用。
 (该文章转为长图片(http://cwb.assets.jianshu.io/notes/images/4212093/weibo/image_496727cde296.jpg))

 */


import UIKit

class CAEmitterLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo1()
    }

    func demo1() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = view.bounds
        emitterLayer.emitterPosition = CGPoint(x: 200, y: 400)
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 100
        cell.lifetime = 5
        cell.alphaSpeed = -0.3
        cell.velocity = 50
        cell.velocityRange = 50
        cell.emissionRange = CGFloat.pi * 2.0
        
        emitterLayer.emitterCells = [cell]
        
        view.layer.addSublayer(emitterLayer)
    }
    
    let image: UIImage = {
        let size = CGSize(width: 5, height: 5)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addEllipse(in: CGRect(origin: .zero, size: size))
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }()
}
