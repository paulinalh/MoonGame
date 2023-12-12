//
//  GameScene.swift
//  MoonSlide
//
//  Created by Paulina Lopez Holguin on 06/12/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ground = SKSpriteNode()
    var star = SKSpriteNode()
    var cloud = SKSpriteNode()
    var moon = SKSpriteNode()
    private var currentNode: SKNode?

    
    override func didMove(to view: SKView){
        self.anchorPoint = CGPoint(x: 0.5, y:0.5)
        
        createGrounds()
        createStars()
        createClouds()
        createMoon()
        
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
