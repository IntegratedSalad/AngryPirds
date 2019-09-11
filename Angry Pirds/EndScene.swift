//
//  EndScene.swift
//  Angry Pirds
//
//  Created by Buppo on 11/09/2019.
//  Copyright © 2019 Buppo. All rights reserved.
//

import SpriteKit

class EndScene: SKScene
{
    override func didMove(to view: SKView)
    {
        let endGameText = SKLabelNode(text: "Ebin XDDDDDDDDD")
        
        endGameText.color = .brown
        let spurdoTexture = SKTexture(imageNamed: "spurdo")
        let spurdo = SKSpriteNode(texture: spurdoTexture)
        
        spurdo.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        spurdo.scale(to: CGSize(width: 180, height: 150))
        
        let rotationAnimation = SKAction.rotate(byAngle: CGFloat.pi / 2, duration: 0.05)
        let endlessLoop = SKAction.repeatForever(rotationAnimation)
        spurdo.run(endlessLoop)
        self.addChild(endGameText)
        self.addChild(spurdo)
    }
}
