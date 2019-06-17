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
    let resetText = SKLabelNode(fontNamed: "Courier")
    let pirdSize = 32
    let ballRadius = 45
    let choosedEntityToSelectBallRadius = 15
    
    var boxesArr = Array<SKSpriteNode>() // Set will be better?
    var pird = SKSpriteNode()
    var ball = SKShapeNode()
    var selectBall = SKShapeNode()
    var choosedEntityToSelect = SKTexture()
    var touchPoint: CGPoint = CGPoint()
    

    override func didMove(to view: SKView) {
        
        let circularPird = SKSpriteNode(texture: pirdTexture)
        circularPird.physicsBody = SKPhysicsBody(circleOfRadius: max(circularPird.size.width / 2,
                                                                     circularPird.size.height / 2))
        
        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: circularPird.size.width, height: circularPird.size.height))
        
        texturedPird.scale(to: CGSize(width: pirdSize, height: pirdSize))
        texturedPird.physicsBody?.isDynamic = false
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: CGFloat(ballRadius),
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        
        let rangeBall = SKShapeNode(path: path)
        rangeBall.lineWidth = 0.3
        rangeBall.fillColor = .white
        rangeBall.glowWidth = 0.1
        
        let rangeBallPositionX = -245
        let rangeBallPositionY = -100
        
        rangeBall.position = CGPoint(x: rangeBallPositionX, y: rangeBallPositionY)
        
        let secondPath = CGMutablePath()
        secondPath.addArc(center: CGPoint.zero,
                          radius: CGFloat(choosedEntityToSelectBallRadius),
                          startAngle: 0,
                          endAngle: CGFloat.pi * 2,
                          clockwise: true)
        
        
        let choosedEntityToSelectBall = SKShapeNode(path: secondPath)
        choosedEntityToSelectBall.lineWidth = 0.3
        choosedEntityToSelectBall.fillColor = .white
        choosedEntityToSelectBall.glowWidth = 0.1
        
        let choosedEntityToSelectBallPositionX = -300
        let choosedEntityToSelectBallPositionY = 150
        
        choosedEntityToSelectBall.position = CGPoint(x: choosedEntityToSelectBallPositionX, y: choosedEntityToSelectBallPositionY)
        
        texturedPird.position = CGPoint(x: rangeBallPositionX, y: rangeBallPositionY)
        
        choosedEntityToSelect = boxTexture
        
        resetText.text = "Reset"
        resetText.fontSize = 14
        resetText.fontColor = SKColor.white
        resetText.position = CGPoint(x: 310, y: 175)
        
        self.pird = texturedPird
        self.ball = rangeBall
        self.selectBall = choosedEntityToSelectBall
        
        createSceneContents()
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(resetText)
        scene?.addChild(self.selectBall)
    
    }
    
    func createSceneContents() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    var touchedPird: Bool = false
    func touchDown(atPoint pos : CGPoint) {
        
        if !self.pird.contains(pos) && pos.x > -180
        {
        
            let newBoxSize = 37
        
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
            // drag pird
            if self.pird.contains(pos)
            {
                touchedPird = true
                self.pird.physicsBody?.isDynamic = false
                
            }
        
        }
        
        if self.resetText.contains(pos)
        {
            reset()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if touching pird - move pird and lock it so that it doesn't rotate
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        //let range = SKRange(value: 0, variance: CGFloat(ballRadius))
        
        // During the touch moved, limit the movement of pird to the circle around him.
        
        if touchedPird
        {
            
            self.pird.position = pos
            touchPoint = pos
            self.pird.physicsBody?.isDynamic = false
            
            // Lock the touch to the pird.
            // Make pird follow touch pos
        
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //self.pird.position = self.ball.position
        
        if touchedPird{
            self.pird.physicsBody?.isDynamic = true
            touchedPird = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if touchedPird
        {
            
        }

    }
    
    func reset()
    {
        touchedPird = false
        scene?.removeAllChildren()
        self.pird.physicsBody?.isDynamic = false
        self.pird.position = self.ball.position
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.resetText)
        scene?.addChild(self.selectBall)
        
    }
    
}
