//
//  GameScene.swift
//  MoonSlide
//
//  Created by Paulina Lopez Holguin on 06/12/23.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let moon : UInt32 = 0b1
    static let star : UInt32 = 0b10
}

class GameScene: SKScene {
    var background = SKSpriteNode(imageNamed: "nightSky")
    var ground = SKSpriteNode()
    var star = SKSpriteNode()
    var cloud = SKSpriteNode()
    var moon = SKSpriteNode()
    private var currentNode: SKNode?
    var gameLogic: GameLogic = GameLogic.shared
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    override func didMove(to view: SKView){
        
        let background = SKSpriteNode(imageNamed: "nightSky")
                
        background.size = size
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        background.zPosition = -1
        
        addChild(background)
        
        
        //self.anchorPoint = CGPoint(x: 0.5, y:0.5)
        self.setUpGame()
        self.setUpPhysicsWorld()
        
        
    }
    
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
    
    override func update(_ currentTime: CFTimeInterval){
        moveGrounds()
        moveStars()
        moveClouds()
    }
    
    func createGrounds(){
        for i in 0...2{
            
            let ground = SKSpriteNode(imageNamed: "cloudGround")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            ground.anchorPoint = CGPoint(x: 0.5, y:0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            //try
            //ground.zPosition = -1
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
    
    func createStars(){
        for i in 0...10{
            
            let star = SKSpriteNode(imageNamed: "star")
            
            star.name = "Star"
            star.size = CGSize(width: 30, height: 30)
            star.anchorPoint = CGPoint(x: Int.random(in: -20 ..< -5), y: Int.random(in: -40 ..< -5))
            star.position = CGPoint(x: CGFloat(i) * star.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild(star)
        }
    }
    
    func moveStars(){
        self.enumerateChildNodes(withName: "Star", using: ({
            (node, error) in
            
            node.position.x -= 1
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func createClouds(){
        for i in 0...10{
            
            let cloud = SKSpriteNode(imageNamed: "cloud")
            
            cloud.name = "Cloud"
            cloud.size = CGSize(width: 100, height: 100)
            cloud.anchorPoint = CGPoint(x: Int.random(in: -5..<5), y: Int.random(in: -30 ..< -5))
            cloud.position = CGPoint(x: CGFloat(i) * cloud.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild(cloud)
        }
    }
    
    func moveClouds(){
        self.enumerateChildNodes(withName: "Cloud", using: ({
            (node, error) in
            
            node.position.x -= 0.5
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func createMoon() {
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.name = "Moon"
        moon.size = CGSize(width: 200, height: 200)
        moon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        /*moon.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))*/
        
        
        
        /*moon = (self.childNode(withName: "moon") as? SKSpriteNode ?? SKSpriteNode(imageNamed: "moon"))*/
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        self.addChild(moon)
        
    }
}

// MARK: - Game Scene Set Up
extension GameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        
        /*createGrounds()
        createStars()
        createClouds()
        createMoon()*/
        
        let moonInitialPosition = CGPoint(x: 0.5, y: 0.5)
         self.createPlayer(at: moonInitialPosition)
         self.startStarsCycle()
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
        //physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
    
    private func createPlayer(at position: CGPoint) {
        
        self.moon = SKSpriteNode(imageNamed: "moon")
        self.moon.name = "Moon"
        self.moon.size = CGSize(width: 200, height: 200)
        self.moon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.moon.position = position
        
        moon.physicsBody = SKPhysicsBody(circleOfRadius: 100.0)
        moon.physicsBody?.affectedByGravity = false
        
        moon.physicsBody?.categoryBitMask = PhysicsCategory.moon
        
        moon.physicsBody?.contactTestBitMask = PhysicsCategory.star
        moon.physicsBody?.collisionBitMask = PhysicsCategory.star
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width - 15)
        
        let xConstraint = SKConstraint.positionX(xRange)
        
        self.moon.constraints = [xConstraint]
        addChild(self.moon)
    }
    
    func startStarsCycle() {
        let createStarAction = SKAction.run(createStar)
        let waitAction = SKAction.wait(forDuration: 1.0)
        
        let createAndWaitAction = SKAction.sequence([createStarAction, waitAction])
        let starCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(starCycleAction)
    }
}

// MARK: - Stars
extension GameScene {
    
    private func createStar() {
        let starPosition = self.randomStarPosition()
        newStar(at: starPosition)
    }
    
    private func randomStarPosition() -> CGPoint {
        /*let initialX: CGFloat = 25
         let finalX: CGFloat = self.frame.width - 25
         
         let positionX = CGFloat.random(in: initialX...finalX)
         let positionY = frame.height - 25
         
         return CGPoint(x: positionX, y: positionY)*/
        
        let initialY: CGFloat = 0.5
        let finalY: CGFloat = self.frame.height
        
        let positionY = CGFloat.random(in: initialY...finalY)
        let positionX = frame.width + 5
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newStar(at position: CGPoint) {
        
        let newStar = SKSpriteNode(imageNamed: "star")
        newStar.name = "Star"
        newStar.size = CGSize(width: 30, height: 30)
        newStar.position = CGPoint(x: CGFloat() * star.size.width, y: -(self.frame.size.height / 2))
        newStar.physicsBody = SKPhysicsBody (circleOfRadius: 25.0)
        newStar.physicsBody?.affectedByGravity = true
        
        newStar.position = position
        
        newStar.physicsBody?.categoryBitMask = PhysicsCategory.star
        newStar.physicsBody?.collisionBitMask = PhysicsCategory.moon
        
        addChild(newStar)
        
        moveStars()
        
        newStar.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
}



//MARK: - Contacts and Collisions
extension GameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact){
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node  = firstBody.node, node.name == "Star" {
            node.removeFromParent()
        }
        
        if let node = secondBody.node, node.name == "Star" {
            node.removeFromParent()
        }
        
        print("Contact happened!")
    }
}
