//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI
import AVFoundation
/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    @StateObject var gameLogic: ArcadeGameLogic =  ArcadeGameLogic.shared
    @AppStorage("highScore") var highScore: Int = 0
    var player: AVAudioPlayer?
    
    /*init() {
           // Set up the audio player
           if let soundURL = Bundle.main.url(forResource: "gameOver", withExtension: "mp3") {
               do {
                   // Initialize the player with the sound URL
                   player = try AVAudioPlayer(contentsOf: soundURL)
               } catch {
                   print("Failed to initialize player: \(error)")
               }
           }
       }*/

    var body: some View {
        
        ZStack {
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                
                Image("gameOver") // Replace "yourImageName" with the actual name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 300)
                
                
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    .background(Circle().foregroundColor(Color.white).frame(width: 70, height: 70, alignment: .center))
                    
                    Spacer()
                    
                    HStack{
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.largeTitle)
                        Text("\(gameLogic.currentScore)").foregroundColor(.yellow).font(.largeTitle).fontWeight(.bold)
                        
                        Image(systemName: "crown.fill").foregroundColor(.yellow).font(.largeTitle)
                        Text("\(highScore)").foregroundColor(.yellow).font(.largeTitle).fontWeight(.bold)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    .background(Circle().foregroundColor(Color.white).frame(width: 70, height: 70, alignment: .center))
                    
                    Spacer()
                }
                
            }
            .padding(.bottom, 50)
            
            
        }
        
        .statusBar(hidden: true)
        
        .onAppear{
            player?.play()

            if gameLogic.currentScore > highScore {
                highScore = gameLogic.currentScore
            }
        }
        
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}


#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver))
}
