//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct MainScreenView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    
    // Change it on the Constants.swift file
    //var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    //var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {
        
        ZStack{
            
            Image("menuImage") // Replace "yourImageName" with the actual name of your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 950, height: 400)
            
            VStack(alignment: .center){
                
                Spacer()
                
                HStack(alignment: .center, spacing: 200.0) {
                    
                    Button {
                        withAnimation { self.startGame() }
                    } label: {
                        Text("PLAY")
                            .padding()
                            .frame(maxWidth: 200)
                    }
                    .foregroundColor(.white)
                    .background(self.accentColor)
                    .cornerRadius(100.0)
                    
                    Button {
                        withAnimation { self.startGame() }
                    } label: {
                        Text("LEADERBOARD")
                            .padding()
                            .frame(maxWidth: 200)
                    }
                    .foregroundColor(.white)
                    .background(self.accentColor)
                    .cornerRadius(100.0)
                    
                }
                .padding()
                .statusBar(hidden: true)
                
            }
            

            
        }.padding()
            .statusBar(hidden: true)
            .background(Color.darkBlue)
        
        
    }
    
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

#Preview {
    MainScreenView(currentGameState: .constant(GameState.mainScreen))
}
