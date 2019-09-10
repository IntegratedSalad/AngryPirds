//
//  GameScene.swift
//  Angry Pirds
//
//  Created by Buppo on 15/06/2019.
//  Copyright © 2019 Buppo. All rights reserved.
//

import SpriteKit

enum GameMode
{
    case menu
    case play
    case create
    case won
}

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

class GameScene: SKScene, SKPhysicsContactDelegate { // protocols
    
    let pirdSize = 32
    let ballRadius = 45
    let choosedEntityToSelectBallPositionX = -300
    let choosedEntityToSelectBallPositionY = 150
    let changeCameraFollowPirdBallX = -300
    let changeCameraFollowPirdBallY = 100
    
    var spurdos: Int = 0
    
    let choosedEntityToSelectBallRadius = 15
    let cameraNode = SKCameraNode()
    let movingArrowsSize = 110
    
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
               angularDamping: 0.15),
        Entity(nameOf: "plank",
               textureAlive: SKTexture(imageNamed: "plank"),
               textureDead: SKTexture(imageNamed: "plank"),
               textureInUse: SKTexture(imageNamed: "plank"),
               width: 66,
               height: 8,
               physicsBodyType: "rectangular",
               mass: 0.005,
               restitution: 0,
               friction: 0.6,
               angularDamping: 1),
    ]
    
    let namesOfEntities: [String] = ["plank", "crate", "spurdo"]
    
    fileprivate lazy var currentEntity = self.choiceEntities[0]
    
    let grassSize = (CGFloat(90), CGFloat(28))
    let rangeBallPositionX = -245
    let rangeBallPositionY = -100
    var choosedEntityToSelectBall = SKShapeNode()
    var changeCameraFollowPirdBall = SKShapeNode()
    var physicsButtonBall = SKShapeNode()
    var resetPirdButtionBall = SKShapeNode()
    var modeBall = SKShapeNode()
    var pird = SKSpriteNode()
    var ball = SKShapeNode()
    var selectBall = SKShapeNode()
    var entityToSelectIcon = SKSpriteNode()
    var touchPoint: CGPoint = CGPoint()
    var gameState = GameMode.create
    var changeCameraFollowPirdSprite = SKSpriteNode()
    var gameModeSprite = SKSpriteNode()
    var movingArrowsSprite = SKSpriteNode()
    
    let pirdTexture = SKTexture(imageNamed: "pird.png")
    let cameraFollowTexture = SKTexture(imageNamed: "followpird.png")
    let deadSpurdoTexture = SKTexture(imageNamed: "dead spurdo.png")
    let grassTexture = SKTexture(imageNamed: "grass.png")
    let resetPirdButtonTexture = SKTexture(imageNamed: "resetpird.png")
    let playIconTexture = SKTexture(imageNamed: "playicon.png")
    let createIconTexture = SKTexture(imageNamed: "createicon.png")
    var movingArrows = SKTexture(imageNamed: "arrows.png")
    
    let resetText = SKLabelNode(fontNamed: "Courier")
    
    var playScene = SKNode()
    var createScene = SKNode()

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self // assigning contact delegate
        
        
        /* INIT */

        let texturedPird = SKSpriteNode(texture: self.pirdTexture)
        texturedPird.physicsBody = SKPhysicsBody(texture: self.pirdTexture,
                                                 size: CGSize(width: texturedPird.size.width, height: texturedPird.size.height))
        
        texturedPird.scale(to: CGSize(width: pirdSize, height: pirdSize))
        texturedPird.physicsBody?.isDynamic = false
        texturedPird.physicsBody?.allowsRotation = true
        texturedPird.physicsBody?.contactTestBitMask = 0b0001
        texturedPird.physicsBody?.restitution = 0.25
        texturedPird.position = CGPoint(x: rangeBallPositionX, y: rangeBallPositionY)
        //texturedPird.physicsBody?.categoryBitMask = 0b0001
        //texturedPird.physicsBody?.mass = 8
        
        let rangeBall = createBall(radiusOf: CGFloat(ballRadius), x: rangeBallPositionX, y: rangeBallPositionY, color: .white, strokeColor: nil)
        
        rangeBall.position = CGPoint(x: rangeBallPositionX, y: rangeBallPositionY)
        
        /* Change */
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
        /* This */

        self.changeCameraFollowPirdBall = createBall(radiusOf: CGFloat(choosedEntityToSelectBallRadius), x: changeCameraFollowPirdBallX, y: changeCameraFollowPirdBallY, color: .white, strokeColor: .orange)
        self.changeCameraFollowPirdBall.glowWidth = 1
        self.changeCameraFollowPirdSprite = SKSpriteNode(texture: cameraFollowTexture)
        
        self.changeCameraFollowPirdSprite.position.x = CGFloat(changeCameraFollowPirdBallX - 1)
        self.changeCameraFollowPirdSprite.position.y = CGFloat(changeCameraFollowPirdBallY - 2)
        
        let changeCameraFollowPirdSpriteRatio = getRatio(sizeOf: Float(20), width: Float(changeCameraFollowPirdSprite.size.width), height: Float(changeCameraFollowPirdSprite.size.height))
        
        self.changeCameraFollowPirdSprite.scale(to:
            CGSize(width: (self.changeCameraFollowPirdSprite.size.width + CGFloat(10)) * CGFloat(changeCameraFollowPirdSpriteRatio),
                   height: (self.changeCameraFollowPirdSprite.size.height + CGFloat(10)) * CGFloat(changeCameraFollowPirdSpriteRatio)))

        self.modeBall = createBall(radiusOf: CGFloat(choosedEntityToSelectBallRadius),
                                   x: Int(self.choosedEntityToSelectBallPositionX) + 602,
                                   y: self.choosedEntityToSelectBallPositionY, color: .white, strokeColor: nil)
        
        self.gameModeSprite = SKSpriteNode(texture: playIconTexture)
        self.gameModeSprite.position.x = modeBall.position.x + 1
        self.gameModeSprite.position.y = modeBall.position.y
        
        let gameModeSpriteRatio = getRatio(sizeOf: Float(20), width: Float(gameModeSprite.size.width), height: Float(gameModeSprite.size.height))
        gameModeSprite.scale(to: CGSize(width: self.gameModeSprite.size.width * CGFloat(gameModeSpriteRatio),
                                        height: self.gameModeSprite.size.height * CGFloat(gameModeSpriteRatio)))
        
        
        
        self.resetText.text = "Reset"
        self.resetText.fontSize = 14
        self.resetText.fontColor = SKColor.white
        
        self.movingArrows.filteringMode = .nearest
        self.movingArrowsSprite = SKSpriteNode(texture: self.movingArrows)
        self.movingArrowsSprite.scale(to: CGSize(width: self.movingArrowsSize, height: self.movingArrowsSize))
        self.movingArrowsSprite.zPosition = 1

        self.pird = texturedPird
        self.pird.name = "pird"
        self.ball = rangeBall
        self.selectBall = choosedEntityToSelectBall

        let constraintRange = SKRange(upperLimit: CGFloat(ballRadius))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)

        self.pird.constraints = [ constraintToBall ] // limit movement of the pird to the ball range

        cameraNode.position = CGPoint(x: 0, y: 0)
        
        self.selectBall.name = "button"
        self.resetText.name = "button"
        self.movingArrowsSprite.name = "button"
        self.changeCameraFollowPirdBall.name = "button"
        self.physicsButtonBall.name = "button"
        self.modeBall.name = "button"
        /* */
        
        /* Prepare different nodes as scenes - they will hold different things on screen. */
        
        /* Create Mode */
        self.createScene.addChild(self.selectBall)
        self.createScene.addChild(self.entityToSelectIcon)
        /* */
        
        
        /* Play Mode */
        self.playScene.addChild(self.changeCameraFollowPirdBall)
        self.playScene.addChild(self.changeCameraFollowPirdSprite)
        /* */
        
        createSceneContents()
        
        /* Objects that are always on screen */
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.cameraNode)
        scene?.addChild(self.modeBall)
        scene?.addChild(self.gameModeSprite)
        scene?.addChild(self.movingArrowsSprite)
        scene?.addChild(self.resetText) // debug
        scene?.camera = self.cameraNode
        putGrass(scene: scene)
        /* */
        
        self.createScene.name = "createSceneModeNode" // don't know if redundant - maybe just remove it from parent when changing modes
        scene?.addChild(self.createScene) // add current mode node.
        self.showCurrentChoice()
        
        
        /*
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.entityToSelectIcon)
        scene?.addChild(self.selectBall)
        scene?.addChild(self.resetText)
        scene?.addChild(self.cameraNode)
        scene?.addChild(self.movingArrowsSprite)
        scene?.addChild(self.changeCameraFollowPirdBall)
        scene?.addChild(self.changeCameraFollowPirdSprite)
        scene?.addChild(self.physicsButtonBall)
        scene?.addChild(self.physicsButtonSprite)
        scene?.addChild(self.modeBall)
        scene?.addChild(self.gameModeSprite)
        scene?.camera = self.cameraNode
        */
    

    }
    
    private func createSceneContents() {
        self.backgroundColor = UIColor(red: 0.106, green: 0.167, blue: 0.236, alpha: 1.0)
        self.scaleMode = .aspectFit
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
            newObject.physicsBody?.contactTestBitMask = 0b0001
            
        } else { // be it texture physicsBody type
            newObject.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: newObject.size.width,
                                                                                 height: newObject.size.height))
            newObject.physicsBody?.contactTestBitMask = 0b0001 >> 1
        }
        
        newObject.physicsBody?.isDynamic = false
        newObject.position = pos
        newObject.scale(to: CGSize(width: currentEntity.width, height: currentEntity.height))
        newObject.physicsBody?.mass = currentEntity.mass
        newObject.physicsBody?.restitution = currentEntity.restitution
        newObject.physicsBody?.friction = currentEntity.friction
        newObject.physicsBody?.angularDamping = currentEntity.angularDamping
        
        newObject.name = currentEntity.nameOf
        if newObject.name == "spurdo"
        {
            spurdos += 1
        }

        arrowControls = "object"
        objectAdded = newObject
        addedNewObject = true
        scene?.addChild(newObject)
    }
    
    private func showCurrentChoice() {
        let entity = self.currentEntity
        self.choosedEntityToSelectBall.removeAllChildren()
        
        let entityNode = SKSpriteNode(texture: entity.textureInUse)
        
        let ratio = getRatio(sizeOf: Float(sizeOf), width: Float(entityNode.size.width), height: Float(entityNode.size.height))
        
        entityNode.scale(to: CGSize(width: entityNode.size.width * CGFloat(ratio), height: entityNode.size.height * CGFloat(ratio)))
        self.choosedEntityToSelectBall.addChild(entityNode)
    }
    
    
    var touchedArrows: Bool = false
    var touchedButton: Bool = false
    var arrowControls: String = "view"
    var objectAdded: SKSpriteNode = SKSpriteNode()
    var addedNewObject: Bool = false
    var rotationBalls: [SKShapeNode] = []
    var objectAddingDone: Bool = false
    func touchDown(atPoint pos : CGPoint) {
        
        // check if touch is not in any of buttons positions.
        
        // array of positions
        
        if self.choosedEntityToSelectBall.contains(pos)
        {
            touchedButton = true
            self.touchedIcon.toggle()
        }
        
        
        if self.changeCameraFollowPirdBall.contains(pos)
        {
            touchedButton = true
            changeCameraFollow()
        }
        
        if modeBall.contains(pos)
        {
            touchedButton = true
            changeMode()
        }
        
        if self.resetText.contains(pos)
        {
            touchedButton = true
            reset()
        }
        
        if objectAdded.contains(pos) // we are done with placing object
        {
            addedNewObject = false
            objectAdded.physicsBody!.isDynamic = true
            objectAdded = SKSpriteNode()
            objectAddingDone = true
            self.ballsOfRotation!.removeFromParent()
            self.ballsOfRotation = nil
            self.rotationBalls = []
            self.shapeOfRotation = nil
            
        }

        // for ball in rotation balls
        
        if self.movingArrowsSprite.contains(pos)
        {
            let fingerX = pos.x
            let fingerY = pos.y
            let spriteX = self.movingArrowsSprite.position.x
            let spriteY = self.movingArrowsSprite.position.y
            if arrowControls == "view"
            {
                let (dir) = getCameraMovePos(touchPosX: fingerX, touchPosY: fingerY, spritePosX: spriteX, spritePosY: spriteY)
                moveCamera(cameraMovePos: dir)
            
            
            } else
            {
                let (dir) = getSpriteMovePos(touchPosX: fingerX, touchPosY: fingerY, arrowsSpritePosX: spriteX, arrowsSpritePosY: spriteY, spritePosX: objectAdded.position.x, SpritePosY: objectAdded.position.y)
                
                
                objectAdded.position = CGPoint(x: dir.0, y: dir.1)
            }
            
            
            touchedButton = true
            touchedArrows = true
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
        
        if !self.pird.contains(pos) && pos.x > -148 && !self.pirdFlew && !touchedButton
        {
            if gameState == .create && addedNewObject
            {
                
            }
            
            if gameState == .create && !addedNewObject && !objectAddingDone // doesn't make sense but works
            {
                self.addNewObject(atPoint: pos)
                createRotationCircles(obj: objectAdded)
                
            }
            
        } else {
            // drag pird
            if gameState == .play {
                if self.pird.contains(pos)
                {
                    touchedPird = true
                    touchPoint = pos
                    self.pird.physicsBody?.isDynamic = false

                }
            }
        }

        touchedButton = false
        objectAddingDone = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

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

            }
        } else {
            if !movingArrowsSprite.contains(pos) { reset() }
        }
        
        if movingArrowsSprite.contains(pos)
        {
            
            let fingerX = pos.x
            let fingerY = pos.y
            let spriteX = self.movingArrowsSprite.position.x
            let spriteY = self.movingArrowsSprite.position.y
            
            if arrowControls == "view"
            {
                let (dir) = getCameraMovePos(touchPosX: fingerX, touchPosY: fingerY, spritePosX: spriteX, spritePosY: spriteY)
                moveCamera(cameraMovePos: dir)
            
            } else
            {
                // constrain to camera view
                let (dir) = getSpriteMovePos(touchPosX: fingerX, touchPosY: fingerY, arrowsSpritePosX: spriteX, arrowsSpritePosY: spriteY, spritePosX: objectAdded.position.x, SpritePosY: objectAdded.position.y)
                
                
                objectAdded.position = CGPoint(x: dir.0, y: dir.1)
            }
        }
        
        if let shapeOfRotationOfObjectAdded = self.shapeOfRotation
        {
            /* Only the peripheries  */
            if shapeOfRotationOfObjectAdded.contains(pos)
            {
                rotateObjectAdded(circle: shapeOfRotationOfObjectAdded, obj: objectAdded, positionOfTouch: pos)
            }
        }
      
        
    }
    
    var pirdFlew: Bool = false
    func touchUp(atPoint pos : CGPoint) {

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
        
        if self.pird.position.x > 280 && !touchedArrows && cameraFollows
        {
            scene?.camera?.position.x = self.pird.position.x
            
        }

        if self.touchedIcon == true
        {
            self.showEntitiesToSelect()
        } else {
            self.hideEntitiesToSelect()
        }
        
        
        /* Camera must follow any text or 'static' shape we want to stay in the view. */
        self.resetText.position =  CGPoint(x: scene!.camera!.position.x + 310, y: scene!.camera!.position.y + 175)
        self.movingArrowsSprite.position = CGPoint(x: 250 + scene!.camera!.position.x, y: scene!.camera!.position.y - 100)
        choosedEntityToSelectBall.position = CGPoint(x: scene!.camera!.position.x + CGFloat(choosedEntityToSelectBallPositionX), y:scene!.camera!.position.y + CGFloat(choosedEntityToSelectBallPositionY))
        
        self.changeCameraFollowPirdBall.position = CGPoint(x: CGFloat(changeCameraFollowPirdBallX) + scene!.camera!.position.x,
                                                           y: CGFloat(changeCameraFollowPirdBallY) + scene!.camera!.position.y)
        self.changeCameraFollowPirdSprite.position = CGPoint(x: CGFloat(changeCameraFollowPirdBallX - 1) + scene!.camera!.position.x,
                                                           y: CGFloat(changeCameraFollowPirdBallY - 2) + scene!.camera!.position.y)
        
        self.modeBall.position = CGPoint(x: CGFloat(Int(self.choosedEntityToSelectBallPositionX) + 602) + scene!.camera!.position.x,
                                                  y: CGFloat(self.choosedEntityToSelectBallPositionY) + scene!.camera!.position.y)
        
        self.gameModeSprite.position = self.modeBall.position
        
        
        if gameState == .won
        {
            
            // reset camera pos
            scene!.removeAllChildren()
            let wonText = SKLabelNode(text: "Ebin XD :D")
            wonText.fontSize = 50
            wonText.fontColor = SKColor.red
            wonText.position = CGPoint(x: frame.midX, y: frame.midY)
            
            scene!.addChild(wonText)
            
            var speen = SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 1)
            speen =  SKAction.repeatForever(speen)
            wonText.run(speen)
            
        }

    }
    
    private func reset()
    {
        
        /* It would be better to contain all the bools in one array */
        
        /* Take into account mode of the game. */
        
        /* Angry Pirds[3537:1709793] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attemped to add a SKNode which already has a parent: <SKSpriteNode> name:'(null)' texture:['nil'] position:{0, 0} scale:{1.00, 1.00} size:{0, 0} anchor:{0.5, 0.5} rotation:0.00' */

        // offload here
        
        var tempArr: [SKSpriteNode?] = offloadEntities()
        
        scene?.removeAllChildren()
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.movingArrowsSprite)
        scene?.addChild(self.cameraNode)
        scene?.addChild(self.modeBall)
        scene?.addChild(self.gameModeSprite)
        scene?.addChild(self.resetText) // debug
        scene?.camera = self.cameraNode
        putGrass(scene: scene!)
        
        cameraNode.position = CGPoint(x: 0, y: 0)
        
        if gameState == .create
        {
            self.physicsButtonBall.glowWidth = 1
            self.createScene.name = "createSceneModeNode" // don't know if redundant - maybe just remove it from parent when changing modes
            scene?.addChild(self.createScene) // add current mode node.
            self.showCurrentChoice()
            touchedArrows = false
            addedNewObject = false
            objectAdded.physicsBody!.isDynamic = true
            objectAdded = SKSpriteNode()
            objectAddingDone = true
            self.ballsOfRotation!.removeFromParent()
            self.ballsOfRotation = nil
            self.rotationBalls = []
            self.shapeOfRotation = nil
        }
        
        if gameState == .play
        {
            self.changeCameraFollowPirdBall.glowWidth = 1
            pirdFlew = false
            touchedPird = false
            cameraFollows = true
            touchedArrows = false
            self.pird.physicsBody?.isDynamic = false
            self.pird.position = self.ball.position
            for node in tempArr
            {
                if let entity = node {
                    
                    entity.physicsBody!.isDynamic = true
                    scene?.addChild(entity)
                }
                
            }
            let constraintRange = SKRange(upperLimit: CGFloat(ballRadius))
            let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)
            
            self.pird.constraints = [ constraintToBall ] // limit movement of the pird to the ball range
            tempArr.removeAll()
            scene?.addChild(self.playScene)
        }
        
        /*
        touchedPird = false
        pirdFlew = false
        touchedArrows = false
        cameraFollows = true
        physicsStatus = true
        self.changeCameraFollowPirdBall.glowWidth = 1
        self.physicsButtonBall.glowWidth = 1
        scene?.removeAllChildren()
        self.pird.physicsBody?.isDynamic = false
        self.pird.position = self.ball.position
        let constraintRange = SKRange(upperLimit: CGFloat(45))
        let constraintToBall = SKConstraint.distance(constraintRange, to: self.ball.position)
        
        self.pird.constraints = [ constraintToBall ]
        */
        
        /*
        scene?.addChild(self.pird)
        scene?.addChild(self.ball)
        scene?.addChild(self.resetText)
        scene?.addChild(self.entityToSelectIcon)
        scene?.addChild(self.choosedEntityToSelectBall)
        scene?.addChild(self.cameraNode)
        scene?.addChild(self.movingArrowsSprite)
        scene?.addChild(self.changeCameraFollowPirdBall)
        scene?.addChild(self.changeCameraFollowPirdSprite)
        scene?.addChild(self.physicsButtonBall)
        scene?.addChild(self.physicsButtonSprite)
        scene?.addChild(self.modeBall)
        scene?.addChild(self.gameModeSprite)
        cameraNode.position = CGPoint(x: 0, y: 0)
        putGrass(scene: scene)
        */
        
        
        
    }
    
    private func putGrass (scene: SKScene?)
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
            rectangularGrass.name = "grass"
            scene?.addChild(rectangularGrass)
        }
    }
    
    let sizeOf: CGFloat = 20
    var menuToSelect: SKNode?
    private func hideEntitiesToSelect() {
        self.menuToSelect?.removeFromParent()
        self.menuToSelect = nil
    }
    
    private func showEntitiesToSelect()
    {
        self.menuToSelect?.removeFromParent()
        self.menuToSelect = SKNode()
        
        var xPos = CGFloat(self.choosedEntityToSelectBallPositionX) + CGFloat(40) + scene!.camera!.position.x
        let yPos = CGFloat(self.choosedEntityToSelectBallPositionY) + scene!.camera!.position.y
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
            ball.position = CGPoint(x: xPos, y: yPos)
           
            let texture = entity.textureInUse
            
            let iconToSelect = SKSpriteNode(texture: texture)
            iconToSelect.position = CGPoint(x: xPos, y: yPos)
            
            let aspectRatio = getRatio(sizeOf: Float(sizeOf), width: Float(entity.width), height: Float(entity.height))
        
            iconToSelect.scale(to: CGSize(width: entity.width * CGFloat(aspectRatio), height: entity.height * CGFloat(aspectRatio)))
            iconToSelect.name = entity.id.uuidString
            ball.name = entity.id.uuidString
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
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.node?.name == "pird" && secondBody.node?.name == "spurdo"
        {
            /* We delete old and make a new node */
            

            killSpurdo(spurdoNode: secondBody.node!, spurdoPhysBody: secondBody, spurdoPosAtContact: secondBody.node!.position)
            spurdos -= 1
        
            
        }
        
    }
 
    
    private func killSpurdo(spurdoNode: SKNode, spurdoPhysBody: SKPhysicsBody, spurdoPosAtContact: CGPoint)
    {
        let texture = SKTexture(imageNamed: "dead spurdo")
        let deadSpurdoSpriteNode = SKSpriteNode(texture: texture)
        deadSpurdoSpriteNode.name = "dead spurdo"
        
        deadSpurdoSpriteNode.position = spurdoPosAtContact
        deadSpurdoSpriteNode.scale(to: CGSize(width: choiceEntities[1].width, height: choiceEntities[1].height))
        deadSpurdoSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(choiceEntities[1].width / 2, choiceEntities[1].height / 2))
        deadSpurdoSpriteNode.physicsBody!.contactTestBitMask = 0b0001 >> 1
        
        deadSpurdoSpriteNode.physicsBody?.isDynamic = true
        
        spurdoNode.removeFromParent()
        scene?.addChild(deadSpurdoSpriteNode)
        
    }
    
    private func changeMode()
    {
        
        switch self.gameState
        {
        case .create:
            self.gameState = .play
            self.gameModeSprite.texture = self.createIconTexture
            // change buttons
        case .play:
            self.gameState = .create
            self.gameModeSprite.texture = self.playIconTexture
            // change buttons
        default:
            self.gameState = .create
        }
        initiateState()
    }
    
    private func getCameraMovePos(touchPosX: CGFloat, touchPosY: CGFloat, spritePosX: CGFloat, spritePosY: CGFloat)
        ->
        (CGFloat, CGFloat)
    {
        // constrain it to 0,0 so it doesn't move below or beyond scene far left.
        
        let dirX: CGFloat = touchPosX - spritePosX
        let dirY: CGFloat = touchPosY - spritePosY
        
        return (scene!.camera!.position.x + (dirX * 1.4), scene!.camera!.position.y + (dirY * 1.4))
    }
    
    private func getSpriteMovePos(touchPosX: CGFloat, touchPosY: CGFloat, arrowsSpritePosX: CGFloat, arrowsSpritePosY: CGFloat,
                                  spritePosX: CGFloat, SpritePosY: CGFloat)
        ->
        (CGFloat, CGFloat)
    {
        // constrain it to 0,0 so it doesn't move below or beyond scene far left.
        
        let dirX: CGFloat = touchPosX - arrowsSpritePosX
        let dirY: CGFloat = touchPosY - arrowsSpritePosY
        
        
        /* I will throw in moving of ballsOfRotation for the sake of it, but I know that's not a good practice */
        
        for ball in rotationBalls
        {
            ball.position.x += dirX * 0.3
            ball.position.y += dirY * 0.3
        }
        
        
        return (spritePosX + (dirX * 0.3), SpritePosY + (dirY * 0.3))
    }
    
    private func moveCamera(cameraMovePos: (CGFloat, CGFloat))
    {
        let smoothMove = SKAction.move(to: CGPoint(x: cameraMovePos.0, y: cameraMovePos.1), duration: 0.2)
        
        camera!.run(smoothMove)
    }
    
    private func createBall(radiusOf: CGFloat, x: Int, y: Int, color: UIColor, strokeColor: UIColor?)
        ->
        SKShapeNode
    {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: radiusOf,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        
        let ball = SKShapeNode(path: path)
        ball.lineWidth = 0.3
        ball.fillColor = color
        ball.glowWidth = 1
        
        if let sColor = strokeColor {
            ball.strokeColor = sColor
        }
        
        ball.position = CGPoint(x: x, y: y)
        
        return ball
    }
    
    private func getRatio(sizeOf: Float, width: Float, height: Float)
        ->
        Float
        
    {
        let aspectWidth:  Float = sizeOf / width
        let aspectHeight: Float = sizeOf / height
        return Float(min(aspectWidth, aspectHeight))
    }
    
    var cameraFollows: Bool = true
    private func changeCameraFollow()
    {
        cameraFollows.toggle()
        
        if cameraFollows
        {
            self.changeCameraFollowPirdBall.glowWidth = 1
            touchedArrows = false
        } else {
            self.changeCameraFollowPirdBall.glowWidth = 0
        }
    }
    
    private func initiateState()
    {
        if gameState == .create
        {
            self.playScene.removeFromParent() // deactivate things on screen
            scene?.addChild(self.createScene)
            self.pird.physicsBody?.isDynamic = false
            self.pird.position = self.ball.position
        }
        
        if gameState == .play
        {
            addedNewObject = false
            objectAdded.physicsBody!.isDynamic = true
            objectAddingDone = true
            self.ballsOfRotation!.removeFromParent()
            self.ballsOfRotation = nil
            self.rotationBalls = []
            self.shapeOfRotation = nil
            objectAdded = SKSpriteNode()
            if spurdos <= 0
            {
                gameState = .won
            }
            
            self.createScene.removeFromParent()
            self.pird.position = self.ball.position
            scene?.addChild(self.playScene)

        }
        
    }
    
    private func offloadEntities()
        -> [SKSpriteNode?]
    {
        var tempArr: [SKSpriteNode?] = []
        for node in scene!.children
        {
            if let nodeName = node.name {
                if namesOfEntities.contains(nodeName)
                {
                    let spriteNode: SKSpriteNode? = node as? SKSpriteNode // casting
                    tempArr.append(spriteNode) // offload
                }
            }
            
        }
        
        return tempArr
    }
    
    var ballsOfRotation: SKNode?
    var shapeOfRotation: SKShapeNode?
    let radiusOfBallsSurroundingObject: Double = 55
    private func createRotationCircles(obj: SKSpriteNode)
    {
        
        self.ballsOfRotation = SKNode()
        
        self.shapeOfRotation = SKShapeNode(circleOfRadius: CGFloat(radiusOfBallsSurroundingObject + 46.0))
        self.shapeOfRotation?.position = obj.position
        
        for _ in 0...36
        {
            let rotationBall = createBall(radiusOf: 2, x: Int(obj.position.x), y: Int(obj.position.y), color: .white, strokeColor: nil)
            rotationBalls.append(rotationBall)
            self.ballsOfRotation!.addChild(rotationBall)
        }
        if let ballsNode = self.ballsOfRotation
        {
            scene!.addChild(ballsNode)
        }
        
        let center = (Double(obj.position.x), Double(obj.position.y))
        var durationTime: Double = 0.6
        var angle: Double = 0
        
        for ball in rotationBalls
        {
            // animate them outwards - every next step will have the ball move faster, for better effect. (and grow faster, make 2 actions)
            
            let target = (center.0 + radiusOfBallsSurroundingObject * cos(angle * Double.pi / 180),
                          center.1 + radiusOfBallsSurroundingObject * sin(angle * Double.pi / 180))
            
            let animation = SKAction.move(to: CGPoint(x: target.0, y: target.1), duration: durationTime)
            durationTime -= 0.01
            
            ball.run(animation, completion: {ball.position.x = CGFloat(target.0); ball.position.y = CGFloat(target.1)}) // actually change to positions of balls
            angle += 10
    
            
        }
        
    }
    
    private func rotateObjectAdded(circle: SKShapeNode, obj: SKSpriteNode, positionOfTouch: CGPoint)
    {
        let pointX: CGFloat = positionOfTouch.x - circle.position.x
        let pointY: CGFloat = positionOfTouch.y - circle.position.y
        
        var angle: CGFloat = 0
        if pointX.sign == .minus
        {
            angle = CGFloat(atan(pointY/pointX)) + CGFloat.pi / 2
        } else {
            angle = CGFloat(atan(pointY/pointX)) + CGFloat.pi / 2 + CGFloat.pi
        }
        
        obj.zRotation = angle
    }

}


//NEXT:
// Collisions V
// Restrain pird to circle V
// Make movable screen if the pird goes beyond right edge. V
// Make camera that follows pird V
// Make spurdos - menu from left to choose box or spurdo to spawn V <- later it will be used to choose different pirds.
// Change the physcics shape of spurdo's body V
// Make spurdos killable - must learn about SKPhysicsContactDelegate and how to assign it. V
// Add planks V
// Make moving controls in the right lower corner - "joystick" to move screen V
// Make follow pird button on the left. V
// Make icons on the left, below choosing entity circle. V
// Furthermore, fix adding objects. Do not place any, only if player touched button or touched anything interactive or touched screen too close to the pird. Done - every button has a name and that name is checked. V
// Game modes - Create and Play. V
// Counting spurdos. V
// Better control over added objects - moving them with joystick, rotating them etc.
// Make exploding barrels with "FUG" written on them.
// Change properties of the bodies - the movement is too fluid.
// In the lower left bottom there will be a pird to choose.
// Fix pird flying farther when touch is above him and within circle radius.
// Make different types of pirds - exploding ones, the ones that divide into three mid-air and heavier ones.
// Make menu.

// 13/18

// Better ideas:

/*
 
   Play | Edit mode. While in edit mode - choose between physics on or physics off - button on the left while in create mode
   Drag objects holding them with finger, or using joystick. Rotate them by rotating finger on edge of joystick, or taping once on object -
   "menu" will apear - sort of like in photoshop - circle of dots.
   Object will be highlighted by a orange tint.
 
 */


/*
 
    We could add the possibility of tapping a previously added object and modifying it after being added.
 
 */

/*
 
    We will keep the little dots of rotation to a simply aesthetic function - for actual rotation, we will create another invisible shape
 
 */
