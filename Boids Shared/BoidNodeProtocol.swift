//
//  BoidNodeProtocol.swift
//  Boids
//
//  Created by Olivier Butler on 18/09/2021.
//

import SpriteKit

protocol BoidNodeProtocol: SKSpriteNode {
    var velocity: CGPoint { get }
    
    func update(in flock: [BoidNodeProtocol])
}

// Three core models for the world
//
// Particle Dynamics
// Particle Interaction
// Topology

// SIMD - Single Instruction Multiple Data (GPU and CPU parallelism)
// Take a sequential program and run it lots of times simaltaniously with different data input.

// SIMD on the CPU will execute multiple operations as a single operation
// This can be done automatically, but only if the conditions are right.
// With a class based object, when you want to perform an operation on any of the objects, it's going to get loaded into the register through the cache. The cache will be will be used inefficiently, since there's more in the boid than just the values you need to manipulate.

// SIMD insturctions work on vectors
// You have, for example a Vec4, allowing us to deal with 4 simaltanious operations
// If you want to multiple X Y and Z, you need 3 Vec4 objects easch holding the x y or z cooridnated for 3 underlying boids.
// In order to turn some (boid) object into vectors, you need them to be contiguous in memeory.

// When you do CUDA and OpenGL
// You have ways to attach shaders to the CUDA model
// Your update rule and your display program uses the same data.
