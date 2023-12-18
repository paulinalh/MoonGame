//
//  GameScoreView.swift
//  ArcadeGameTemplate
//


/**
 * # GameScoreView
 * Custom UI to present how many points the player has scored.
 *
 * Customize it to match the visual identity of your game.
 */

import SwiftUI

struct GameScoreView: View {
    @Binding var score: Int
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    @AppStorage("highScore") var highScore: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background of the progress bar with black border
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 6) // Add stroke here
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color.gray.opacity(0.3)))
                    .frame(height: 30)

                // Progress Bar with Gradient, clipped to maintain corner radius
                RoundedRectangle(cornerRadius: 38) // Slightly smaller radius for the inner rectangle
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: min(geometry.size.width * CGFloat(gameLogic.currentScore) / CGFloat(highScore), geometry.size.width), height: 26) // Slightly smaller height for the inner rectangle
                    .clipShape(RoundedRectangle(cornerRadius: 38)) // Clip to round corners

                // Score and Image, aligned to the right
              
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("\(score)")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
            }
        }
        .frame(width: 200, height: 30) // Set the height of the progress bar
        .cornerRadius(40)
        .padding(15)
        .foregroundColor(.black)
    }
}

// Preview
struct GameScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GameScoreView(score: .constant(50))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}

