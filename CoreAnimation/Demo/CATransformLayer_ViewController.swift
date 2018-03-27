//
//  CATransformLayer_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/27.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CATransformLayer]

/**
 
 CATransformLayer对象用于创建真正的3D层次结构，而不像其他CALayer呈现的平面层次结构。
 CATransformLayer objects are used to create true 3D layer hierarchies, rather than the flattened hierarchy rendering model used by other CALayer classes.
 
 
 与常规图层不同，transform layer在Z = 0时不会将其sublayers平铺到平面中。 因此，它们不支持CALayer类合成模型的许多功能：
 1. 仅渲染transform layer 的sublayers。 由图层渲染的CALayer属性将被忽略，其中包括：backgroundColor，contents，边框样式属性，画笔样式属性等。
 2. 作为2D图像处理的属性也被忽略，包括：filters，backgroundFilters，compositingFilter，mask，masksToBounds和阴影样式属性。
 3. 不透明属性单独应用于每个子图层，transform layer不会把它们合成。
 4. 不应该在transform layer上调用hitTest：方法，因为它们没有可以映射点的2D坐标空间。
 
 Unlike normal layers, transform layers do not flatten their sublayers into the plane at Z=0. Due to this, they do not support many of the features of the CALayer class compositing model:
 1. Only the sublayers of a transform layer are rendered. The CALayer properties that are rendered by a layer are ignored, including: backgroundColor, contents, border style properties, stroke style properties, etc.
 2. The properties that assume 2D image processing are also ignored, including: filters, backgroundFilters, compositingFilter, mask, masksToBounds, and shadow style properties.
 3. The opacity property is applied to each sublayer individually, the transform layer does not form a compositing group.
 4. The hitTest: method should never be called on a transform layer as they do not have a 2D coordinate space into which the point can be mapped.
 */

import UIKit

class CATransformLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        demo()
    }

    func demo() {
        
        let layer = CATransformLayer()  // 如果是用CALayer创建，则看不到3D效果
        
        func layerOfColor(_ color: UIColor, zPosition: CGFloat) -> CALayer {
            let layer = CALayer()
            layer.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
            layer.backgroundColor = color.cgColor
            layer.zPosition = zPosition
            layer.opacity = 0.5
            
            return layer
        }
        
        layer.addSublayer(layerOfColor(.red, zPosition: 20))
        layer.addSublayer(layerOfColor(.green, zPosition: 40))
        layer.addSublayer(layerOfColor(.blue, zPosition: 60))
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 100
        
        layer.transform = CATransform3DRotate(perspective, 0.1, 0, 1, 0)
        view.layer.addSublayer(layer)
    }

}
