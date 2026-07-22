//
//  DateFilterView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 7/16/26.
//

import SwiftUI


struct DateFilterView: View {
    
    @Environment(AppState.self)
    private var appState: AppState
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {

            Text("Filter by Date")
                    .font(.title2)
                    .bold()
            
            Form {
                DatePicker(
                    "From",
                    selection: Binding(
                        get: { appState.activeFilter?.startDate ?? appState.oldestPhotoDate ?? Date.distantPast },
                        set: { appState.activeFilter = PhotoFilter(startDate: $0, endDate: appState.activeFilter?.endDate ?? nil) }
                    ),
                    displayedComponents: .date
                )
                
                DatePicker(
                    "To",
                    selection: Binding(
                        get: { appState.activeFilter?.endDate ?? Date() },
                        set: { appState.activeFilter = PhotoFilter(startDate: appState.activeFilter?.startDate ?? nil, endDate: $0) }
                    ),
                    displayedComponents: .date
                )
            }
            
            HStack{
                Spacer()
                Button("Clear"){
                    appState.activeFilter = nil
                    appState.refreshPhotos()
                    dismiss()
                }
                .padding()
                Spacer()
                Button("Apply"){
                    appState.refreshPhotos()
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            
        }
        .padding()
        .safeAreaInset(edge:.bottom){
            Text("Changing the filter will reset your progress!")
                .foregroundColor(AppColors.burgundy.color.opacity(0.8))
        }
    }
}
