//
//  GameScene.swift
//  Angry Pirds
//
//  Created by Buppo on 15/06/2019.
//  Copyright © 2019 Buppo. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Entity
{
    let id = UUID()
    let nameOf: String
    let textureAlive: SKTexture
    let textureDead: SKTexture
    let textureInUse: SKTexture
    let width: CGFloat
    let height: CGFloat
    let physicsBodyType: String
    
    var mass: CGFloat
    var restitution: CGFloat
    var friction: CGFloat
    var angularDamping: CGFloat
    
}


class GameScene: SKScene {
    
    let pirdTexture = SKTexture(imageNamed: "pird.png")

    let resetText = SKLabelNode(fontNamed: "Courier")
    let deadSpurdoTexture = SKTexture(imageNamed: "dead spurdo.png")
    let grassTexture = SKTexture(imageNamed: "grass.png")

    let pirdSize = 32
    let ballRadius = 45
    let choosedEntityToSelectBallPositionX = -300
    let choosedEntityToSelectBallPositionY = 150
    let choosedEntityToSelectBallRadius = 15
    let cameraNode = SKCameraNode()
    
    var choiceEntities: [Entity] = [
        Entity(nameOf: "crate",
               textureAlive: SKTexture(imageNamed: "crate"),
               textureDead: SKTexture(imageNamed: "crate"),
               textureInUse: SKTexture(imageNamed: "crate"),
               width: 33,
               height: 33,
               physicsBodyType: "rectangular",
               mass: 0.005,
               restitution: 0,
               friction: 0.6,
               angularDamping: 1),
        Entity(nameOf: "spurdo",
               textureAlive: SKTexture(imageNamed: "spurdo"),
               textureDead: SKTexture(imageNamed: "spurdo"),
               textureInUse: SKTexture(imageNamed: "spurdo"),
               width: 21,
               height: 15,
               physicsBodyType: "circular",
               mass: 0.03,
               restitution: 0,
               friction: 0.4,
               angularDamping: 0.15)
    ]
    
    fileprivate lazy var currentEntity = self.choiceEntities[0]
    
    var choosedEntityToSelectBall = SKShapeNode()
    var pird = SKSpriteNode()
    var ball = SKShapeNode()
    var selectBall = SKShapeNode()
    var entityToSelectIcon = SKSpriteNode()
    var touchPoint: CGPoint = CGPoint()
    let grassSize = (CGFloat(90), CGFloat(28))

    override func didMove(to view: SKView) {
        
        //let circularPird = SKSpriteNode(texture: pirdTexture)
        //circularPird.physicsBody = SKPhysicsBody(circleOfRadius: max(circularPird.size.width / 2,
        //                                                            circularPird.size.height / 2))
        
        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: texturedPird.size.width, height: texturedPird.size.height))
        
        texturedPird.scale(to: CGSize(width: pirdSize, height: pirdSize))
        texturedPird.physicsBody?.isDynamic = false
        texturedPird.physicsBody?.allowsRotation = true
        texturedPird.physicsBody?.collisionBitMask = 0b0001
        texturedPird.physicsBody?.restitution = 0.25
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
        
        self.choosedEntityToSelectBall = SKShapeNode(path: secondPath)
        self.choosedEntityToSelectBall.lineWidth = 0.3
        self.choosedEntityToSelectBall.fillColor = .white
        self.choosedEntityToSelectBall.strokeColor = .orange
        self.choosedEntityToSelectBall.glowWidth = 1

        self.choosedEntityToSelectBall.position = CGPoint(x: self.choosedEntityToSelectBallPositionX, y: self.choosedEntityToSelectBallPositionY)

        texturedPird.position = CGPoint(x: rangeBallPositionX, y: rangeBallPositionY)

        resetText.text = "Reset"
        resetText.fontSize = 14
        resetText.fontColor = SKColor.white
        // 310, 175

        self.pird = texturedPird
        self.pird.name = "pird"
        self.ball = rangeBall
        self.selectBall = choosedEntityToSelectBall

        let constraintRange = SKRange(upperLimit: CGFloat(ballRadius))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)

        self.pird.constraints = [ constraintToBall ] // limit movement of the pird to the ball range

        cameraNode.position = CGPoint(x: 0, y: 0)
        
        createSceneContents()
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.entityToSelectIcon)
        scene?.addChild(selectBall)
        scene?.addChild(resetText)
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
        putGrass(scene: scene)
        
        self.showCurrentChoice()

        //scene?.addChild(rectangularGrass)
    
    }
    
    func createSceneContents() {
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    var touchedPird: Bool = false
    var choosingActive: Bool = false
    var touchedIcon: Bool = false
    var switchCounter: Int = 0
    
    private func addNewObject(atPoint pos: CGPoint) {
        
        let currentEntity = self.currentEntity
        
        let texture = currentEntity.textureInUse
        let newObject = SKSpriteNode(texture: texture)
        
        if currentEntity.physicsBodyType == "circular"
        {

            newObject.physicsBody = SKPhysicsBody(circleOfRadius: max(newObject.size.width / 2, newObject.size.height / 2))
            
        } else { // be it texture physicsBody type
            newObject.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: newObject.size.width,
                                                                                 height: newObject.size.height))
        }
        
        newObject.physicsBody?.isDynamic = true
        newObject.position = pos
        newObject.physicsBody?.categoryBitMask = 0b0001
        newObject.scale(to: CGSize(width: currentEntity.width, height: currentEntity.height))
        newObject.physicsBody?.mass = currentEntity.mass
        newObject.physicsBody?.restitution = currentEntity.restitution
        newObject.physicsBody?.friction = currentEntity.friction
        newObject.physicsBody?.angularDamping = currentEntity.angularDamping
        
        newObject.name = currentEntity.nameOf
        scene?.addChild(newObject)
    }
    
    private func showCurrentChoice() {
        let entity = self.currentEntity
        self.choosedEntityToSelectBall.removeAllChildren()
        
        let entityNode = SKSpriteNode(texture: entity.textureInUse)
        let ballSize = self.choosedEntityToSelectBall.frame.size
        entityNode.size = CGSize(width: ballSize.width/CGFloat(2.0), height: ballSize.height/CGFloat(2.0))
        self.choosedEntityToSelectBall.addChild(entityNode)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if self.choosedEntityToSelectBall.contains(pos)
        {
            self.touchedIcon.toggle()
        }
        
        if self.touchedIcon == true
        {
            self.showEntitiesToSelect()
        } else {
            self.hideEntitiesToSelect()
        }
        
        let nodes = self.nodes(at: pos)
        
        for node in nodes {
            guard let nodeName = node.name else { // only let nodeName, when touching on selection sprites.
                continue
            }
            
            for entity in self.choiceEntities {
                if entity.id.uuidString == nodeName { // if touched entity has name
                    self.currentEntity = entity
                    
                    self.showCurrentChoice()
                    
                    self.touchedIcon = false
                    self.hideEntitiesToSelect()
                }
            }
        }
        
        if self.pird.contains(pos) == false && pos.x > -180 && self.pirdFlew == false
        {
            self.addNewObject(atPoint: pos)
        } else {
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
        
        if !pirdFlew
        {
            if touchedPird
            {
            
                self.pird.position = pos
                self.pird.physicsBody?.isDynamic = false
            
            // Lock the touch to the pird.
            // Make pird follow touch pos
        
            }
        } else {
            reset()
        }
    }
    
    var pirdFlew: Bool = false
    func touchUp(atPoint pos : CGPoint) {
        //self.pird.position = self.ball.position
        
        if touchedPird && !pirdFlew {
            self.pird.physicsBody?.isDynamic = true
            self.pird.constraints = []
            //touchedPird = false
            
            //let distance = sqrt(pow(self.pird.position.x - touchPoint.x , 2) + pow( self.pird.position.y - touchPoint.y, 2))
            
            let dt: CGFloat = 0.04
            let dx = touchPoint.x - self.pird.position.x // In that way, the direction is reversed
            let dy = touchPoint.y - self.pird.position.y
            //let dx = self.pird.position.x - touchPoint.x //  If we subtract touchPoint from pird position, the pird is going in direction of the                                                    finger
            //let dy = self.pird.position.y - touchPoint.y
            
            // Potrzebujemy wektor, który jest odwrócony
            
            //self.pird.physicsBody?.applyForce(CGVector(dx: dx/dt, dy: dy/dt)) // works?????!!!!!
            self.pird.physicsBody?.velocity = CGVector(dx: dx/dt, dy: dy/dt)
            pirdFlew = true
            
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
        
        if self.pird.position.x > 280
        {
            scene?.camera?.position.x = self.pird.position.x
            
        }
        // if it is resting for more than 2 seconds, reset
        resetText.position = CGPoint(x: scene!.camera!.position.x + 310, y: 175)
        choosedEntityToSelectBall.position = CGPoint(x: scene!.camera!.position.x + CGFloat(choosedEntityToSelectBallPositionX), y:scene!.camera!.position.y + CGFloat(choosedEntityToSelectBallPositionY))


    }
    
    func reset()
    {
        touchedPird = false
        pirdFlew = false
        scene?.removeAllChildren()
        self.pird.physicsBody?.isDynamic = false
        self.pird.position = self.ball.position
        let constraintRange = SKRange(upperLimit: CGFloat(45))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)
        
        self.pird.constraints = [ constraintToBall ]
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.resetText)
        scene?.addChild(self.entityToSelectIcon)
        scene?.addChild(choosedEntityToSelectBall)
        scene?.addChild(cameraNode)
        cameraNode.position = CGPoint(x: 0, y: 0)
        putGrass(scene: scene)
        
    }
    
    func putGrass (scene: SKScene?)
    {
        var posX: CGFloat = CGFloat(-288)
        for _ in 0...30
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
    
    let sizeOf: Int = 20
    var menuToSelect: SKNode?
    func hideEntitiesToSelect() {
        self.menuToSelect?.removeFromParent()
        self.menuToSelect = nil
    }
    
    func showEntitiesToSelect()
    {
        self.menuToSelect?.removeFromParent()
        self.menuToSelect = SKNode()
        
        var xPos = self.choosedEntityToSelectBallPositionX + 40
        for entity in self.choiceEntities
        {
            let path = CGMutablePath()
            path.addArc(center: CGPoint.zero,
                        radius: CGFloat(choosedEntityToSelectBallRadius),
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
            let ball = SKShapeNode(path: path)
            ball.lineWidth = 0.3
            ball.fillColor = .white
            ball.glowWidth = 0.1
            ball.position = CGPoint(x: xPos, y: choosedEntityToSelectBallPositionY)
           
            let texture = entity.textureInUse
            
            let iconToSelect = SKSpriteNode(texture: texture)
            iconToSelect.position = CGPoint(x: xPos, y: choosedEntityToSelectBallPositionY)
            iconToSelect.scale(to: CGSize(width: sizeOf, height: sizeOf))
            iconToSelect.name = entity.id.uuidString
            xPos += 40
            
            let sprite = SKNode()
            sprite.addChild(ball)
            sprite.addChild(iconToSelect)
            
            self.menuToSelect?.addChild(sprite)
        }

        if let menu = self.menuToSelect {
            self.addChild(menu)
        }
    }

    func didBegin(_ contact: SKPhysicsContact)
    {
        print(contact.bodyA.node!.name!)
    }
    
}

//NEXT:
// Collisions V
// Restrain pird to circle V
// Make movable screen if the pird goes beyond right edge. V
// Make camera that follows pird V
// Make spurdos - menu from left to choose box or spurdo to spawn V <- later it will be used to choose different pirds.
// Change the physcics shape of spurdo's body V
// Make spurdos killable - must learn about SKPhysicsContactDelegate and how to assign it.
// Add planks
// Change properties of the bodies.
// Make moving controls in the right lower corner - "joystick" to move screen
// If player moves joystick, measure the time after he leaves it - 3 seconds and camera returns to follow pird.
// Make resetting boxes optional
// In the upper side there will be a pird to choose, number of them, score etc.
// Make different types of pirds - exploding ones, the ones that divide into three mid-air, heavier ones.
// Make menu.

// 5/14
