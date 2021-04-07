//
//  BoidNode.swift
//  Boids
//
//  Created by Olivier Butler on 07/04/2021.
//


// For the alignment function
// You want to take all the angles around you,
// And align yourself to that average value moderated by an 'attraction force'

import SpriteKit

class BoidNode: SKSpriteNode {
    
    typealias CGFloatRange = ClosedRange<CGFloat>
    
    var velocity: CGVector = .init(dx: 10.0, dy: 10.0)
    var xRange: CGFloatRange = 0...0
    var yRange: CGFloatRange = 0...0
    var speedLimit: CGFloat = 6
    
    var depthOfVision: CGFloat = 50
    var fieldOfVision: CGFloat = 200
    
    
    public init(radius: CGFloat, gameSize: CGSize) {
        super.init(
            texture: nil,
            color: SKColor.clear,
            size: CGSize(width: radius, height: radius))
        let halfWidth = gameSize.width / 2
        let halfHeight = gameSize.height / 2
        self.xRange = (halfWidth * -1)...halfWidth
        self.yRange = (halfHeight * -1)...halfHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNode(color: SKColor, position: CGPoint, heading: CGVector) {
        let circle = SKShapeNode(circleOfRadius: self.size.width)
        circle.strokeColor = color
        circle.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.velocity = heading
        self.addChild(circle)
        self.position = position
    }
    
    func move(in flock: [BoidNode]) {
        let flockExcludingSelf = flock.filter { $0 != self }
        let avoidNeighboursVelocity = Self.updateVelocityToAvoidNeighbours(
            currentPositon: self.position,
            oldVelocity: self.velocity,
            depthOfVision: self.depthOfVision,
            flock: flockExcludingSelf)
        let speedLimitedVelocity = Self.applySpeedLimit(to: avoidNeighboursVelocity, limit: speedLimit)
        let boundariedVelocity = Self.updateVelocityToAvoidBounds(
            currentPositon: self.position,
            oldVelocity: speedLimitedVelocity,
            xRange: self.xRange,
            yRange: self.yRange)
        
        
        self.position = CGPoint(
            x: self.position.x + boundariedVelocity.dx,
            y: self.position.y + boundariedVelocity.dy)
        self.velocity = boundariedVelocity
    }
    
    static func updateVelocityToAvoidNeighbours(currentPositon: CGPoint, oldVelocity: CGVector, depthOfVision: CGFloat, flock: [BoidNode]) -> CGVector {
        
        let vectorsBetweenMeAndThem: [CGVector] = flock
            .map {
                CGVector(dx: $0.position.x - currentPositon.x,
                         dy: $0.position.y - currentPositon.y)}
            .filter { $0.length < depthOfVision }
            .filter { abs(RelativePositions.angleOffset(heading: oldVelocity, alien: $0)) < 1.5  }
        
        // let lengths = vectorsBetweenMeAndThem.map{ $0.length }
        
        guard !vectorsBetweenMeAndThem.isEmpty else {
            return oldVelocity
        }
        
        // print(lengths)
        
//        let anglesBetweenMeAndThem: [CGFloat] = flock
//            .map {
//                CGVector(dx: currentPositon.x + $0.position.x,
//                         dy: currentPositon.y + $0.position.y)}
//            .filter { $0.length < depthOfVision }
//            .map { RelativePositions.angleOffset(heading: oldVelocity, alien: $0) }
//            .filter { abs($0) < 50 }
        
        
        let count: CGFloat = CGFloat(vectorsBetweenMeAndThem.count)
        let resultantVector: CGVector = vectorsBetweenMeAndThem
            .reduce(CGVector.zero, { (resultVector, nextElement) in
                let xValue = resultVector.dx + nextElement.dx
                let yValue = resultVector.dy + nextElement.dy
                return CGVector(dx: xValue, dy: yValue)
            })
        let normalisedResultantVector: CGVector = CGVector(
            dx: (resultantVector.dx / count) * 0.03,
            dy: (resultantVector.dy / count) * 0.03)
        
        return CGVector(
            dx: oldVelocity.dx - normalisedResultantVector.dx,
            dy: oldVelocity.dy - normalisedResultantVector.dy)
    }
    
    static func updateVelocityToAvoidBounds(currentPositon: CGPoint, oldVelocity: CGVector, xRange: CGFloatRange, yRange: CGFloatRange) -> CGVector {
        let newX = currentPositon.x + oldVelocity.dx
        let newY = currentPositon.y + oldVelocity.dy
        var newVelocity: CGVector?
        
        switch(!xRange.contains(newX), !yRange.contains(newY)) {
        case (true, true):
            newVelocity = CGVector(dx: oldVelocity.dx * -1, dy: oldVelocity.dy * -1)
        case (true, false):
            newVelocity = CGVector(dx: oldVelocity.dx * -1, dy: oldVelocity.dy)
        case(false, true):
            newVelocity = CGVector(dx: oldVelocity.dx, dy: oldVelocity.dy * -1)
        case (false, false):
            break
        }
        
        return newVelocity ?? oldVelocity
    }
    
    static func applySpeedLimit(to velocity: CGVector, limit: CGFloat) -> CGVector {
        let length = velocity.length
        if length > limit {
            let ratio = limit / length
            return CGVector(dx: velocity.dx * ratio, dy: velocity.dy * ratio)
        } else {
            return velocity
        }
    }
}

enum NeighbourPosition {
    case left, right, ahead, outOfSight
}
