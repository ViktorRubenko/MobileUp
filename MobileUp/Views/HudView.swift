//
//  HudView.swift
//  MobileUp
//
//  Created by Victor Rubenko on 29.03.2022.
//

import UIKit

class HudView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    class func instanceFromNib() -> HudView {
        return UINib(nibName: "HudView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HudView
    }
    
    func run(inView: UIView) {
        configure(inView: inView)
        show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.hide()
        }
    }
    
    private func configure(inView view: UIView) {
        frame = view.bounds
        infoLabel.text = NSLocalizedString("Saved", comment: "Save hud label.")
        
        view.addSubview(self)
        view.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.layer.cornerRadius = backgroundView.bounds.width * 0.05
    }
    
    func show() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
    }
    
    func hide() {
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }
}
