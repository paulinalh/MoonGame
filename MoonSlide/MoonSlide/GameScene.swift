//
//  GameScene.swift
//  MoonSlide
//
//  Created by Paulina Lopez Holguin on 06/12/23.
//
/*
import SpriteKit
import GameplayKit
import SwiftUI

struct PhysicsCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let moon : UInt32 = 0b1
    static let star : UInt32 = 0b10
}

class GameScene: SKScene {
    var ground = SKSpriteNode()
    var star = SKSpriteNode()
    var cloud = SKSpriteNode()
    var moon = SKSpriteNode()
    private var currentNode: SKNode?

    
    override func didMove(to view: SKView){
        self.anchorPoint = CGPoint(x: 0.5, y:0.5)
        
        self.setUpPhysicsWorld()
        
        
        createGrounds()
        createClouds()
        createMoon()
        createStars()
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        
        //we added this
        //this is to know when contact happens
        physicsWorld.contactDelegate = self
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
            
            let ground = SKSpriteNode(imageNamed: "ground")
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
            
            star.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
            star.physicsBody?.affectedByGravity = false
            star.zPosition = 0
            //configure the physics bodies
            //body we are configuration
            star.physicsBody?.categoryBitMask = PhysicsCategory.star
            //body colliding against
            star.physicsBody?.contactTestBitMask = PhysicsCategory.moon
            star.physicsBody?.collisionBitMask = PhysicsCategory.moon
            
            addChild(star)
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
        self.moon = SKSpriteNode(imageNamed: "moon")
        self.moon.name = "Moon"
        self.moon.size = CGSize(width: 200, height: 200)
        self.moon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        moon.zPosition = 0
        /*moon.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))*/
        
        
        
        /*moon = (self.childNode(withName: "moon") as? SKSpriteNode ?? SKSpriteNode(imageNamed: "moon"))*/
        
        moon.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        moon.physicsBody?.affectedByGravity = false
        //configure the physics bodies
        //body we are configurating
        moon.physicsBody?.categoryBitMask = PhysicsCategory.moon
        //body colliding against
        moon.physicsBody?.contactTestBitMask = PhysicsCategory.star
        moon.physicsBody?.collisionBitMask = PhysicsCategory.star
        
        addChild(self.moon)
        
    }
    
}

extension GameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact : SKPhysicsContact){
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody =  contact.bodyB
        
        //checking by name not the most efficient way
        //we could do it by checking the masks
        if let node = firstBody.node, node.name == "Moon"{
            node.removeFromParent()
        }
        if let node = secondBody.node, node.name == "Moon"{
            node.removeFromParent()
        }
        print("Contact happened!")
    }
}
*/
