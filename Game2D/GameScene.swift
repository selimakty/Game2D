//
//  GameScene.swift
//  Game2D
//
//  Created by Selim on 7.01.2023.
//

import SpriteKit
import GameplayKit

enum CollisionType:UInt32{
    case main = 1
    case black = 2
    case yellow = 3
    case red = 4
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    var mainCharacter:SKSpriteNode = SKSpriteNode()
    var redTriangle:SKSpriteNode = SKSpriteNode()
    var yellowCircle:SKSpriteNode = SKSpriteNode()
    var blackSquare:SKSpriteNode = SKSpriteNode()
    
    var scoreLabel:SKLabelNode = SKLabelNode()
    
    var viewController:UIViewController?
    
    var touchControl = false
    var startControl = false
    
    var timer:Timer?
    
    var screenWidth:Int?
    var screenHeight:Int?
    
    var totalScore = 0
    var yLastPosition:CGFloat?
    
    override func didMove(to view: SKView) {
    
        self.physicsWorld.contactDelegate = self
        
        screenWidth = Int(self.size.width)
        screenHeight = Int(self.size.height)
        yLastPosition = CGFloat(0)
        
        
        if let Char = self.childNode(withName: "mainCharacter") as? SKSpriteNode {
            mainCharacter = Char
            mainCharacter.physicsBody?.categoryBitMask = CollisionType.main.rawValue
            mainCharacter.physicsBody?.collisionBitMask = CollisionType.black.rawValue | CollisionType.yellow.rawValue | CollisionType.red.rawValue
            mainCharacter.physicsBody?.contactTestBitMask = CollisionType.black.rawValue | CollisionType.yellow.rawValue | CollisionType.red.rawValue
        }
        
        if let Triangle = self.childNode(withName: "redTriangle") as? SKSpriteNode {
            redTriangle = Triangle
            redTriangle.physicsBody?.categoryBitMask = CollisionType.red.rawValue
            redTriangle.physicsBody?.collisionBitMask = CollisionType.main.rawValue
            redTriangle.physicsBody?.contactTestBitMask = CollisionType.main.rawValue
        }
        
        if let Circle = self.childNode(withName: "yellowCircle") as? SKSpriteNode {
            yellowCircle = Circle
            yellowCircle.physicsBody?.categoryBitMask = CollisionType.yellow.rawValue
            yellowCircle.physicsBody?.collisionBitMask = CollisionType.main.rawValue
            yellowCircle.physicsBody?.contactTestBitMask = CollisionType.main.rawValue
        }
        
        if let Square = self.childNode(withName: "blackSquare") as? SKSpriteNode {
            blackSquare = Square
            blackSquare.physicsBody?.categoryBitMask = CollisionType.black.rawValue
            blackSquare.physicsBody?.collisionBitMask = CollisionType.main.rawValue
            blackSquare.physicsBody?.contactTestBitMask = CollisionType.main.rawValue
        }
        
        if let Label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
            scoreLabel = Label
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(GameScene.movement), userInfo: nil, repeats: true)
    }
    
    @objc func movement(){
        
        if startControl{
            
            if touchControl{
                
                let upMove:SKAction = SKAction.moveBy(x: 0, y: +12, duration: 0.15)
                
                mainCharacter.run(upMove)
                
            }else{
                let downMove:SKAction = SKAction.moveBy(x: 0, y: -12, duration: 0.15)
                
                mainCharacter.run(downMove)
            }
            
            
            
            FreeMovementOfObjects(objectName: blackSquare, objectSpeed: 15)
            FreeMovementOfObjects(objectName: yellowCircle, objectSpeed: 10)
            FreeMovementOfObjects(objectName: redTriangle, objectSpeed: 20)
            
            
        }else{
            // label ekleyip efektli ekrana dokun yazdırt
        }
    }
    
    func FreeMovementOfObjects(objectName:SKSpriteNode,objectSpeed:CGFloat){
        
        if Int(objectName.position.x) < 0 {
            var y = -CGFloat(Int.random(in: 130..<screenHeight!))
                        
            if yLastPosition! == y {
               y = y - CGFloat(30)
            }
            yLastPosition = y
            
            objectName.position.x = CGFloat(screenWidth! + 20)
            objectName.position.y = y
        }else{
            let leftMove:SKAction = SKAction.moveBy(x: -objectSpeed, y: 0, duration: 6)
            objectName.run(leftMove)
        }
    }

    func touchDown(atPoint pos : CGPoint) {
       
        touchControl = true
        startControl = true
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
      // print("moved:\(pos.x),\(pos.y)")
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
       touchControl = false
        
    }
    
    // çarpışma kontrolü sağlar
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CollisionType.main.rawValue && contact.bodyB.categoryBitMask == CollisionType.black.rawValue) ||
            (contact.bodyB.categoryBitMask == CollisionType.main.rawValue && contact.bodyA.categoryBitMask == CollisionType.black.rawValue){
            
            timer?.invalidate()
            
            
            let userDef = UserDefaults.standard
            userDef.set(totalScore, forKey: "score")
            
            
            self.viewController?.performSegue(withIdentifier: "gameToFinal", sender: nil)
            
        }
        else if (contact.bodyA.categoryBitMask == CollisionType.main.rawValue && contact.bodyB.categoryBitMask == CollisionType.yellow.rawValue) ||
                (contact.bodyB.categoryBitMask == CollisionType.main.rawValue && contact.bodyA.categoryBitMask == CollisionType.yellow.rawValue){
            
            totalScore = totalScore + 20
            scoreLabel.text = "Score : \(totalScore)"
            
            let RefreshObject:SKAction = SKAction.moveBy(x: CGFloat(screenWidth!+20), y: -CGFloat(arc4random_uniform(UInt32(screenHeight!))), duration: 0.02)
            yellowCircle.run(RefreshObject)
        }
        else if (contact.bodyA.categoryBitMask == CollisionType.main.rawValue && contact.bodyB.categoryBitMask == CollisionType.red.rawValue) ||
                (contact.bodyB.categoryBitMask == CollisionType.main.rawValue && contact.bodyA.categoryBitMask == CollisionType.red.rawValue){
            
            totalScore = totalScore + 50
            scoreLabel.text = "Score : \(totalScore)"
            
            let RefreshObject:SKAction = SKAction.moveBy(x: CGFloat(screenWidth!+20), y: -CGFloat(arc4random_uniform(UInt32(screenHeight!))), duration: 0.02)
            redTriangle.run(RefreshObject)

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
