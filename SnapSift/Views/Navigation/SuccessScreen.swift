//
//  SuccessScreen.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI

struct SuccessScreen: View {
    @Environment(AppState.self)
    private var appState: AppState
    
    let count: Int

    var body: some View {
        VStack(spacing: 30) {

            Spacer()

            Image(systemName: "checkmark.circle")
                .font(.system(size: 100))
                .foregroundColor(AppColors.aquamarine.color)

            Text("🎉 Success! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)


            Text("You've successfully deleted \(count == 1 ? "1 photo" : "\(count) photos")!")
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding(.horizontal)

            Spacer()

            Button(action: returnToHome) {
                Text("Back to Swiping!!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.aquamarine.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)
    }

    private func returnToHome() {
        // Reset the app state and go back to permission screen
        appState.reset()
    }
}

#Preview {
    SuccessScreen(count: 5)
        .environment(AppState())
}
