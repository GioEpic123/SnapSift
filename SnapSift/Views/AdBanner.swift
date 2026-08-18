//
//  AdBanner.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import GoogleMobileAds

struct AdBanner: UIViewRepresentable {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = Secrets.testAdUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController

        // For development, use test device identifier
        bannerView.delegate = context.coordinator

        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // Update the banner view with a test request for development
        let request = GADRequest()

        // For development, use test device identifiers
        request.testDevices = [kGADSimulatorID]

        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        let parent: AdBanner

        init(_ parent: AdBanner) {
            self.parent = parent
        }

        // Banner view delegate methods can be added here if needed
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            // Handle ad received
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            // Handle ad failure
        }
    }
}