//
//  ArcadeGameLogic.swift
//  MoonSlide
//
//  Created by Pedro Daniel Rouin Salazar on 13/12/23.
//

import Foundation

class ArcadeGameLogic: ObservableObject {
    
    // Single instance of the class
    static let shared: ArcadeGameLogic = ArcadeGameLogic()    
    // Function responsible to set up the game before it starts.
    func setUpGame() {
        
        // TODO: Customize!
        self.currentScore = 0
        self.sessionDuration = 0
        
        self.isGameOver = false
        self.lifesRemaining = 3
    }
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    @Published var maxScore: Int = 2000
    @Published var lifesRemaining: Int = 3
    // Increases the score by a certain amount of points
    func score(points: Int) {
        
        // TODO: Customize!
        
        self.currentScore = self.currentScore + points
    }
    
    func lifesAfterCollision(){
        self.lifesRemaining = self.lifesRemaining - 1
    }
    // Keep tracks of the duration of the current session in number of seconds
    @Published var sessionDuration: TimeInterval = 0
    
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.sessionDuration = self.sessionDuration + timeIncrement
    }
    
    func restartGame() {
        
        // TODO: Customize!
        
        self.setUpGame()
    }
    
    // Game Over Conditions
    @Published var isGameOver: Bool = false
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
        }
    }
    
}
