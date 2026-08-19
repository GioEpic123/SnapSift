import SwiftUI
import GoogleMobileAds

struct AdBanner: View {
    let adUnitID: String

    var body: some View {
        GeometryReader { geometry in
            BannerViewRepresentable(
                adUnitID: adUnitID,
                width: geometry.size.width
            )
        }
        .frame(height: 50)
    }
}

private struct BannerViewRepresentable: UIViewRepresentable {
    let adUnitID: String
    let width: CGFloat

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(
            adSize: currentOrientationAnchoredAdaptiveBanner(
                width: width
            )
        )

        banner.adUnitID = adUnitID

        // Find the currently active iOS window
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
           // find its root UIKit view controller
           let rootViewController = windowScene.windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
                // tell the AdMob banner that this is the view controller it belongs to
                banner.rootViewController = rootViewController
            }

        banner.load(Request())

        return banner
    }

    func updateUIView(
        _ uiView: BannerView,
        context: Context
    ) {}
}
