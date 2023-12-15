//
//  LifeBarView.swift
//  MoonSlide
//
//  Created by Pedro Daniel Rouin Salazar on 15/12/23.
//

import SwiftUI

struct LifeBarView: View {
    
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    @Binding var life : Int 

    private let maxLives = 3
    private let sectionWidth : CGFloat = 60
    private let sectionHeight : CGFloat = 20

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxLives, id: \.self) { index in
                RoundedRectangle(cornerRadius: 5)
                    .fill(index < life ? Color.red : Color.gray.opacity(0.3))
                    .frame(width: sectionWidth, height: sectionHeight)
            }
        }
        .padding(15)
        .frame(width: CGFloat(maxLives) * sectionWidth + CGFloat(maxLives - 1) * 4, height: sectionHeight) // Adjust the total width
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

// Preview
struct LifeBarView_Previews: PreviewProvider {
    static var previews: some View {
        LifeBarView(life: .constant(3)) // Example with 3 lives filled
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
