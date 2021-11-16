//
//  ExDashLine.swift
//  Alamofire
//
//  Created by 周玉震 on 2021/10/14.
//

import UIKit

public class ExDashLine: UIView {
    
    private let dashLine: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable var lineColor: UIColor = UIColor.gray
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var linePhase: CGFloat = 2
    var linePattern: [NSNumber] = [1, 1]

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initViews()
    }
    
    private func initViews() {
        self.backgroundColor = .clear
        self.layer.addSublayer(dashLine)
        dashLine.strokeColor = lineColor.cgColor
        dashLine.lineWidth = lineWidth
        dashLine.lineJoin = .round
        dashLine.lineDashPattern = linePattern
        dashLine.lineDashPhase = linePhase
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath()
        if self.bounds.width > self.bounds.height {
            path.move(to: CGPoint(x: 0, y: self.bounds.height / 2))
            path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2))
        } else {
            path.move(to: CGPoint(x: self.bounds.width / 2, y: 0))
            path.addLine(to: CGPoint(x: self.bounds.width / 2, y: self.bounds.height))
        }
        dashLine.path = path.cgPath
    }
}
