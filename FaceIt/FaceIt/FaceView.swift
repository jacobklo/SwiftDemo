//
//  FaceView.swift
//  FaceIt
//
//  Created by j on 11/9/17.
//  Copyright © 2017 Jacob Lo. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
  
  @IBInspectable
  var m_Scale : CGFloat = 0.9
  { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var m_EyeOpen : Bool = true
  { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var m_MouthCurvature : Double = 1.0 // 1 = smaile to -1 to frown
  { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var m_LineWidth : CGFloat = 5.0
  { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var m_Color : UIColor = UIColor.blue
  { didSet { setNeedsDisplay() } }
  
  
  func changeScale ( byReactingTo pinchRecognizer : UIPinchGestureRecognizer ) {
    
    switch pinchRecognizer.state {
      
    case .changed : fallthrough
    case .ended:
      m_Scale *= pinchRecognizer.scale
      pinchRecognizer.scale = 1
    default : break
      
    }
  }
  
  private var skullRadius :CGFloat {
    return min( bounds.size.width, bounds.size.height ) / 2 * m_Scale
  }
  private var skullCenter : CGPoint {
    return CGPoint( x : bounds.midX , y : bounds.midY )
  }
  
  private struct Ratios {
    static let skullRadiosToEyeOffset : CGFloat = 3
    static let skullRadiosToEyeRadius : CGFloat = 10
    static let skullRadiosToMouthWidth : CGFloat = 1
    static let skullRadiosToMouthHeight : CGFloat = 3
    static let skullRadiosToMouthOffset : CGFloat = 3
  }
  
  private func pathForSkull() -> UIBezierPath {
    let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false )
    path.lineWidth = m_LineWidth
    return path
  }
  
  private enum Eye {
    case left
    case right
  }
  
  private func pathForEye(_ eye : Eye ) -> UIBezierPath {
    
    func centerOfEye( _ eye : Eye ) -> CGPoint {
      let eyeOffset = skullRadius / Ratios.skullRadiosToEyeOffset
      var eyeCenter = skullCenter
      eyeCenter.y -= eyeOffset
      eyeCenter.x += ( eye == Eye.left ? -1 : 1 ) * eyeOffset
      return eyeCenter
    }
    
    let eyeRadius = skullRadius / Ratios.skullRadiosToEyeRadius
    let eyeCenter = centerOfEye ( eye )
    
    let path : UIBezierPath
    if (m_EyeOpen ) {
      path = UIBezierPath (arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi - 1, clockwise: true )
    }
    else {
      path = UIBezierPath()
      path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y ) )
      path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y ) )
    }
    path.lineWidth = m_LineWidth
    return path
  }
  
  private func pathForMouth () -> UIBezierPath {
    let mouthWidth = skullRadius / Ratios.skullRadiosToMouthWidth
    let mouthHeight = skullRadius / Ratios.skullRadiosToMouthHeight
    let mouthOffset = skullRadius / Ratios.skullRadiosToMouthOffset
    
    let mouthRect = CGRect (
      x: skullCenter.x - mouthWidth / 2
      , y : skullCenter.y + mouthOffset
      , width: mouthWidth
      , height: mouthHeight )
    
    let start = CGPoint (x: mouthRect.minX , y: mouthRect.midY )
    let end = CGPoint (x: mouthRect.maxX, y: mouthRect.midY )
    
    let smileOffset = CGFloat ( max ( -1, min ( m_MouthCurvature, 1 ))) * mouthRect.height
    
    let cp1 = CGPoint ( x: start.x + mouthRect.width / 3 , y: start.y + smileOffset )
    let cp2 = CGPoint ( x: end.x - mouthRect.width  / 3 , y : start.y + smileOffset )
    
    let path = UIBezierPath()
    path.move(to: start)
    path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2 )
    
    path.lineWidth = m_LineWidth
    return path
  }
  
  override func draw(_ rect: CGRect) {
    m_Color.set()
    pathForSkull().stroke()
    pathForEye(Eye.left ).stroke()
    pathForEye(Eye.right ).stroke()
    pathForMouth().stroke()
  }
  
  
}
