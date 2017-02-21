//
//  PushButtonView.swift
//  PushTheButton
//
//  Created by Nychka, Tyler on 1/21/17.
//  Copyright © 2017 Nychka, Tyler. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class PushButtonSprite: SKShapeNode {
    var happy = 1
    var faceLabel = SKLabelNode()
    init(rectOf: CGSize, location: CGPoint, cornerRadius: CGFloat, fillColor: UIColor) {
        super.init()
        self.path = UIBezierPath(roundedRect: CGRect(x: location.x, y: location.y, width: rectOf.width, height: rectOf.height), cornerRadius: cornerRadius).cgPath
        self.fillColor = fillColor
        self.strokeColor = UIColor.white
        self.lineWidth = 10
        
        faceLabel.text = ":)"
        faceLabel.fontName = "AvenirNext-Heavy"
        faceLabel.fontColor = UIColor.black
        faceLabel.fontSize = 70
        faceLabel.position.x = location.x + rectOf.width/2 - 20
        faceLabel.position.y = location.y + rectOf.height/2
        faceLabel.zRotation = -1.6
        addChild(faceLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
