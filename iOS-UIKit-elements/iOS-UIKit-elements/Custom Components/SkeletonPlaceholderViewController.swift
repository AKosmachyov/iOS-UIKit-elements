//
//  SkeletonPlaceholder.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 30.03.23.
//

import Foundation
import UIKit

class SkeletonPlaceholderViewController: UIViewController {
    
    private let skeleton1 = SkeletonView(configuration: .init(direction: .leftRight))
    private let skeleton2 = SkeletonView(configuration: .init(direction: .topBottom))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [skeleton1, skeleton2].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            skeleton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            skeleton1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            skeleton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            skeleton1.heightAnchor.constraint(equalToConstant: 200),
            
            skeleton2.leadingAnchor.constraint(equalTo: skeleton1.leadingAnchor),
            skeleton2.topAnchor.constraint(equalTo: skeleton1.bottomAnchor, constant: 20),
            skeleton2.trailingAnchor.constraint(equalTo: skeleton1.trailingAnchor),
            skeleton2.heightAnchor.constraint(equalTo: skeleton1.heightAnchor),
        ])
    }
}

fileprivate class SkeletonView: UIView {
    let animationLayer = CAGradientLayer()
    var configuration = Configuration()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationLayer.frame = bounds
    }
    
    func setup() {
        layer.addSublayer(animationLayer)
        backgroundColor = .clear
        
        let colors = configuration.baseColor.makeGradient()
        animationLayer.colors = colors.map { $0.cgColor }
        animationLayer.backgroundColor = colors.first?.resolvedColor(with: traitCollection).cgColor
        
        let animation = makeSlidingAnimation(withDirection: configuration.direction)
        animationLayer.add(animation, forKey: "locations")
    }
    
    func makeSlidingAnimation(withDirection direction: GradientDirection,
                              duration: CFTimeInterval = 1.5,
                              autoreverses: Bool = false) -> CAAnimation {
        let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnimation.fromValue = direction.startPoint.from
        startPointAnimation.toValue = direction.startPoint.to
        
        let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnimation.fromValue = direction.endPoint.from
        endPointAnimation.toValue = direction.endPoint.to
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = duration
        animationGroup.timingFunction = .init(name: .easeIn)
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = autoreverses
        animationGroup.isRemovedOnCompletion = false
        
        return animationGroup
    }
    
    struct Configuration {
        var direction: GradientDirection = .leftRight
        var baseColor: UIColor = .lightGray
    }
}

fileprivate enum GradientDirection {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    
    typealias GradientAnimationPoint = (from: CGPoint, to: CGPoint)
    
    var startPoint: GradientAnimationPoint {
        switch self {
        case .leftRight:
            return (from: CGPoint(x: -1, y: 0.5), to: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (from: CGPoint(x: 1, y: 0.5), to: CGPoint(x: -1, y: 0.5))
        case .topBottom:
            return (from: CGPoint(x: 0.5, y: -1), to: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (from: CGPoint(x: 0.5, y: 1), to: CGPoint(x: 0.5, y: -1))
        case .topLeftBottomRight:
            return (from: CGPoint(x: -1, y: -1), to: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (from: CGPoint(x: 1, y: 1), to: CGPoint(x: -1, y: -1))
        }
    }
    
    var endPoint: GradientAnimationPoint {
        switch self {
        case .leftRight:
            return (from: CGPoint(x: 0, y: 0.5), to: CGPoint(x: 2, y: 0.5))
        case .rightLeft:
            return ( from: CGPoint(x: 2, y: 0.5), to: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return ( from: CGPoint(x: 0.5, y: 0), to: CGPoint(x: 0.5, y: 2))
        case .bottomTop:
            return ( from: CGPoint(x: 0.5, y: 2), to: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return ( from: CGPoint(x: 0, y: 0), to: CGPoint(x: 2, y: 2))
        case .bottomRightTopLeft:
            return ( from: CGPoint(x: 2, y: 2), to: CGPoint(x: 0, y: 0))
        }
    }
}

extension UIColor {
    static var clouds     = UIColor(0xecf0f1)
    static var darkClouds = UIColor(0x1c2325)
    
    static var skeletonDefault: UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .darkClouds
                default:
                    return .clouds
                }
            }
        } else {
            return .clouds
        }
    }
    
    var complementaryColor: UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return UIColor { _ in
                self.isLight ? self.darker : self.lighter
            }
        } else {
            return isLight ? darker : lighter
        }
    }
    
    var lighter: UIColor {
        adjust(by: 1.35)
    }
    
    var darker: UIColor {
        adjust(by: 0.94)
    }
}

extension UIColor {
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var isLight: Bool {
        guard let components = cgColor.components,
              components.count >= 3 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return !(brightness < 0.5)
    }
    
    func adjust(by percent: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
    }
    
    func makeGradient() -> [UIColor] {
        [self, self.complementaryColor, self]
    }
}
