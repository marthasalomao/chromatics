
import Foundation

protocol ChromaticsViewModelDelegate: AnyObject {
    func didUpdateColorPalette(_ colorPalette: [ColorModel])
}

class ChromaticsViewModel {
    weak var delegate: ChromaticsViewModelDelegate?
    private let colorService: ColorServiceProtocol
    
    init(colorService: ColorServiceProtocol) {
        self.colorService = colorService
    }
    
    func generateColorPalette() {
        colorService.generateColorPalette { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let colorPalette):
                DispatchQueue.main.async {
                    self.delegate?.didUpdateColorPalette(colorPalette)
                }
            case .failure(let error):
                print("Error generating color palette: \(error)")
            }
        }
    }
}
