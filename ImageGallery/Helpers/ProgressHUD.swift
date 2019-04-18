//
//  ProgressHUD.swift
//  ImageGallery
//
//  Created by STL009 on 17/04/19.
//

import Foundation
import MBProgressHUD
final class ProgressHUD {
    
    private static var progressHUD: MBProgressHUD?
    private static var toastHUD: MBProgressHUD?
    static func showProgressHUDOn(view: UIView, with title: String = "") {
        if progressHUD != nil {
            hideProgressHUD()
        }
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.label.text = title
        progressHUD?.bezelView.color = .black
        progressHUD?.label.textColor = .white
        progressHUD?.contentColor = .white
        progressHUD?.isUserInteractionEnabled = false
    }
    
    static func hideProgressHUD() {
        DispatchQueue.main.async {
            progressHUD?.hide(animated: true)
        }
    }
    
    static func showToastHUDOn(view: UIView, test: String) {
        if toastHUD != nil {
            hideToastHUD()
        }
        toastHUD = MBProgressHUD.showAdded(to: view, animated: true)
        toastHUD?.mode = .text
        toastHUD?.bezelView.color = .black
        toastHUD?.label.textColor = .white
        toastHUD?.label.text = test
        toastHUD?.hide(animated: true, afterDelay: 3)
    }
    
    static func hideToastHUD() {
        DispatchQueue.main.async {
            toastHUD?.hide(animated: true)
        }
    }
}
