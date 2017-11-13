//
//  ViewController.swift
//  FaceIt
//
//  Created by j on 11/9/17.
//  Copyright © 2017 Jacob Lo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet weak var faceview: FaceView! {
    didSet {
      let handler = #selector ( FaceView.changeScale(byReactingTo:) )
      let pinchRecognizer = UIPinchGestureRecognizer (target: faceview, action: handler )
      faceview.addGestureRecognizer(pinchRecognizer)
      let toggleHandler = #selector ( togglesEyes(byReactingTo:) )
      let tapRecognizer = UITapGestureRecognizer ( target : self, action : toggleHandler )
      tapRecognizer.numberOfTapsRequired = 1
      faceview.addGestureRecognizer(tapRecognizer )
      let swipeUpHandler = #selector ( increaseHappiness )
      let swipeUpRecognizer = UISwipeGestureRecognizer (target: self, action: swipeUpHandler )
      swipeUpRecognizer.direction = .up
      faceview.addGestureRecognizer(swipeUpRecognizer )
      let swipeDownHandler = #selector ( decreaseHappiness )
      let swipeDownRecognizer = UISwipeGestureRecognizer (target: self, action: swipeDownHandler )
      swipeDownRecognizer.direction = .down
      faceview.addGestureRecognizer(swipeDownRecognizer )
      
      updateUI()
    }
  }
  
  func increaseHappiness() {
    expression = expression.happier
  }
  
  func decreaseHappiness() {
    expression = expression.sadder
  }
  
  func togglesEyes ( byReactingTo tapRecognizer : UITapGestureRecognizer ) {
    
    if tapRecognizer.state == .ended {
      let eyes : FacialExpression.Eyes = (expression.eyes == .closed ) ? .open : .closed
      expression = FacialExpression ( eyes : eyes, mouth : expression.mouth )
    }
  }

  var expression = FacialExpression( eyes : .open, mouth : .grin ) {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    
    switch expression.eyes {
    case .open:
      faceview?.m_EyeOpen = true
    case .squinting:
      faceview?.m_EyeOpen = false
    case .closed:
      faceview?.m_EyeOpen = false
    }
    faceview?.m_MouthCurvature = mouthCurvatures[ expression.mouth ] ?? 0.0
  }
  
  private let mouthCurvatures = [
    FacialExpression.Mouth.grin : 0.5
    , .frown : -1.0
    , .smile : 1.0
    , .neutral : 0.0
    , .smirk : -0.5
  ]
}

