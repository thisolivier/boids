//
//  BoidNodeWeightedAverage.swift
//  Boids
//
//  Created by Olivier Butler on 18/09/2021.
//

import Foundation

import SpriteKit

//class BoidNodeWeightedAverage: SKSpriteNode {
//
//    var neighbourVelocity: Float // you can calculate the velocity of the neighbour or you can directly calculate the expected force on you.
//    var neighbourVelocityWeight: Float
//    var neighbourHeading: Float
//    var neighbourHeadingWeight: Float
//}

class BoidNodeWeightedAverage: SKSpriteNode {

    var forceAccumulatorMatching: CGPoint = .zero
    var weightAccumulatorMatching: Float = 0

    var forceAccumulatorAvoidance: CGPoint = .zero
    var weightAccumulatorAvoidance: Float = 0

    var forceAccumulatorCenterOfMass: CGPoint = .zero
    var weightAccumulatorCenterOfMass: Float = 0

    var positionOfBoid: CGPoint
    var velocity: CGPoint

    public init(position: CGPoint) {
        self.positionOfBoid = position
        self.velocity = .zero
        super.init(
            texture: nil,
            color: SKColor.black,
            size: CGSize(width: 5, height: 5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
