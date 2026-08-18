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

        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
           let rootViewController = windowScene.windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
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
