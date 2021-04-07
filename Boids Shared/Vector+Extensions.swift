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
