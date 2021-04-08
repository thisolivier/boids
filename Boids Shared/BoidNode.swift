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
    var speedLimit: CGFloat = 8
    
    var depthOfVision: CGFloat = 70
    var fieldOfVision: CGFloat = 1.6
    var avoidanceIntensity: CGFloat = 0.6
    var attractionIntensity: CGFloat = 0.003
    var alignmentIntensity: CGFloat = 0.09
    var avoidanceRange: CGFloat = 2
    
    
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
        let circle = SKShapeNode(circleOfRadius: self.size.width/2)
        circle.strokeColor = color
        circle.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(circle)
        let headingNode = SKShapeNode(rect: CGRect(
                                        x: (self.size.width/2 - 2),
                                        y: self.size.height/2,
                                        width: 4,
                                        height: depthOfVision))
        headingNode.strokeColor = .yellow
        self.addChild(headingNode)
        self.velocity = heading
        
        self.position = position
    }
    
    func move(in flock: [BoidNode]) {
        
        let neighbours = findNeighbours(
            in: flock,
            velocity: self.velocity,
            currentPosition: self.position)
        
        let alignToNeighboursVector = Self.updateHeadingToMatchNeighbours(
            neighbours,
            oldVelocity: self.velocity,
            aligmentIntensity: self.alignmentIntensity)
        let flyTowardsNeighours = Self.updateVelocityToFlyTowardNeighbours(
            neighbours,
            oldVelocity: alignToNeighboursVector,
            attactionIntensity: attractionIntensity)
        let avoidNeighboursVector = Self.updateVelocityToAvoidNeighbours(
            neighbours,
            oldVelocity: flyTowardsNeighours,
            depthOfVision: self.depthOfVision,
            avoidanceIntensity: avoidanceIntensity,
            avoidanceRange: self.avoidanceRange)
        
        
        let speedLimitedVelocity = Self.applySpeedLimit(to: avoidNeighboursVector, limit: speedLimit)
        let newPosition = Self.updatePositionToAvoidBounds(
            currentPositon: CGPoint(
                x: self.position.x + speedLimitedVelocity.dx,
                y: self.position.y + speedLimitedVelocity.dy),
            xRange: self.xRange,
            yRange: self.yRange)
        DispatchQueue.global(qos: .userInteractive).async {
            self.position = newPosition
            self.velocity = speedLimitedVelocity
            self.zRotation = RelativePositions.angleOffset(
                heading: CGVector(dx: 0, dy: 1),
                alien: speedLimitedVelocity)
        }
    }
    
    func findNeighbours(
        in flock: [BoidNode],
        velocity: CGVector,
        currentPosition: CGPoint
    ) -> [BoidNeighbour] {
        return flock
            .filter { $0 != self }
            .map {
                let vectorToNeighbour = CGVector(
                    dx: $0.position.x - currentPosition.x,
                    dy: $0.position.y - currentPosition.y)
                let headingOfNeighbour = RelativePositions.angleOffset(
                    heading: velocity,
                    alien: vectorToNeighbour)
                return BoidNeighbour(
                    relativePosition: vectorToNeighbour,
                    distance: vectorToNeighbour.length,
                    deviationFromHeading: headingOfNeighbour,
                    boid: $0)
            }
            .filter { $0.distance < depthOfVision }
            .filter { abs($0.deviationFromHeading) < fieldOfVision }
    }
    
    static func updateHeadingToMatchNeighbours(
        _ neighbours: [BoidNeighbour],
        oldVelocity: CGVector,
        aligmentIntensity: CGFloat
    ) -> CGVector {
        guard !neighbours.isEmpty else { return oldVelocity }
        let totalNeighbourVelocity = neighbours
            .reduce(CGVector.zero, { (resultVector, nextElement) in
                let xValue = nextElement.boid.velocity.dx + resultVector.dx
                let yValue = nextElement.boid.velocity.dy + resultVector.dy
                return CGVector(dx: xValue, dy: yValue)
            })
        let normalisedTotalNeighbourVelocity = CGVector(
            dx: totalNeighbourVelocity.dx / totalNeighbourVelocity.length,
            dy: totalNeighbourVelocity.dy / totalNeighbourVelocity.length)
        let aligmentIntensityAdjustedDenominator = 1 + (1 * aligmentIntensity)
        return CGVector(
            dx: ((normalisedTotalNeighbourVelocity.dx * aligmentIntensity) + oldVelocity.dx) / aligmentIntensityAdjustedDenominator,
            dy: ((normalisedTotalNeighbourVelocity.dy * aligmentIntensity) + oldVelocity.dy) / aligmentIntensityAdjustedDenominator)
        
    }
    
    static func updateVelocityToFlyTowardNeighbours(
        _ neighbours: [BoidNeighbour],
        oldVelocity: CGVector,
        attactionIntensity: CGFloat
    ) -> CGVector {
        guard !neighbours.isEmpty else {
            return oldVelocity
        }
        let count: CGFloat = CGFloat(neighbours.count)
        let resultantVector: CGVector = neighbours
            .reduce(CGVector.zero, { (resultVector, nextElement) in
                let xValue = resultVector.dx + nextElement.relativePosition.dx
                let yValue = resultVector.dy + nextElement.relativePosition.dy
                return CGVector(dx: xValue, dy: yValue)
            })
        let normalisedResultantVector: CGVector = CGVector(
            dx: (resultantVector.dx / count) * attactionIntensity,
            dy: (resultantVector.dy / count) * attactionIntensity)
        
        return CGVector(
            dx: oldVelocity.dx + normalisedResultantVector.dx,
            dy: oldVelocity.dy + normalisedResultantVector.dy)
    }
    
    static func updateVelocityToAvoidNeighbours(
        _ neighbours: [BoidNeighbour],
        oldVelocity: CGVector,
        depthOfVision: CGFloat,
        avoidanceIntensity: CGFloat,
        avoidanceRange: CGFloat
    ) -> CGVector {
        let neighbours = neighbours.filter { $0.distance < depthOfVision / avoidanceRange }
        guard !neighbours.isEmpty else {
            return oldVelocity
        }
        let count: CGFloat = CGFloat(neighbours.count)
        let resultantVector: CGVector = neighbours
            .map { CGVector(
                dx: $0.relativePosition.dx / $0.distance,
                dy: $0.relativePosition.dy / $0.distance)}
            .reduce(CGVector.zero, { (resultVector, nextElement) in
                let xValue = resultVector.dx + nextElement.dx
                let yValue = resultVector.dy + nextElement.dy
                return CGVector(dx: xValue, dy: yValue)
            })
        let normalisedResultantVector: CGVector = CGVector(
            dx: (resultantVector.dx / count) * avoidanceIntensity,
            dy: (resultantVector.dy / count) * avoidanceIntensity)
        
        return CGVector(
            dx: oldVelocity.dx - normalisedResultantVector.dx,
            dy: oldVelocity.dy - normalisedResultantVector.dy)
    }
    
    static func updatePositionToAvoidBounds(currentPositon: CGPoint, xRange: CGFloatRange, yRange: CGFloatRange) -> CGPoint {
        switch(!xRange.contains(currentPositon.x), !yRange.contains(currentPositon.y)) {
        case (true, true):
            return CGPoint(x: currentPositon.x * -1, y: currentPositon.y * -1)
        case (true, false):
            return CGPoint(x: currentPositon.x * -1, y: currentPositon.y)
        case(false, true):
            return CGPoint(x: currentPositon.x, y: currentPositon.y * -1)
        case (false, false):
            return currentPositon
        }
    }
    
    static func applySpeedLimit(to velocity: CGVector, limit: CGFloat) -> CGVector {
        let length = velocity.length
        if length > limit {
            let ratio = limit / length
            return CGVector(dx: velocity.dx * ratio, dy: velocity.dy * ratio)
        } else {
            return CGVector(dx: velocity.dx * 1.03, dy: velocity.dy * 1.03)
        }
    }
}

struct BoidNeighbour {
    let relativePosition: CGVector
    let distance: CGFloat
    let deviationFromHeading: CGFloat
    let boid: BoidNode
}
