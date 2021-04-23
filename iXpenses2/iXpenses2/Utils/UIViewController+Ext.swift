//
//  UIViewController+Ext.swift
//  Shlist
//
//  Created by Pavel Lyskov on 23.04.2020.
//  Copyright © 2020 Pavel Lyskov. All rights reserved.
//

import UIKit

public extension UIViewController {
    func showSimpleAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in })

        alert.addAction(ok)

        present(alert, animated: true, completion: nil)
    }
    
    func showOkCancel(message: String, okButtonTitle: String, successHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: okButtonTitle, style: .default, handler: { _ in
            successHandler()
        })

        alert.addAction(cancelAction)
        alert.addAction(ok)

        present(alert, animated: true, completion: nil)
    }
}

public extension UIViewController {
    var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
    
    /// Get the view of current top UIViewController
    ///
    /// - Returns: The view of UIViewController
    static func dl_topView() -> UIView? {
        return dl_topViewController()?.view
    }
    
    static func dl_topViewController(rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        var topViewController = rootViewController
        var presentedViewController = rootViewController.presentedViewController
        while presentedViewController != nil {
            topViewController = presentedViewController!
            presentedViewController = topViewController.presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            return dl_topViewController(rootViewController: navigationController.topViewController)
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            return dl_topViewController(rootViewController: tabBarController.selectedViewController)
        }
        
        if topViewController.children.count > 0 {
            return dl_topViewController(rootViewController: topViewController.children[0])
        }
        
        return topViewController
    }
    
    static func dl_rootViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        return rootViewController
    }
    
    func dl_hideNavigationBackTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UINavigationController {
    func forceUpdateNavBar() {
        DispatchQueue.main.async {
            self.navigationBar.sizeToFit()
        }
    }
}

extension UINavigationItem.LargeTitleDisplayMode {
    var stringValue: String {
        switch self {
        case .always: return "always"
        case .automatic: return "automatic"
        case .never: return "never"
        @unknown default: fatalError()
        }
    }
}

extension UIViewController {
    
    func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
        switch largeTitleDisplayMode {
        case .automatic:
            guard let navigationController = navigationController else { break }
            if let index = navigationController.children.firstIndex(of: self) {
                setLargeTitleDisplayMode(index == 0 ? .always : .never)
            } else {
                setLargeTitleDisplayMode(.always)
            }
        case .always, .never:
            // Always override to be .never if large title isn't available (contentSizeCategory, device size..)
            navigationItem.largeTitleDisplayMode = isLargeTitleAvailable() ? largeTitleDisplayMode : .never
            // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
            navigationController?.navigationBar.prefersLargeTitles = true
        @unknown default:
            assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
        }
    }
    
    private func isLargeTitleAvailable() -> Bool {
        switch traitCollection.preferredContentSizeCategory {
        case .accessibilityExtraExtraExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraLarge,
             .accessibilityLarge,
             .accessibilityMedium,
             .extraExtraExtraLarge:
            return false
        default:
            /// Exclude 4" screen or 4.7" with zoomed
            return UIScreen.main.bounds.height > 568
        }
    }
}
