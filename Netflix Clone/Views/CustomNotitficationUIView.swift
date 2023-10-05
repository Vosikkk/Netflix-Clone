//
//  CustomNotitficationUIView.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 04.10.2023.
//

import UIKit

class CustomNotitficationUIView: UIView {
    
    // MARK: - Properties
    private var checkMarkLayer: CAShapeLayer?
    
    private var cornerRadius: CGFloat {
        return bounds.size.height / SizeRatio.cornerRadiusToBoundsHeight
    }
    private let colorMark = UIColor.green
    
    private let borderWidth: CGFloat = 5.0
    
    private var maxOvalFrame: CGRect {
        return bounds.zoom(by: SizeRatio.maxOvalSizeToBoundsSize)
    }
    
    private var ovalHeight: CGFloat {
        return ovalFrame.height * SizeRatio.ovalHeightToFaceHeight
    }
    
    private var ovalFrame: CGRect {
        let ovalWidth = maxOvalFrame.height * AspectRatio.ovalFrame
        return maxOvalFrame.insetBy(dx: (maxOvalFrame.width - ovalWidth) / 2, dy: 0)
    }
  
    
   // MARK: - Core 
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.systemGray.setFill()
        roundedRect.fill()
      
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureState()
    }
    
    
    // MARK: Functions
    func animateCheckMark(completion: @escaping () -> Void) {
        if checkMarkLayer == nil {
                let size = CGSize(width: ovalFrame.width, height: ovalHeight)
                let origin = CGPoint(x: ovalFrame.minX, y: ovalFrame.midY - ovalHeight / 2)
                let rect = CGRect(origin: origin, size: size)
                
                let newCheckMarkLayer = CAShapeLayer()
                newCheckMarkLayer.path = pathForСheckMark(in: rect).cgPath
                newCheckMarkLayer.strokeColor = colorMark.cgColor
                newCheckMarkLayer.fillColor = UIColor.clear.cgColor
                newCheckMarkLayer.lineWidth = 3.0
                newCheckMarkLayer.strokeEnd = 0.0
                
                layer.addSublayer(newCheckMarkLayer)
                checkMarkLayer = newCheckMarkLayer
            }
        animateCheckMarkLayer(checkMarkLayer!, completion: completion)
    }

    private func animateCheckMarkLayer(_ checkMarkLayer: CAShapeLayer, completion: @escaping () -> Void) {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 1.5 // Тривалість анімації
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }

        checkMarkLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")
        CATransaction.commit()
    }

    
    private func configureState() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        isOpaque = false
           
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    }
    

    private func pathForСheckMark(in rect: CGRect) -> UIBezierPath {
        let checkMark = UIBezierPath()
        
        let radius = min(rect.size.width, rect.size.height) / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        checkMark.addArc(withCenter: center,
                         radius: radius,
                         startAngle: 0.0,
                         endAngle: CGFloat.pi * 2,
                         clockwise: true)
        
        let checkMarkPath = UIBezierPath()
        let startPoint = center.offsetBy(dx: -radius * 0.3, dy: 0)
        let endPoint = center.offsetBy(dx: -radius * 0.1, dy: radius * 0.2)
        let finalPoint = center.offsetBy(dx: radius * 0.4, dy: -radius * 0.4)
        
        checkMarkPath.move(to: startPoint)
        checkMarkPath.addLine(to: endPoint)
        checkMarkPath.addLine(to: finalPoint)
        
        checkMark.append(checkMarkPath)
        
        return checkMark
    }
    
    
    // MARK: - Nested types
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let maxOvalSizeToBoundsSize: CGFloat = 1.4
        static let ovalHeightToFaceHeight: CGFloat = 0.5
    }
    
    private struct AspectRatio {
        static let ovalFrame: CGFloat = 0.60
    }
}
