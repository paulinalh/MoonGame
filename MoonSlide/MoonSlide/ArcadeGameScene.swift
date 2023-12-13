//
//  ArcadeGameScene.swift
//  MoonSlide
//
//  Created by Pedro Daniel Rouin Salazar on 13/12/23.
//

//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

//we added this
//creating the physics categories
struct PhysicsCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let moon : UInt32 = 0b1
    static let star : UInt32 = 0b10
}

//self.backgroundColor = SKColor.white

class ArcadeGameScene: SKScene {
    
    var ground = SKSpriteNode()
    var star = SKSpriteNode()
    var cloud = SKSpriteNode()
    var moon = SKSpriteNode()
    private var currentNode: SKNode?
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    var player: SKShapeNode!
    
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    
    var isTouchingPlayer = false
    
    override func didMove(to view: SKView) {
        self.setUpGame()
        self.setUpPhysicsWorld()
        self.createBackground()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //we added this
        //here we could check points or see if the player is alive etc
        // ...
        
        // If the game over condition is met, the game will finish
        if self.isGameOver { self.finishGame() }
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
        moveGrounds()
        
    }
    
}

// MARK: - Game Scene Set Up
extension ArcadeGameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        createBackground()
        createMoon()
        createGrounds()
        self.startStarsCycle()
        self.startEvilStarsCycle()
        
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: -0.9, dy: 0)
        //this is to know when contact happens
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
    
    func startStarsCycle() {
        let initialDelay = SKAction.wait(forDuration: 4.0)
        let createStarsAction = SKAction.run(createStar)
        let createAndWaitAction = SKAction.sequence([createStarsAction, initialDelay])
        let starCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(starCycleAction, withKey: "starCycleAction")
        
        // After 10 seconds, change to generating stars every 3 seconds
        let switchTo3Seconds = SKAction.wait(forDuration: 10.0)
        let generateStarsEvery3Seconds = SKAction.repeatForever(SKAction.sequence([SKAction.run(createStar), SKAction.wait(forDuration: 2.0)]))
        let switchTo3SecondsAction = SKAction.run {
            self.removeAction(forKey: "starCycleAction") // Stop the initial cycle
            self.run(generateStarsEvery3Seconds, withKey: "starCycleAction3Seconds")
        }
        
        let sequence = SKAction.sequence([switchTo3Seconds, switchTo3SecondsAction])
        run(sequence)
    }

    func startEvilStarsCycle() {
        let initialDelay = SKAction.wait(forDuration: 9.0)
        let createStarsAction = SKAction.run(createEvilStar)
        let createAndWaitAction = SKAction.sequence([createStarsAction, initialDelay])
        let starEvilCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(starEvilCycleAction, withKey: "starEvilCycleAction")
        
        // After 10 seconds, change to generating stars every 3 seconds
        let switchTo3SecondsE = SKAction.wait(forDuration: 10.0)
        let generateStarsEvery3Seconds = SKAction.repeatForever(SKAction.sequence([SKAction.run(createEvilStar), SKAction.wait(forDuration: 3.0)]))
        let switchTo3SecondsActionE = SKAction.run {
            self.removeAction(forKey: "starEvilCycleAction") // Stop the initial cycle
            self.run(generateStarsEvery3Seconds, withKey: "starCycleAction3SecondsE")
        }
        
        let sequenceE = SKAction.sequence([switchTo3SecondsE, switchTo3SecondsActionE])
        run(sequenceE)
    }
    
   /* func startStarsCycle() {
        let createStarsAction = SKAction.run(createStar)
        let waitAction = SKAction.wait(forDuration: 2.0)
        
        let createAndWaitAction = SKAction.sequence([createStarsAction, waitAction])
        let starCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(starCycleAction)
        
    }*/
}

// MARK: - Player Movement
extension ArcadeGameScene {
    
}

// MARK: - Handle Player Inputs
extension ArcadeGameScene {
    
    enum SideOfTheScreen {
        case right, left
    }
    
    private func sideTouched(for position: CGPoint) -> SideOfTheScreen {
        if position.x < self.frame.width / 2 {
            return .left
        } else {
            return .right
        }
    }
    
    //MARK: Drag
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                if node.name == "Moon" {
                    self.currentNode = node
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentNode = nil
    }
    
}


// MARK: - Game Over Condition
extension ArcadeGameScene {
    
    /**
     * Implement the Game Over condition.
     * Remember that an arcade game always ends! How will the player eventually lose?
     *
     * Some examples of game over conditions are:
     * - The time is over!
     * - The player health is depleated!
     * - The enemies have completed their goal!
     * - The screen is full!
     **/
    
    var isGameOver: Bool {
        // TODO: Customize!
        
        // Did you reach the time limit?
        // Are the health points depleted?
        // Did an enemy cross a position it should not have crossed?
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        
        // TODO: Customize!
        
        gameLogic.isGameOver = true
    }
    
}

// MARK: - Register Score
extension ArcadeGameScene {
    
    private func registerScore() {
        // TODO: Customize!
    }
    
}




// MARK: - Stars
extension ArcadeGameScene {
    
    private func randomStarPosition() -> CGPoint {
        let initialY: CGFloat = 40
        let finalY: CGFloat = self.frame.height - 40
        
        let positionY = CGFloat.random(in: initialY...finalY)
        let positionX = frame.width - 40
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func createStar() {
        let starPosition = self.randomStarPosition()
        newStar(at: starPosition)
    }
    
    private func createEvilStar() {
        let starPosition = self.randomStarPosition()
        newEvilStar(at: starPosition)
    }
    
    private func newStar(at position: CGPoint) {
        let newStar = SKSpriteNode(imageNamed: "star")
        newStar.name = "Star"
        newStar.size = CGSize(width: 30, height: 30)
        
        newStar.position = position
        // we add this
        //add gravity to the asteroid
        newStar.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        newStar.physicsBody?.affectedByGravity = true
        
        //we added this
        //configure the physics bodies
        //body we are configuration
        newStar.physicsBody?.categoryBitMask = PhysicsCategory.star
        //body colliding against
        newStar.physicsBody?.contactTestBitMask = PhysicsCategory.moon
        newStar.physicsBody?.collisionBitMask = PhysicsCategory.moon
        
        addChild(newStar)
        
        newStar.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
    private func newEvilStar(at position: CGPoint) {
        let newStar = SKSpriteNode(imageNamed: "evilStar")
        newStar.name = "EvilStar"
        newStar.size = CGSize(width: 30, height: 30)
        
        newStar.position = position
        // we add this
        //add gravity to the asteroid
        newStar.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        newStar.physicsBody?.affectedByGravity = true
        
        //we added this
        //configure the physics bodies
        //body we are configuration
       /* newStar.physicsBody?.categoryBitMask = PhysicsCategory.star
        //body colliding against
        newStar.physicsBody?.contactTestBitMask = PhysicsCategory.moon
        newStar.physicsBody?.collisionBitMask = PhysicsCategory.moon*/
        
        addChild(newStar)
        
        newStar.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
    
    
}


//MARK: create Moon
extension ArcadeGameScene {
    func createMoon() {
        self.moon = SKSpriteNode(imageNamed: "moon")
        self.moon.name = "Moon"
        self.moon.size = CGSize(width: 100, height: 100)
        //self.moon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let moonPosition = CGPoint(x: self.frame.width/8, y: self.frame.height/2)
        self.moon.position = moonPosition
        //moon.zPosition = 0
        /*moon.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))*/
        
        
        
        /*moon = (self.childNode(withName: "moon") as? SKSpriteNode ?? SKSpriteNode(imageNamed: "moon"))*/
        
        moon.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        moon.physicsBody?.affectedByGravity = false
        //configure the physics bodies
        //body we are configurating
        moon.physicsBody?.categoryBitMask = PhysicsCategory.moon
        //body colliding against
        moon.physicsBody?.contactTestBitMask = PhysicsCategory.star
        moon.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(self.moon)
        
    }
    
}

//MARK: create moving ground
extension ArcadeGameScene{
        
        func createGrounds(){
            for i in 0...2{
                
                let ground = SKSpriteNode(imageNamed: "cloudLayer1")
                ground.name = "Ground"
                ground.size = CGSize(width: (self.scene?.size.width)!, height: 300)
                ground.anchorPoint = CGPoint(x: 0, y:0)
                ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
                //try
                ground.zPosition = -1
                self.addChild(ground)
                
                
            }
        }
        
        func moveGrounds(){
            self.enumerateChildNodes(withName: "Ground", using: ({
                (node, error) in
                
                node.position.x -= 2
                
                if node.position.x < -((self.scene?.size.width)!){
                    node.position.x += (self.scene?.size.width)! * 3
                }
            }))
        }
    
    //MARK: background
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "background") // Use the name of your image asset
        background.size = size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -5
        addChild(background)

    }
}


//MARK: Contacts and Collisions
extension ArcadeGameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB

        if let node = firstBody.node {
            print("Contact with body A: \(node.name ?? "No Name")")
            if node.name == "Star" {
                print("Removed star node from parent.")
                node.removeFromParent()
                if node.parent == nil {
                    print("Star node has no parent.")
                } else {
                    print("Star node's parent: \(node.parent!.name ?? "No Parent Name")")
                }
            }
        }

        if let node = secondBody.node {
            print("Contact with body B: \(node.name ?? "No Name")")
            if node.name == "Star" {
                print("Removed star node from parent.")
                node.removeFromParent()
                if node.parent == nil {
                    print("Star node has no parent.")
                } else {
                    print("Star node's parent: \(node.parent!.name ?? "No Parent Name")")
                }
            }
        }


        print("Contact happened!")
    }

}

