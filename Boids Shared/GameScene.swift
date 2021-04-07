//
//  GameScene.swift
//  Boids Shared
//
//  Created by Olivier Butler on 07/04/2021.
//

import SpriteKit

class GameScene: SKScene {
    
    var boidRadius: CGFloat = 1
    var boids: [BoidNode] = []
    
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .highlightColor
        return scene
    }
    
    func setUpScene() {
        boidRadius = (self.size.width + self.size.height) * 0.001
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeBoid(at position: CGPoint, color: SKColor) {
        let boid = BoidNode(
            radius: self.boidRadius,
            gameSize: self.scene?.size ?? .zero)
        boid.setupNode(
            color: color,
            position: position,
            heading: CGVector(dx: CGFloat.random(in: -5..<5), dy: CGFloat.random(in: -5..<5)))
        self.boids.append(boid)
        self.addChild(boid)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for boid in boids { boid.move(in: self.boids) }
    }
}

#if os(iOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeBoid(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeBoid(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

