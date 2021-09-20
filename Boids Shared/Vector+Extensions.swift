//
//  Vector+Extensions.swift
//  Boids
//
//  Created by Olivier Butler on 07/04/2021.
//

import Foundation

extension CGVector {
    var length: CGFloat {
        return ((self.dx * self.dx) + (self.dy * self.dy)).squareRoot()
    }
}

extension CGPoint {
    var length: CGFloat {
        return ((self.x * self.x) + (self.y * self.y)).squareRoot()
    }

    var normalisedVector: CGPoint {
        return .init(x: self.x / self.length, y: self.y / self.length)
    }

    static func distanceBetween(_ first: CGPoint, and second: CGPoint) -> CGFloat {
        CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)))
    }
}

func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
