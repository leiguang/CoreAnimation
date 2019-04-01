//
//  RoundProgressButton.swift
//  CoreAnimation
//
//  Created by Guang Lei  on 2019/4/1.
//  Copyright © 2019 雷广. All rights reserved.
//

import UIKit

class RoundProgressButton: UIControl {
    private var placeholderRingLayer = CAShapeLayer()
    private var progressRingLayer = CAShapeLayer()
    private var centerRoundLayer = CAShapeLayer()
    
    var maximumStep: Int = 5
    var step: Int = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isEnabled = false

        placeholderRingLayer.fillColor = nil
        placeholderRingLayer.strokeColor = UIColor.lightGray.cgColor
        placeholderRingLayer.lineWidth = 5
        layer.addSublayer(placeholderRingLayer)
        
        progressRingLayer.strokeColor = UIColor.green.cgColor
        progressRingLayer.fillColor = nil
        progressRingLayer.lineWidth = 10
        progressRingLayer.strokeStart = 0
        progressRingLayer.strokeEnd = 0
        layer.addSublayer(progressRingLayer)
        
        centerRoundLayer.fillColor = UIColor.red.cgColor
        centerRoundLayer.isHidden = true
        layer.addSublayer(centerRoundLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderRingLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        
        progressRingLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        
        let centerBounds = bounds.insetBy(dx: 10, dy: 10)
        centerRoundLayer.path = UIBezierPath(roundedRect: centerBounds, cornerRadius: centerBounds.height / 2).cgPath
    }
    
    private func updateProgress() {
        centerRoundLayer.isHidden = step < maximumStep
        progressRingLayer.strokeEnd = CGFloat(step) / CGFloat(maximumStep)
        isEnabled = step >= maximumStep
    }
}
