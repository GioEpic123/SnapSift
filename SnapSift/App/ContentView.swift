//
//  ContentView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self)
    private var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
                switch appState.currentView {
                case .home:
                    HomeView()
                case .permission:
                    PermissionView()
                case .photoStack:
                    PhotoStackView()
                case .selectionGrid:
                    SelectionGridView()
                case .success(let count):
                    SuccessScreen(count: count)
                }
            }

            AdBanner(adUnitID: Secrets.testAdUnitID)
        }
    }
}

// TODO: Where should this live?
public enum AppColors: CaseIterable {
    case spearMint
    case burgundy
    case aquamarine
    
    public var color: Color {
        switch self {
        case .spearMint:
            return Color(red: 199/255, green: 251/255, blue: 255/255)
        case .burgundy:
            return Color(red: 128/255, green: 0/255, blue: 32/255)
        case .aquamarine:
            return Color(red: 20/255, green: 106/255, blue: 93/255)
        }
    }
}

struct TitleCard: View {
    var body: some View {
        HStack{
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.aquamarine.color)
            
            Text("SnapSift")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .offset(x: -10)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
