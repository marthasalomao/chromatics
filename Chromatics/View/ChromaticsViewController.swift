
import UIKit
import SnapKit

class ChromaticsViewController: UIViewController {
    private let viewModel: ChromaticsViewModel
    private var colorRectangles: [UIView] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chromatic"
        label.textAlignment = .left
        label.font = UIFont.AvenirNextLTProIt(size: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "colors generator"
        label.textAlignment = .left
        label.font = UIFont.avenirNextLTProBold(size: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var generatePaletteButton: UIButton = {
        let button = UIButton()
        button.setTitle("new palette", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.avenirNextLTProBold(size: 22)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.09)
        button.addTarget(self, action: #selector(generatePalette), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: ChromaticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        viewModel.delegate = self
        generatePalette()
    }
    
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(generatePaletteButton)
        
        // Add rectangles
        for _ in 0..<5 {
            let rectangle = UIView()
            rectangle.backgroundColor = .lightGray
            rectangle.layer.cornerRadius = 10
            colorRectangles.append(rectangle)
            view.addSubview(rectangle)
        }
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(30)
            $0.leading.equalTo(40)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(40)
        }
        
        generatePaletteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(90)
            $0.bottomMargin.equalToSuperview().inset(100)
        }
        
        // Add constraints for the rectangles
        for (index, rectangle) in colorRectangles.enumerated() {
            rectangle.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(90)
                
                if index > 0 {
                    make.top.equalTo(colorRectangles[index - 1].snp.bottom).offset(-10)
                } else {
                    make.top.equalTo(titleLabel.snp.bottom).offset(100)
                }
            }
        }
    }
    
    @objc func generatePalette() {
        viewModel.generateColorPalette()
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
}

extension ChromaticsViewController: ChromaticsViewModelDelegate {
    func didUpdateColorPalette(_ colorPalette: [ColorModel]) {
        updateBackgroundGradient(colorPalette: colorPalette)
        updateColorRectangles(colorPalette)
        addColorNameLabels(colorPalette)
    }
    
    private func updateColorRectangles(_ colorPalette: [ColorModel]) {
        for (index, rectangle) in colorRectangles.enumerated() {
            guard index < colorPalette.count else {
                // Handle the case where there are not enough colors in the palette
                return
            }
            let colorModel = colorPalette[index]
            rectangle.backgroundColor = UIColor(hexString: colorModel.hex)
        }
    }
    
    private func addColorNameLabels(_ colorPalette: [ColorModel]) {
        for (index, rectangle) in colorRectangles.enumerated() {
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
    
    func updateBackgroundGradient(colorPalette: [ColorModel]) {
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
}
