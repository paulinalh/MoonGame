//
//  OnboardingView.swift
//  testgame
//
//  Created by Karan Oroumchi on 13/12/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var currentGameState: GameState = .mainScreen

    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    private let onboardingData: [OnboardingData] = [
        OnboardingData(title: "Control the moon", description: "Drag the moon to up and down to control its movement. Collect stars to light up your lunar journey."),
        OnboardingData(title: "Get 'em juicy stars", description: "Collect stars for upgrades, power-ups, and a dazzling high score, don't forget to brag to your friends!"),
        OnboardingData(title: "Avoid the enemies", description: "Watch you back there cause the sun is there to get ya! lets catch all the stars before it does, shall we?"),
    ]
    @State private var currentPage = 0

    var body: some View {
        if isFirstLaunch {
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: 2)
                    VStack {
                        TabView(selection: $currentPage) {
                            ForEach(onboardingData.indices, id: \.self) { index in
                                VStack {
                                    Image("MOOOON-\(index + 1)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                                        .padding(.bottom, 10)

                                    Text(onboardingData[index].title)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.1)
                                        .padding(.bottom, -10)

                                    Text(onboardingData[index].description)
                                        .multilineTextAlignment(.center)
                                        .font(Font.custom("SF Pro Rounded", size: 20))
                                        .foregroundColor(.gray)

                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.2)
                                        .padding(.bottom, 50)
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        
                        .overlay(
                            Button(action: {
                                if currentPage == onboardingData.count - 1 {
                                    isFirstLaunch = false
                                } else {
                                    currentPage += 1
                                }
                            }) {
                                Text(currentPage == onboardingData.count - 1 ? "Done" : "Skip")
                                    .bold()
                                    .padding(.horizontal, 30)
                                    .padding(.vertical)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(40)
                            }
                                .padding(.bottom, 20)
                            .frame(maxWidth: .infinity, alignment: .trailing),
                            alignment: Alignment.bottomTrailing
                        )
                        
                                            }
                    .padding(.top, 20)
                }
            }
        } else {
            //change this to main view when you guys finish your merge
            MainScreenView(currentGameState: $currentGameState)
            //ArcadeGameView(currentGameState: $currentGameState)
        }
    }
}

struct OnboardingData {
    let title: String
    let description: String
}



#Preview {
    OnboardingView()
}
