import Foundation

protocol ChromaticsViewModelDelegate: AnyObject {
    func didUpdateColorPalette(_ colorPalette: [ColorModel])
}

class ChromaticsViewModel {
    weak var delegate: ChromaticsViewModelDelegate?
    
    private let colorService = ColorService.shared
    
    func generateColorPalette() {
        colorService.generateColorPalette { result in
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
