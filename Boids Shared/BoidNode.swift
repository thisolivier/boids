//
//  BoidNode.swift
//  Boids
//
//  Created by Olivier Butler on 07/04/2021.
//

import SpriteKit

class BoidNode: SKSpriteNode {
    
    public init(radius: CGFloat) {
        super.init(
            texture: nil,
            color: SKColor.clear,
            size: CGSize(width: radius, height: radius))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var velocity: CGVector = .init(dx: 10.0, dy: 10.0)
    
    func setupNode(color: SKColor, position: CGPoint, heading: CGVector) {
        let circle = SKShapeNode(circleOfRadius: self.size.width)
        circle.strokeColor = color
        circle.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.velocity = heading
        self.addChild(circle)
        self.position = position
    }
    
    func move() {
        self.position = CGPoint(x: self.position.x + velocity.dx, y: self.position.y + velocity.dy)
    }
}
