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
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .highlightColor
        return scene
    }
    
    func setUpScene() {
        // Create shape node to use during generative interactions
        boidRadius = (self.size.width + self.size.height) * 0.001
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeBoid(at position: CGPoint, color: SKColor) {
        
        let boid = BoidNode(radius: self.boidRadius)
        boid.setupNode(
            color: color,
            position: position,
            heading: CGVector(dx: CGFloat.random(in: -10..<10), dy: CGFloat.random(in: -10..<10)))
        self.boids.append(boid)
        self.addChild(boid)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for boid in boids { boid.move() }
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

