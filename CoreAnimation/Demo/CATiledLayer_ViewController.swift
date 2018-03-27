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
 
 用于大尺寸图片的加载（将大图切割成一块块小图，异步多次调用绘制代码，绘制单个小图到画布对应的位置上）。
    具体用法，可参考
    1.苹果提供的demo [PhotoScroller](https://developer.apple.com/library/content/samplecode/PhotoScroller/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010080-Intro-DontLinkElementID_2)或直接在https://developer.apple.com中搜索“CATiledlayer sample code”
    2.[仿百度地图加载地图模式/CATiledLayer](https://blog.csdn.net/tx874828503/article/details/51179101)
 
 */

import UIKit

class CATiledLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
}
