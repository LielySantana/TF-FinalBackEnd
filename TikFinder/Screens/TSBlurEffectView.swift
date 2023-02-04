//
//  TSBlurEffectView.swift
//  TikFinder
//
//  Created by Christina Santana on 3/2/23.
//

import Foundation
import UIKit


class TSBlurEffectView: UIVisualEffectView {
    
    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var intensity = 1.0
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = .clear
        frame = superview.bounds
        setupBlur()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil

        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .regular)
        }
        
        if intensity > 0 && intensity <= 10 {
            
            let value = CGFloat(intensity)/10
            animator.fractionComplete = value
            
        }
        else {
            animator.fractionComplete = 0.05
        }
        
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}
