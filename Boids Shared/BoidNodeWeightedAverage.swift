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
    static let centerOfMassDiatance: CGFloat = 30
    static let boidInertia: CGFloat = 2
    static let speedLimit: CGFloat = 6
}

class BoidNodeWeightedAverage: SKSpriteNode, BoidNodeProtocol {

    var velocity: CGPoint

    public init(position: CGPoint) {
        self.velocity = .init(x: CGFloat.random(in: -5...5), y: CGFloat.random(in: -5...5))
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
        var weightAccumulatorMatching: CGFloat = 1

        var forceAccumulatorAvoidance: CGPoint = .zero
        var weightAccumulatorAvoidance: CGFloat = 1

        var forceAccumulatorCenterOfMass: CGPoint = .zero
        var weightAccumulatorCenterOfMass: CGFloat = 1

        // loop and accumulate all the matching logic
        for neighbour in flock {
            guard neighbour != self else { break }
            let distanceToNeighbour: CGFloat = CGPoint.distanceBetween(
                self.position,
                and: neighbour.position)
            if distanceToNeighbour < WorldProperties.matchingDistance {
                forceAccumulatorMatching = .init(
                    x: forceAccumulatorMatching.x + neighbour.velocity.normalisedVector.x,
                    y: forceAccumulatorMatching.y + neighbour.velocity.normalisedVector.y)
                weightAccumulatorMatching += 1
            }

            // ditto for avoidance
            // avoidance needs to be wighted based on how close they are
            if distanceToNeighbour < WorldProperties.avoidanceDistance {
                forceAccumulatorAvoidance = .init(
                    x: forceAccumulatorAvoidance.x + neighbour.velocity.normalisedVector.x,
                    y: forceAccumulatorAvoidance.y + neighbour.velocity.normalisedVector.y)
                weightAccumulatorAvoidance += 4
            }

            // ditto for force
            if distanceToNeighbour < WorldProperties.centerOfMassDiatance {
                let relativeHeading = CGPoint(
                    x: neighbour.position.x - position.x,
                    y: neighbour.position.y - position.y).normalisedVector
                forceAccumulatorCenterOfMass = .init(
                    x: forceAccumulatorCenterOfMass.x + relativeHeading.x,
                    y: forceAccumulatorCenterOfMass.y + relativeHeading.y)
                weightAccumulatorCenterOfMass += 1
            }
        }

        // Compute weighted average for 3 propeties
        let combinedForce = (forceAccumulatorMatching * weightAccumulatorMatching) + (forceAccumulatorCenterOfMass * weightAccumulatorCenterOfMass) + (forceAccumulatorAvoidance * weightAccumulatorAvoidance * -1)
        let combinedWeights = (weightAccumulatorMatching + weightAccumulatorAvoidance + weightAccumulatorCenterOfMass)
        let weightedAverage = combinedForce / combinedWeights

        // Equations of motion (update my velocity, then update my position).
            // We need to have some intertia for the boids, otherwise we can't use F = MA (or A = F/M)
            // We need to calulate the acceleration, which relies on the force (from the rules) and the mass (intertia) of the boid.
        let acceleration = weightedAverage / WorldProperties.boidInertia
        // velocity = velocity + acceleration
        velocity = Self.applySpeedLimit(to: velocity + acceleration, limit: WorldProperties.speedLimit)
            // We will then calculate a new velocity which is old velocity + (acceleration * time step)
            // If you ignore the time step, you implicity set it to 1. It should be a constant.
    }

    static func applySpeedLimit(to velocity: CGPoint, limit: CGFloat) -> CGPoint {
        let length = velocity.length
        if length > limit {
            let ratio = limit / length
            return CGPoint(x: velocity.x * ratio, y: velocity.y * ratio)
        } else {
            return velocity
        }
    }
}
