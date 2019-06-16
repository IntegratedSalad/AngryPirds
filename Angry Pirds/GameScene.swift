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
    
    let pirdTexture = SKTexture(imageNamed: "pird.png")
    var pirdsArr = Array<SKSpriteNode>()

    override func didMove(to view: SKView) {
        
        let circularPird = SKSpriteNode(texture: pirdTexture)
        circularPird.physicsBody = SKPhysicsBody(circleOfRadius: max(circularPird.size.width / 2,
                                                                     circularPird.size.height / 2))
        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: circularPird.size.width, height: circularPird.size.height))
        
        texturedPird.position = CGPoint(x: 0, y: 0)
        texturedPird.scale(to: CGSize(width: 130, height: 130))
        
        createSceneContents()
        
        scene?.addChild(texturedPird)

    }
    
    func createSceneContents() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        //self.pirdTexture.position = pos
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
}
