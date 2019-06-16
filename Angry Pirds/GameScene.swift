//
//  GameScene.swift
//  Angry Pirds
//
//  Created by Buppo on 15/06/2019.
//  Copyright © 2019 Buppo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let pirdTexture = SKSpriteNode(imageNamed: "pird.png")

    override func didMove(to view: SKView) {
        self.pirdTexture.scale(to: CGSize(width: 130, height: 130))
        self.addChild(self.pirdTexture)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        self.pirdTexture.position = pos
    }
    
//    func touchUp(atPoint pos : CGPoint) {
//
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
}
