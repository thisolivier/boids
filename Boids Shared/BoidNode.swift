//
//  BoidNode.swift
//  Boids
//
//  Created by Olivier Butler on 07/04/2021.
//

import SpriteKit

class BoidNode: SKSpriteNode {
    
    public init(size: CGFloat) {
        super.init(
            texture: nil,
            color: SKColor.clear,
            size: CGSize())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var velocity: CGVector = .init(dx: 1.0, dy: 1.0)
    
    func setupNode(color: SKColor, position: CGPoint) {
        let circle = SKShapeNode(circleOfRadius: self.size.width)
        circle.fillColor = color
        circle.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(circle)
        self.position = position
    }
}
