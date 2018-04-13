//
//  CAReplicatorLayer3_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/4/13.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class CAReplicatorLayer3_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let size = CGSize(width: 10, height: 10)
        let count = 8
        let duration: CFTimeInterval = 1
        
        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.backgroundColor = UIColor.blue.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.backgroundColor = UIColor.red.cgColor
        replicatorLayer.instanceCount = count
        
        
        replicatorLayer.instanceDelay = duration / CFTimeInterval(count)
        
        let t = CATransform3DMakeTranslation(size.width * 2, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DRotate(t, CGFloat.pi * 2 / CGFloat(count), 0, 0, 1)
        replicatorLayer.addSublayer(layer)
        view.layer.addSublayer(replicatorLayer)
        
    }
    
}


