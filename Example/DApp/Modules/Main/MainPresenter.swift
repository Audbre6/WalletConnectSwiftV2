import UIKit
import Combine

final class MainPresenter {
    private let interactor: MainInteractor
    private let router: MainRouter
    private var disposeBag = Set<AnyCancellable>()

    var tabs: [TabPage] {
        return TabPage.allCases
    }

    var viewControllers: [UIViewController] {
        return [
            router.signViewController(),
            router.authViewController()
        ]
    }

    init(router: MainRouter, interactor: MainInteractor) {
        defer {
            setupInitialState()
        }
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - Private functions
extension MainPresenter {
    private func setupInitialState() {}
}
