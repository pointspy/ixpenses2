/*
 MIT License
 
 Copyright (c) RxSwiftCommunity
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import RxCocoa
import RxSwift
import UIKit

// MARK: - UIAlertController

public extension UIAlertController {
    func addAction(actions: [AlertAction]) -> Observable<OutputAction> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            actions.forEach { action in
                if let textField = action.textField {
                    self.addTextField { text in
                        text.config(textField)
                    }
                } else {
                    self.addAction(UIAlertAction(title: action.title, style: action.style, handler: { [unowned self] _ in
                        observer.on(.next(OutputAction(index: action.type, textFields: self.textFields)))
                        observer.on(.completed)
                    }))
                }
            }
            return Disposables.create { self.dismiss(animated: true) }
        }
    }
}

// MARK: - UIViewController

public extension UIViewController {
    func alert(title: String?,
               message: String? = nil,
               actions: [AlertAction] = [AlertAction(title: "OK")],
               preferredStyle: UIAlertController.Style = .alert,
               vc: UIViewController? = nil, barButtonItem: UIBarButtonItem? = nil) -> Observable<OutputAction>
    {
        let parentVc = vc ?? self
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let barButton = barButtonItem {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.barButtonItem = barButton
                
            }
        }
        
        return
            alertController
                .addAction(actions: actions)
                .do(onSubscribed: {
                    parentVc.present(alertController, animated: true)
                })
    }
}

// MARK: - UITextField

private extension UITextField {
    func config(_ textField: UITextField) {
        self.text = textField.text
        self.placeholder = textField.placeholder
        self.tag = textField.tag
        self.isSecureTextEntry = textField.isSecureTextEntry
        self.tintColor = textField.tintColor
        self.textColor = textField.textColor
        self.textAlignment = textField.textAlignment
        self.borderStyle = textField.borderStyle
        self.leftView = textField.leftView
        self.leftViewMode = textField.leftViewMode
        self.rightView = textField.rightView
        self.rightViewMode = textField.rightViewMode
        self.background = textField.background
        self.disabledBackground = textField.disabledBackground
        self.clearButtonMode = textField.clearButtonMode
        self.inputView = textField.inputView
        self.inputAccessoryView = textField.inputAccessoryView
        self.clearsOnInsertion = textField.clearsOnInsertion
        self.keyboardType = textField.keyboardType
        self.returnKeyType = textField.returnKeyType
        self.spellCheckingType = textField.spellCheckingType
        self.autocapitalizationType = textField.autocapitalizationType
        self.autocorrectionType = textField.autocorrectionType
        self.keyboardAppearance = textField.keyboardAppearance
        self.enablesReturnKeyAutomatically = textField.enablesReturnKeyAutomatically
        self.delegate = textField.delegate
        self.clearsOnBeginEditing = textField.clearsOnBeginEditing
        self.adjustsFontSizeToFitWidth = textField.adjustsFontSizeToFitWidth
        self.minimumFontSize = textField.minimumFontSize

        if #available(iOS 11.0, *) {
            self.textContentType = textField.textContentType
        }
        
        if #available(iOS 11.0, *) {
            self.smartQuotesType = textField.smartQuotesType
            self.smartDashesType = textField.smartDashesType
            self.smartInsertDeleteType = textField.smartInsertDeleteType
        }

        if #available(iOS 12.0, *) {
            self.passwordRules = textField.passwordRules
        }
    }
}
