//
//  GameOverScene.swift
//  GameOfLife2
//
//  Created by Timo Höting on 16.11.14.
//  Copyright (c) 2014 Timo Höting. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver : SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        var message = won ? "You Won!" : "You Lose :["
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height * 2.0/3.0)
        addChild(label)
        
        let labelrestart = SKLabelNode(fontNamed: "Courier")
        labelrestart.text = "Neusstart"
        labelrestart.fontSize = 20
        labelrestart.fontColor = SKColor.whiteColor()
        labelrestart.position = CGPoint(x: size.width/2, y: size.height * 2.0/3.0 - 80)
        addChild(labelrestart)
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}