//
//  GameScene.swift
//  Minesweeper
//
//  Created by Timo Höting on 11.11.14.
//  Copyright (c) 2014 Timo Höting. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Touch     : UInt32 = 0b1
    static let Field     : UInt32 = 0b10
}

struct tile :  Hashable {
    var description:String {
        return "posX\(x)Y\(y)"
    }
    var hashValue:Int {
        return x + (y * 100)
    }
    var x : Int
    var y : Int
}


func == (lhs: tile, rhs: tile) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var nodes = [SKSpriteNode]()
    var touchNode = SKSpriteNode()
    var gamelogic = Gamelogic()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let myLabel = SKLabelNode(fontNamed:"Courier")
        myLabel.text = "Minesweeper on iOS";
        myLabel.fontSize = 20;
        myLabel.position = CGPoint(x:size.width / 2, y:size.height-50);
        self.addChild(myLabel)

        addFields()
        
        for y in 0...8{
            for x in 0...8{
               gamelogic.initField(x, y: y, mine: false)
            }
        }
        gamelogic.initField(3, y: 2, mine: true)
        gamelogic.initField(4, y: 2, mine: true)
        gamelogic.initField(5, y: 2, mine: true)
        gamelogic.initField(3, y: 4, mine: true)
        gamelogic.initField(4, y: 5, mine: true)
    }
    
    
    func addFields(){
        let startPosition = CGPoint(x: 340, y: 550)
        for y in 0...8{
            for x in 0...8{
                var t1 = CGFloat( x * 40 )
                var t2 = CGFloat( y * 40 )
                let field = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 30  , height: 30))
                field.position = CGPoint(x: startPosition.x + t1, y: startPosition.y - t2)
                field.name = NSString(format: "%i:%i",x,y)
        
                field.physicsBody = SKPhysicsBody(rectangleOfSize: field.size)
                field.physicsBody?.dynamic = true
                field.physicsBody?.categoryBitMask = PhysicsCategory.Field
                field.physicsBody?.contactTestBitMask = PhysicsCategory.Touch
                field.physicsBody?.collisionBitMask = PhysicsCategory.None
                
                nodes.append(field)
                addChild(field)
            }
        }
    }
    
    func reloadField(node : SKNode){
        var name = node.name!
        var nameArr = name.componentsSeparatedByString(":")
        var x = nameArr[0].toInt()
        var y = nameArr[1].toInt()

        if(gamelogic.islooser(x!, y: y!)){
            let gameoverscene = GameOver(size: self.size, won: false)
            self.view?.presentScene(gameoverscene)
        } else {
        if(gamelogic.isClicked(x!, y: y!) == false){
            var number = gamelogic.countNeighbourMines(x!,y: y!)
            var label = SKLabelNode(fontNamed:"Courier")
            label.text = String(number);
            label.fontSize = 20;
            label.position = CGPoint(x: node.position.x, y: node.position.y-10)
            self.addChild(label)
            }
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touch = touches.anyObject() as UITouch
            let touchLocation = touch.locationInNode(self)
            
            touchNode = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 5  , height: 5))
            touchNode.position = touchLocation
            touchNode.name = "touch"
            
            touchNode.physicsBody = SKPhysicsBody(rectangleOfSize: touchNode.size)
            touchNode.physicsBody?.dynamic = true
            touchNode.physicsBody?.categoryBitMask = PhysicsCategory.Touch
            touchNode.physicsBody?.contactTestBitMask = PhysicsCategory.Field
            touchNode.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            nodes.append(touchNode)
            addChild(touchNode)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
     func didBeginContact(contact: SKPhysicsContact) {
        NSLog("contact!")
        
        var tempNode = SKPhysicsBody()
        if(contact.bodyA.categoryBitMask == PhysicsCategory.Field){
           var temp = contact.bodyA.node
            reloadField(temp!)
            //var tempNode = contact.bodyA
        }
        if(contact.bodyB.categoryBitMask == PhysicsCategory.Field){
            var temp = contact.bodyB.node
             reloadField(temp!)
            //var tempNode = contact.bodyB
        }
        //reloadField(tempNode)
    }
}
