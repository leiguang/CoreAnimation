//
//  CAScrollLayer_ViewController.swift
//  CoreAnimation
//
//  Created by 雷广 on 2018/3/27.
//  Copyright © 2018年 雷广. All rights reserved.
//

// MARK: - [CAScrollLayer]

/**
 
 CAScrollLayer能显示比其自身范围大的可滚动内容。
 它是CALayer的一个子类，它简化了显示图层的一部分。 CAScrollLayer的可滚动区域的范围由其子层的布局定义。 通过将原点指定为要显示的内容的点或矩形区域来设置图层内容的可见部分。 CAScrollLayer不提供键盘或鼠标事件处理，也不提供可见的滚动条。
 
 A layer that displays scrollable content larger than its own bounds.
 The CAScrollLayer class is a subclass of CALayer that simplifies displaying a portion of a layer. The extent of the scrollable area of the CAScrollLayer is defined by the layout of its sublayers. The visible portion of the layer content is set by specifying the origin as a point or a rectangular area of the contents to be displayed. CAScrollLayer does not provide keyboard or mouse event-handling, nor does it provide visible scrollers.
 */

/**
 有”scrollMode“属性：kCAScrollNone、kCAScrollVertically、kCAScrollHorizontally、kCAScrollBoth。默认值为kCAScrollBoth。
 方法“func scroll(to p: CGPoint)”、“func scroll(to r: CGRect)”受到此属性控制，例如设置只能水平滚动后，调用scroll方法不会在竖直方向上有偏移，只会水平移动。
*/

import UIKit

class CAScrollLayer_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        demo()
    }

    func demo() {
        let layer = CALayer()
        let image = UIImage(named: "image")!.cgImage!
        let scale = UIScreen.main.scale
        layer.frame = CGRect(x: 0, y: 0, width: CGFloat(image.width) / scale, height: CGFloat(image.height) / scale)
        layer.contents = image
        layer.contentsScale = scale
   
        // 这里为了添加拖动手势，重写了UIView的layerClass属性，改为CAScrollLayer。 （当然也可以直接把CAScrollLayer添加到带手势的UIView的layer上）
        let scrollView = ScrollView(frame: CGRect(x: 0, y: 200, width: 250, height: 250))
        scrollView.backgroundColor = UIColor.cyan
        scrollView.layer.addSublayer(layer)
        view.addSubview(scrollView)
    }
}

class ScrollView: UIView {
    
    override class var layerClass: AnyClass {
        return CAScrollLayer.self
    }
    
    private func setup() {
        // enable clipping
        self.layer.masksToBounds = true
        
        // attach pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        // get the offset by subtracting the pan gesture
        // translation from the current bounds origin
        var offset = self.bounds.origin
        offset.x -= gesture.translation(in: self).x
        offset.y -= gesture.translation(in: self).y
        
        // scroll the layer
        (self.layer as! CAScrollLayer).scroll(to: offset)
        
        // reset the pan gesture translation
        gesture.setTranslation(.zero, in: self)
    }
    
    override init(frame: CGRect) {
        // this is called when view is created in code
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        // this is called when view is created from a nib
        setup()
    }
    
}
