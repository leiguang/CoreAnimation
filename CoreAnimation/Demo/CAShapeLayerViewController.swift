//
//  CAShapeLayerViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/23.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class CAShapeLayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        flower()
        line()
        circle()
        
    }

    // Creating a stylized flower with a shape layer
    func flower() {
        let width: CGFloat = 320
        let height: CGFloat = 320
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 100, width: width, height: height)
        shapeLayer.backgroundColor = UIColor.cyan.cgColor
        
        let path = CGMutablePath()
        
        stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 6).forEach { (angle) in
            var transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: width / 2, y: height / 2))
            let petal = CGPath(ellipseIn: CGRect(x: -20, y: 0, width: 40, height: 100), transform: &transform)
            path.addPath(petal)
        }
        
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        
        view.layer.addSublayer(shapeLayer)
        
        
        // add stroke animation
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 5.0
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(anim, forKey: "path")
    }
    
    
    func line() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 50, y: 450, width: 200, height: 20)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 200, y: 10))
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 20
        shapeLayer.strokeColor = UIColor.red.cgColor
        view.layer.addSublayer(shapeLayer)
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 3.0
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(anim, forKey: nil)
    }
   
    func circle() {
        
        // 渐变层
        let gradientLayer = CALayer()
        gradientLayer.frame = CGRect(x: 50, y: 500, width: 100, height: 100)
        view.layer.addSublayer(gradientLayer)
        
        let leftGradientLayer = CAGradientLayer()
        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        leftGradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        leftGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        leftGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.addSublayer(leftGradientLayer)
        
        let rightGradientLayer = CAGradientLayer()
        rightGradientLayer.frame = CGRect(x: 50, y: 0, width: 50, height: 100)
        rightGradientLayer.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        rightGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        rightGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.addSublayer(rightGradientLayer)
        
        // border
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let borderPath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 45, startAngle: -CGFloat.pi / 2 + 0.15, endAngle: CGFloat.pi * 3 / 2 + 0.15 , clockwise: true)
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 10
        borderLayer.lineCap = kCALineCapRound
        //
        gradientLayer.mask = borderLayer
        
        // 边框动画
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 3.0
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        borderLayer.add(anim, forKey: nil)
        
        // 中间层
        let contentLayer = CAShapeLayer()
        contentLayer.frame = CGRect(x: 50, y: 500, width: 100, height: 100)
        view.layer.addSublayer(gradientLayer)
        let contentPath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 40, startAngle: 0, endAngle: CGFloat.pi * 2 , clockwise: true)
        contentLayer.path = contentPath.cgPath
        contentLayer.fillColor = UIColor.yellow.cgColor
        view.layer.addSublayer(contentLayer)
        
    }
    
}
