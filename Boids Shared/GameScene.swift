//
//  GameScene.swift
//  Boids Shared
//
//  Created by Olivier Butler on 07/04/2021.
//

import SpriteKit

class GameScene: SKScene {

    typealias CGFloatRange = ClosedRange<CGFloat>
    
    var boidRadius: CGFloat = 1
    var boids: [BoidNodeProtocol] = []
    var xRange: CGFloatRange = 0...0
    var yRange: CGFloatRange = 0...0
    
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .highlightColor
        return scene
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let halfWidth = scene?.size.width ?? 0 / 3
        let halfHeight = scene?.size.height ?? 0 / 3
        self.xRange = (halfWidth * -1)...halfWidth
        self.yRange = (halfHeight * -1)...halfHeight
    }

    func makeBoid(at position: CGPoint, color: SKColor) {
        let boid = BoidNodeWeightedAverage(position: position)
        self.boids.append(boid)
        self.addChild(boid)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for boid in boids {
            boid.update(in: self.boids)
            boid.position = updatePositionToAvoidBounds(currentPositon: boid.position + boid.velocity)
        }
    }

    func updatePositionToAvoidBounds(currentPositon: CGPoint) -> CGPoint {
        switch(!xRange.contains(currentPositon.x), !yRange.contains(currentPositon.y)) {
        case (true, false):
            return CGPoint(x: (currentPositon.x * -1) * 0.2, y: currentPositon.y)
        case(false, true):
            return CGPoint(x: currentPositon.x, y: (currentPositon.y * -1) * 0.2)
        case (true, true):
            return CGPoint(x: (currentPositon.x * -1) * 0.2, y: (currentPositon.y * -1) * 0.2)
        case (false, false):
            return currentPositon
        }
    }
}

#if os(iOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.systemPink)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.black)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.orange)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.systemPink)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.black)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.orange)
    }

}
#endif

