//
//  CATiledLayer_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/27.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CATiledLayer]

/**
 
 提供一种方式来异步提供图层内容的图块的图层，可能会在多个细节级别上进行缓存。
 随着渲染器需要更多数据，图层的draw（in :)方法在一个或多个后台线程上调用，以提供绘制操作以填充一个数据块。绘图上下文的剪辑边界和当前变换矩阵（CTM）可用于确定所请求的图块的边界和分辨率。
   
   概述:
   由于更新是异步的，所以使用setNeedsDisplay（_ :)方法，很可能下一次显示更新不会包含更新的内容，但未来的更新将会进行。
   
   注意：
   不要尝试直接修改CATiledLayer对象的contents属性。这样做会将图层转换为常规CALayer对象，而禁用了tiled layer提供的异步平铺内容的能力。
 
 A layer that provides a way to asynchronously provide tiles of the layer's content, potentially cached at multiple levels of detail.
 As more data is required by the renderer, the layer's draw(in:) method is called on one or more background threads to supply the drawing operations to fill in one tile of data. The clip bounds and current transformation matrix (CTM) of the drawing context can be used to determine the bounds and resolution of the tile being requested.
 
 Overview
 Regions of the layer may be invalidated using the setNeedsDisplay(_:) method however the update will be asynchronous. While the next display update will most likely not contain the updated content, a future update will.
 
 Important
 Do not attempt to directly modify the contents property of a CATiledLayer object. Doing so disables the ability of a tiled layer to asynchronously provide tiled content, effectively turning the layer into a regular CALayer object.
 
 */


/**
 
 用于大尺寸图片的加载（将大图切割成一块块小图，异步多次调用绘制代码，绘制单个小图到画布对应的位置上，小图加载时默认有0.25s的fade-in效果）。
    具体用法，可参考
    1.苹果提供的demo [PhotoScroller](https://developer.apple.com/library/content/samplecode/PhotoScroller/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010080-Intro-DontLinkElementID_2)或直接在https://developer.apple.com中搜索“CATiledlayer sample code”
    2.[仿百度地图加载地图模式/CATiledLayer](https://blog.csdn.net/tx874828503/article/details/51179101)
 
 */


/**
 个人总结的使用方式：
 1. 使用UIView，重写layerClass属性，返回CATiledLayer，然后再drawRect中提供绘制（参考苹果提供的demo[PhotoScroller]）；
 2. 继承CATiledLayer(同CALayer)，重写"func draw(in ctx: CGContext)"方法，提供内容 (例如本页中的demo)；
 3. 设置CALayerDelegate，在"func draw(_ layer: CALayer, in ctx: CGContext)"方法中提供内容（注意：若delegate对象为当前viewController，经试验，viewController销毁前，必须设置delegate为nil，否则会crash）
 注意：直接赋值contents属性会禁用CATiledLayer异步加载能力。
 
 
 滑动这个图片时，会发现当CATiledLayer载入小图的时候，它们会淡入到界面中，这是CATiledLayer的默认行为。CATiledLayer（不同于大部分的UIKit和Core Animation方法）支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用，所以请小心谨慎地确保在这个方法中实现的绘制代码是线程安全的。
 */

import UIKit

fileprivate let imageSize = CGSize(width: 1500, height: 1500)
fileprivate let tileSize = CGSize(width: 60, height: 40)

class CATiledLayer_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        demo()  // 本页使用小的颜色图片来做填充示例
    }
   
    func demo() {
        let layer = MyTiledLayer()
        layer.frame = CGRect(origin: .zero , size: imageSize)
        layer.tileSize = tileSize   // 默认是(256, 256)
        view.layer.addSublayer(layer)
        
        // 手势拖动效果，借用了前面写的CAScrollLayer_ViewController中的MyScrollView类
        let scrollView = MyScrollView(frame: CGRect(x: 0, y: 200, width: 300, height: 300))
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.layer.addSublayer(layer)
        view.addSubview(scrollView)
        
        // 调用图层setNeedDisplay, 否则代理方法不会被调用
        layer.setNeedsDisplay()
    }
    
    deinit {
        print("\(self) \(#function)")
    }
}

class MyTiledLayer: CATiledLayer {
    
    // 重写此方法来提供绘制内容
    override func draw(in ctx: CGContext) {
        let rect = ctx.boundingBoxOfClipPath  // 获取实际需要绘制的区域
        print(rect)
        
        ctx.draw(colorImage().cgImage!, in: rect)
    }
    
    func colorImage() -> UIImage {
        let red = arc4random_uniform(255)
        let green = arc4random_uniform(255)
        let blue = arc4random_uniform(255)
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
        
        UIGraphicsBeginImageContext(tileSize)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(color.cgColor)
        ctx.fill(CGRect(origin: .zero, size: tileSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    deinit {
        print("\(self) \(#function)")
    }
}
