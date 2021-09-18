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

// Boundary conditions
// - Can dissapear off the edge & reappaear on the next
// - Can bounce of the edge
// Usually the update rules will need to know about the boundary conditions to calculate accurate distance to the neibours, so it needs to be know in the update..

enum WorldProperties {
    static let matchingDistance: CGFloat = 40
    static let avoidanceDistance: CGFloat = 20
    static let centerOfMassDiatance: CGFloat = 50
}

class BoidNodeWeightedAverage: SKSpriteNode, BoidNodeProtocol {

    var velocity: CGPoint

    public init(position: CGPoint) {
        self.velocity = .zero
        super.init(
            texture: nil,
            color: SKColor.black,
            size: CGSize(width: 5, height: 5))
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(in flock: [BoidNodeProtocol]) {
        var forceAccumulatorMatching: CGPoint = .zero
        var weightAccumulatorMatching: Float = 0

        var forceAccumulatorAvoidance: CGPoint = .zero
        var weightAccumulatorAvoidance: Float = 0

        var forceAccumulatorCenterOfMass: CGPoint = .zero
        var weightAccumulatorCenterOfMass: Float = 0

        // loop and accumulate all the matching logic
        for neighbour in flock {
            let distanceToNeighbour: CGFloat = 3.0
            if distanceToNeighbour < WorldProperties.matchingDistance {
                // Add to the force accumulator
                // Incriment the weight accumulator
            }
        }

        // ditto for avoidance

        // ditto for force

        // Compute weighted average for 3 propeties

        // Equations of motion (update my velocity, then update my position).
            // We need to have some intertia for the boids, otherwise we can't use F = MA
            // We need to calulate the acceleration, which relies on the force (from the rules) and the mass (intertia) of the boid.
            // We will then calculate a new velocity which is old velocity + acceleration * time step
            // If you ignore the time step, you implicity set it to 1. It should be a constant.
    }
}
