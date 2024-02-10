
import UIKit

class ChromaticsCoordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let colorService = ColorService.shared
        let viewModel = ChromaticsViewModel(colorService: colorService)
        viewModel.delegate = self
        let viewController = ChromaticsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ChromaticsCoordinator: ChromaticsViewModelDelegate {
    func didUpdateColorPalette(_ colorPalette: [ColorModel]) {
        
    }
}
