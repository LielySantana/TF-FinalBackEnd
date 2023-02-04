//
//  CustomTabBar.swift
//  EngageCount
//
//  Created by krunal on 10/12/22.
//

import UIKit

class CustomTabBar: UITabBar {
        
     override func awakeFromNib() {
            super.awakeFromNib()
            layer.masksToBounds = true
            layer.cornerRadius = 20
            layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
         
//         self.barStyle = .black
//         let effect = UIVisualEffectView()
//         self.addSubview(effect)
         
         let blurEffect = UIBlurEffect(style: .light) // here you can change blur style
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame = self.bounds
         blurView.autoresizingMask = .flexibleWidth
         self.insertSubview(blurView, at: 0)
         
      }
 }
