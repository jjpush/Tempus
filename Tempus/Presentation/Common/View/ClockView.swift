//
//  ClockView.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

class ClockView: UIView {
    enum Constant {
        static let lineColor: CGColor = UIColor.black.cgColor
        static let lineWidth: CGFloat = 2.0
        static let clockBackgroundColor: CGColor = UIColor.systemGray6.cgColor
        static let startAngle: CGFloat = -75 * CGFloat.pi / 180
        
        static let splittedBackGroundColor: CGColor = UIColor(red:0.07, green:0.44, blue:0.54, alpha:0.4).cgColor
        
        static let dotRadius: CGFloat = 3.0
    }
    
    lazy var circleCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    lazy var radius = bounds.width * 0.95 / 2.0
    private var splitLayer = CALayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupBaseLine()
    }
}

private extension ClockView {
    func setupBaseLine() {
        setCircleLayer()
        setCircleCenterDotLayer()
        setClockNumber()
    }
    
    func setCircleLayer() {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: radius,
                                      startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        circleLayer.strokeColor = Constant.lineColor
        circleLayer.fillColor = Constant.clockBackgroundColor
        
        circleLayer.lineWidth = Constant.lineWidth
        circleLayer.path = circlePath.cgPath
                
        layer.addSublayer(circleLayer)
    }
    
    func setCircleCenterDotLayer() {
        let circleCenterDotLayer = CAShapeLayer()
        let circleCenterDotPath = UIBezierPath(arcCenter: circleCenter, radius: 1.0,
                                         startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                
        circleCenterDotLayer.strokeColor = Constant.lineColor
        circleCenterDotLayer.fillColor = Constant.clockBackgroundColor
                
        circleCenterDotLayer.lineWidth = Constant.lineWidth
        circleCenterDotLayer.path = circleCenterDotPath.cgPath

        layer.addSublayer(circleCenterDotLayer)
    }
    
    func setClockNumber() {
        let dotCount = 24
        let angleInterval = CGFloat.pi * 2 / CGFloat(dotCount)
        
        for i in 0..<dotCount {
            let angle = Constant.startAngle + CGFloat(i) * angleInterval
            
            let dotCenterX = circleCenter.x + radius * cos(angle)
            let dotCenterY = circleCenter.y + radius * sin(angle)
            let dotCenter = CGPoint(x: dotCenterX, y: dotCenterY)
            
            let dotPath = UIBezierPath()
            let lineCenterX = circleCenter.x + (radius * 0.95) * cos(angle)
            let lineCenterY = circleCenter.y + (radius * 0.95) * sin(angle)
            
            dotPath.move(to: dotCenter)
            dotPath.addLine(to: CGPoint(x: lineCenterX, y: lineCenterY))
            
            let dotLayer = CAShapeLayer()
            
            dotLayer.path = dotPath.cgPath
            dotLayer.strokeColor = Constant.lineColor
            layer.addSublayer(dotLayer)
            
            let numberLabel = UILabel()
            numberLabel.text = "\(i + 1)"
            numberLabel.font = UIFont.preferredFont(forTextStyle: .callout)
            numberLabel.sizeToFit()
            numberLabel.center.x = circleCenter.x + (radius * 0.88) * cos(angle)
            numberLabel.center.y = circleCenter.y + (radius * 0.88) * sin(angle)
            
            addSubview(numberLabel)
        }
    }
}
