
import Foundation
import UIKit

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
    
    func updateBackgroundGradient(colorPalette: [ColorModel], onView view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = colorPalette.map { UIColor(hexString: $0.hex)?.cgColor ?? UIColor.lightGray.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        view.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateColorRectangles(colorPalette: [ColorModel], rectangles: [UIView]) {
        for (index, rectangle) in rectangles.enumerated() {
            guard index < colorPalette.count else {
                // Handle the case where there are not enough colors in the palette
                return
            }
            let colorModel = colorPalette[index]
            rectangle.backgroundColor = UIColor(hexString: colorModel.hex)
        }
    }
    
    func addColorNameLabels(colorPalette: [ColorModel], rectangles: [UIView]) {
        for (index, rectangle) in rectangles.enumerated() {
            guard index < colorPalette.count else {
                return
            }
            let colorModel = colorPalette[index]
            
            rectangle.subviews.forEach { $0.removeFromSuperview() }
            
            let nameColorLabel = UILabel()
            nameColorLabel.text = colorModel.name
            nameColorLabel.textColor = .white
            nameColorLabel.font = UIFont.AvenirNextLTProRegular(size: 12)
            nameColorLabel.textAlignment = .center
            rectangle.addSubview(nameColorLabel)
            nameColorLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
