//
//  RelativePositionsLibrary.swift
//  Boids
//
//  Created by Olivier Butler on 07/04/2021.
//

import SceneKit

enum RelativePositions {
    
    /// Can only cope with positive numbers, FIX THIS
    static func angleOffset(heading: CGVector, alien: CGVector) -> CGFloat {
        let headingAngle = atan2(heading.dx, heading.dy)
        let alienAngle = atan2(alien.dx, alien.dy)
        return (headingAngle - alienAngle).truncatingRemainder(dividingBy: CGFloat.pi)
    }
}

