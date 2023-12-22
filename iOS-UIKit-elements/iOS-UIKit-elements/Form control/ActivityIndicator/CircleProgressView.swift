//
//  CircleProgressView.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 3.05.23.
//

import Foundation
import UIKit

public class CircleProgressView: UIView {
    /// Color of activity indicator view.
    private var color: UIColor
    private var textColor: UIColor
    
    private var circleLayer: CAShapeLayer?
    private var progress: CGFloat = 0
    
    private lazy var progressTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0%"
        label.font = .preferredFont(forTextStyle: .subheadline,
                                    compatibleWith: UITraitCollection(preferredContentSizeCategory: .large))
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, color: UIColor, textColor: UIColor, bgColor: UIColor) {
        self.color = color
        self.textColor = textColor
        super.init(frame: frame)
        self.backgroundColor = bgColor
        addSubview(progressTitle)
        NSLayoutConstraint.activate([
            progressTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressTitle.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    public override var bounds: CGRect {
        didSet {
            // setup the animation again for the new bounds
            if oldValue != bounds && !isHidden {
                setupLayer()
            }
        }
    }
    
    func update(_ progress: Double) {
        self.progress = progress
        if circleLayer == nil {
            setupLayer()
        } else {
            circleLayer?.strokeEnd = progress
        }
        progressTitle.text = String(round(progress * 100)) + "%"
        
        if progress == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.isHidden = true
            }
        }
    }
    
    private func setupLayer() {
        if frame.isEmpty {
            return
        }
        
        let size = min(frame.width, frame.height) / 2
        let circle = layerWith(size: size, color: color, precent: progress)
        let frame = CGRect(x: (layer.bounds.width - size) / 2, y: (layer.bounds.height - size) / 2,
                           width: size, height: size)
        circle.frame = frame
        layer.addSublayer(circle)
        circleLayer = circle
    }
    
    private func layerWith(size: CGFloat, color: UIColor, precent: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.backgroundColor = nil
        layer.path = bezierPath(size: size).cgPath
        layer.strokeStart = 0
        layer.strokeEnd = precent
        layer.lineCap = .round
        layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        return layer
    }
    
    private func bezierPath(size: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size / 2, y: size / 2),
                    radius: size / 2,
                    startAngle: -(.pi / 2),
                    endAngle: 3 * .pi / 2,
                    clockwise: true)
        return path
    }
}
