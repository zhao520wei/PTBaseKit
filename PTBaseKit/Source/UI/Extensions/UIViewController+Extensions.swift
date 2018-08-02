
//  UIViewController+Extensions.swift
//  AugenClient
//
//  Created by Seal on 16/7/9.
//  Copyright © 2016年 augen. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SnapKit


private var hub: MBProgressHUD?

private var loadingRefCount = 0


extension UIViewController {
    
    public func showToast(_ text: String, duration: TimeInterval = 3 , completeBlock:(()->())? = nil) {
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .text;
        hub.label.text = text
        hub.label.numberOfLines = 0
        hub.completionBlock = completeBlock
        hub.hide(animated: true, afterDelay: duration)
    }
    
    public func removeLoading() {
        loadingRefCount = 0
        hub?.hide(animated: true)
        hub = nil
    }
    
    public func showLoading() {
        loadingRefCount += 1
        if hub == nil {
            hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    public func hideLoading() {
        if hub == nil {
            return
        }
        loadingRefCount -= 1
        if loadingRefCount <= 0 {
            hub?.hide(animated: true)
            hub = nil
        }
    }
}

// MARK: - alert
extension UIViewController{
    
    public func presentAlert(title: String ,message: String, force: Bool = false, warning: Bool = false, confirmTitle: String = BaseUIKitResource.alertConfirmTitle, confirmAction: (()->())? = nil) -> UIAlertController {
        var controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if (UIDevice.current.userInterfaceIdiom != .phone){
            controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let popover = controller.popoverPresentationController
            if (popover != nil){
                popover?.sourceView = self.view
                popover?.sourceRect = CGRect.init(x: kScreenWidth/2, y: kScreenHeight/2, width: 0, height: 0)
                popover?.permittedArrowDirections = UIPopoverArrowDirection.down
            }
        }
        let confirmAction = UIAlertAction(title: confirmTitle, style: warning ? .destructive : .default) { (_) in
            confirmAction?()
        }
        if !force {
            controller.addAction(UIAlertAction(title: BaseUIKitResource.alertCancelTitle, style: UIAlertActionStyle.cancel, handler: nil))
        }
        
        !warning ? confirmAction.setValue(UIColor.tk.main, forKey: "_titleTextColor") : nil
        
        controller.addAction(confirmAction)
        
        self.present(controller, animated: true, completion: nil)
        
        return controller
    }
}

//extension UIViewController {
//    open override class func initialize() {
//        guard self === UIViewController.self else {
//            return
//        }
//        
//        // if using swift3.0+
//        let dispatchOnce: Void = {
//            replaceViewWillAppear()
//        }()
//        _ = dispatchOnce
//    }
//    
//    // 替换系统的 ViewWillAppear
//    private class func replaceViewWillAppear() {
//        let originSel = #selector(UIViewController.viewWillAppear(_:))
//        let swizzlSel = #selector(UIViewController.cgy_viewWillAppear(_:))
//        
//        let originMethod = class_getInstanceMethod(self, originSel)
//        let swizzlMethod = class_getInstanceMethod(self, swizzlSel)
//        
//        let addMethod = class_addMethod(self, originSel,
//                                        method_getImplementation(swizzlMethod),
//                                        method_getTypeEncoding(swizzlMethod))
//        
//        if addMethod {
//            class_replaceMethod(self, swizzlSel,
//                                method_getImplementation(originMethod),
//                                method_getTypeEncoding(originMethod))
//        } else {
//            method_exchangeImplementations(originMethod, swizzlMethod)
//        }
//    }
//    
//    func cgy_viewWillAppear(_ animated: Bool) {
//        self.cgy_viewWillAppear(animated)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
//                                                                style: .plain,
//                                                                target: nil,
//                                                                action: nil)
//        
//        
//    }
//}
