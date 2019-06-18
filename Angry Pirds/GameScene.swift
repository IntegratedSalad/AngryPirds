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
    let grassTexture = SKTexture(imageNamed: "grass.png")
    let pirdSize = 32
    let ballRadius = 45
    let choosedEntityToSelectBallRadius = 15
    
    var pird = SKSpriteNode()
    var ball = SKShapeNode()
    var selectBall = SKShapeNode()
    var choosedEntityToSelect = SKTexture()
    var touchPoint: CGPoint = CGPoint()
    
    let grassSize = (CGFloat(90), CGFloat(28))
    
    override func didMove(to view: SKView) {
        
        let circularPird = SKSpriteNode(texture: pirdTexture)
        circularPird.physicsBody = SKPhysicsBody(circleOfRadius: max(circularPird.size.width / 2,
                                                                     circularPird.size.height / 2))
        
        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: circularPird.size.width, height: circularPird.size.height))
        
        texturedPird.scale(to: CGSize(width: pirdSize, height: pirdSize))
        texturedPird.physicsBody?.isDynamic = false
        texturedPird.physicsBody?.allowsRotation = true
        texturedPird.physicsBody?.collisionBitMask = 0b0001
        //texturedPird.physicsBody?.mass = 8
        
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
        
        let constraintRange = SKRange(upperLimit: CGFloat(ballRadius))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)
        
        self.pird.constraints = [ constraintToBall ] // limit movement of the pird to the ball range
        
        createSceneContents()
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.selectBall)
        scene?.addChild(resetText)
        putGrass(scene: scene)
        //scene?.addChild(rectangularGrass)
    
    }
    
    func createSceneContents() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
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
            
            texturedBox.physicsBody?.isDynamic = true
            texturedBox.position = pos
            texturedBox.physicsBody?.categoryBitMask = 0b0001
            texturedBox.scale(to: CGSize(width: newBoxSize, height: newBoxSize))
            texturedBox.physicsBody?.mass = 0.06
            texturedBox.physicsBody?.restitution = 0
            texturedBox.physicsBody?.friction = 0.05
        
            scene?.addChild(texturedBox)
            
        } else
        {
            // drag pird
            if self.pird.contains(pos)
            {
                touchedPird = true
                touchPoint = pos
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
 
        // During the touch moved, limit the movement of pird to the circle around him.
        
        if touchedPird
        {
            
            
            self.pird.position = pos
            self.pird.physicsBody?.isDynamic = false
            
            // Lock the touch to the pird.
            // Make pird follow touch pos
        
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        //self.pird.position = self.ball.position
        
        if touchedPird {
            self.pird.physicsBody?.isDynamic = true
            self.pird.constraints = []
            touchedPird = false
            
            //let distance = sqrt(pow(self.pird.position.x - touchPoint.x , 2) + pow( self.pird.position.y - touchPoint.y, 2))
            
            let dt: CGFloat = 0.04
            let dx = touchPoint.x - self.pird.position.x // In that way, the direction is reversed
            let dy = touchPoint.y - self.pird.position.y
            //let dx = self.pird.position.x - touchPoint.x //  If we subtract touchPoint from pird position, the pird is going in direction of the                                                    finger
            //let dy = self.pird.position.y - touchPoint.y
            
            // Potrzebujemy wektor, który jest odwrócony
            
            self.pird.physicsBody?.applyForce(CGVector(dx: dx/dt, dy: dy/dt)) // works?????!!!!!
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
            // Velocity will be calculated as a distance from where the touch began to place where the touch ended - in opposite direction!
        }

    }
    
    func reset()
    {
        touchedPird = false
        scene?.removeAllChildren()
        self.pird.physicsBody?.isDynamic = false
        self.pird.position = self.ball.position
        let constraintRange = SKRange(upperLimit: CGFloat(45))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)
        
        self.pird.constraints = [ constraintToBall ]
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.resetText)
        scene?.addChild(self.selectBall)
        putGrass(scene: scene)
        
    }
    
    func putGrass (scene: SKScene?)
    {
        var posX: CGFloat = CGFloat(-288)
        for _ in 0...7
        {
            let rectangularGrass = SKSpriteNode(texture: grassTexture)
            rectangularGrass.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rectangularGrass.size.width, height:                                                                                                  rectangularGrass.size.height))
            rectangularGrass.physicsBody?.isDynamic = false
            
            rectangularGrass.scale(to: CGSize(width: grassSize.0, height: grassSize.1))
            rectangularGrass.position = CGPoint(x: posX, y: -186)
            posX += grassSize.0
            scene?.addChild(rectangularGrass)
            
        }
    }
    
}

//NEXT:
// Collisions V
// Restrain pird to circle V
// Change force and gravity. V
// Make movable screen
// Make camera that follows pird
// Make spurdos
// In the upper side there will be a pird to choose, number of them, score etc.
