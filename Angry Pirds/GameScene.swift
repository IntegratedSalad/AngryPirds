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
    let boxTexture = SKTexture(imageNamed: "crate.png")
    var boxesArr = Array<SKSpriteNode>() // Set will be better?
    var pird = SKSpriteNode()
    var ball = SKShapeNode()

    override func didMove(to view: SKView) {
        
        let pirdSize = 35
        
        let circularPird = SKSpriteNode(texture: pirdTexture)
        circularPird.physicsBody = SKPhysicsBody(circleOfRadius: max(circularPird.size.width / 2,
                                                                     circularPird.size.height / 2))
        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: circularPird.size.width, height: circularPird.size.height))
        
        texturedPird.position = CGPoint(x: 0, y: 0)
        texturedPird.scale(to: CGSize(width: pirdSize, height: pirdSize))
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: 45,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        
        let rangeBall = SKShapeNode(path: path)
        rangeBall.lineWidth = 0.3
        rangeBall.fillColor = .white
        rangeBall.glowWidth = 0.1
        
        rangeBall.position = CGPoint(x: -245, y: -100)
        
        self.pird = texturedPird
        self.ball = rangeBall
        
        createSceneContents()
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        

    }
    
    func createSceneContents() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        print(pos, "position of touch")
        print(self.pird.position, "position of pird")
        
        if !self.pird.contains(pos)
        {
        
            print(self.pird.position)
        
            let newBoxSize = 40
        
            let circularNewBox = SKSpriteNode(texture: boxTexture)
            circularNewBox.physicsBody = SKPhysicsBody(circleOfRadius: max(circularNewBox.size.width / 2,
                                                                           circularNewBox.size.height / 2))
        
            let texturedBox = SKSpriteNode(texture: boxTexture)
            texturedBox.physicsBody = SKPhysicsBody(texture: boxTexture,
                                                    size: CGSize(width: circularNewBox.size.width, height: circularNewBox.size.height))
            texturedBox.position = pos
            texturedBox.scale(to: CGSize(width: newBoxSize, height: newBoxSize))
        
            scene?.addChild(texturedBox)
        } else
        {
        print("dupa")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if touching pird - move pird and lock it so that it doesn't rotate
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        //self.pirdTexture.position = pos
        // During the touch moved, limit the movement of pird to the circle around him.
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
}
