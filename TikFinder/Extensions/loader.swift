//
//  loader.swift
//  TikFinder
//
//  Created by Christina Santana on 23/1/23.
//

import Foundation
import UIKit


extension UIViewController {
    func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
    func loaderstr() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
    
        
        func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
}

