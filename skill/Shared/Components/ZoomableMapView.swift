import SwiftUI
import UIKit

struct ZoomableMapView<Content: View>: UIViewControllerRepresentable {
    let size: CGSize
    var resetToken = 0
    @ViewBuilder var content: Content

    func makeUIViewController(context: Context) -> MapController<Content> {
        MapController(size: size, content: content)
    }
    func updateUIViewController(_ controller: MapController<Content>, context: Context) {
        controller.update(size: size, resetToken: resetToken, content: content)
    }
}

final class MapController<Content: View>: UIViewController, UIScrollViewDelegate {
    private let scroll = UIScrollView()
    private let host: UIHostingController<Content>
    private var mapSize: CGSize
    private var needsFit = true
    private var resetToken = 0
    private var viewportSize = CGSize.zero

    init(size: CGSize, content: Content) {
        mapSize = size
        host = UIHostingController(rootView: content)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        scroll.delegate = self
        scroll.backgroundColor = .clear
        scroll.isOpaque = false
        scroll.clipsToBounds = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.bouncesZoom = true
        scroll.isDirectionalLockEnabled = false
        scroll.contentInsetAdjustmentBehavior = .never
        view.addSubview(scroll)
        addChild(host)
        host.view.backgroundColor = .clear
        host.view.isOpaque = false
        scroll.addSubview(host.view)
        host.didMove(toParent: self)
        host.view.frame = CGRect(origin: .zero, size: mapSize)
        scroll.contentSize = mapSize
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(toggleZoom))
        doubleTap.numberOfTapsRequired = 2
        scroll.addGestureRecognizer(doubleTap)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.frame = view.bounds
        if viewportSize != view.bounds.size {
            viewportSize = view.bounds.size
            needsFit = true
        }
        guard needsFit, view.bounds.width > 0, view.bounds.height > 0 else { return }
        let fit = min(view.bounds.width / mapSize.width, view.bounds.height / mapSize.height)
        scroll.minimumZoomScale = fit
        scroll.maximumZoomScale = max(3, fit * 5)
        scroll.zoomScale = min(1, fit * 1.25)
        centerContent()
        scroll.contentOffset = CGPoint(x: (mapSize.width * scroll.zoomScale - view.bounds.width) / 2,
                                       y: (mapSize.height * scroll.zoomScale - view.bounds.height) / 2)
        needsFit = false
    }

    func update(size: CGSize, resetToken: Int, content: Content) {
        host.rootView = content
        if self.resetToken != resetToken {
            self.resetToken = resetToken
            needsFit = true
            view.setNeedsLayout()
        }
        if size != mapSize {
            mapSize = size
            scroll.zoomScale = 1
            host.view.frame = CGRect(origin: .zero, size: size)
            scroll.contentSize = size
            needsFit = true
            view.setNeedsLayout()
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { host.view }

    private func centerContent() {
        let horizontal = max(0, (scroll.bounds.width - scroll.contentSize.width) / 2)
        let vertical = max(0, (scroll.bounds.height - scroll.contentSize.height) / 2)
        scroll.contentInset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) { centerContent() }

    @objc private func toggleZoom(_ gesture: UITapGestureRecognizer) {
        if scroll.zoomScale > scroll.minimumZoomScale * 1.8 {
            scroll.setZoomScale(scroll.minimumZoomScale, animated: true)
        } else {
            let target = min(scroll.maximumZoomScale, scroll.zoomScale * 2)
            let point = gesture.location(in: host.view)
            let size = CGSize(width: scroll.bounds.width / target, height: scroll.bounds.height / target)
            scroll.zoom(to: CGRect(x: point.x - size.width / 2, y: point.y - size.height / 2, width: size.width, height: size.height), animated: true)
        }
    }
}

#Preview {
    ZoomableMapView(size: CGSize(width: 800, height: 800)) {
        Image(systemName: "globe").resizable().padding(100).frame(width: 800, height: 800)
    }
    .frame(height: 420)
}
