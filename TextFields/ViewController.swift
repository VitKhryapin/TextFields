//
//  ViewController.swift
//  TextFields
//
//  Created by Vitaly Khryapin on 29.11.2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var excludeNumberTF: UITextField!
    @IBOutlet weak var inputLimitTF: UITextField!
    @IBOutlet weak var counterCharacterLabel: UILabel!
    @IBOutlet weak var maskTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var minLengthLabel: UILabel!
    @IBOutlet weak var minNumbersLabel: UILabel!
    @IBOutlet weak var minLowercaseLabel: UILabel!
    @IBOutlet weak var minUppercaseLabel: UILabel!
    @IBOutlet weak var progressOutlet: UIProgressView!
    @IBOutlet weak var backgroundSV: UIScrollView!
    
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressOutlet.progressViewStyle = UIProgressView.Style.bar
        passwordTF.isSecureTextEntry = true
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        initializeHideKeyboard()
        identifier()
        
    }
    
    func identifier () {
        excludeNumberTF.accessibilityIdentifier = "excludeNumberTF"
        inputLimitTF.accessibilityIdentifier = "inputLimitTF"
        counterCharacterLabel.accessibilityIdentifier = "counterCharacterLabel"
        maskTF.accessibilityIdentifier = "maskTF"
        linkTF.accessibilityIdentifier = "linkTF"
        passwordTF.accessibilityIdentifier = "passwordTF"
        minLengthLabel.accessibilityIdentifier = "minLengthLabel"
        minNumbersLabel.accessibilityIdentifier = "minNumbersLabel"
        minLowercaseLabel.accessibilityIdentifier = "minLowercaseLabel"
        minUppercaseLabel.accessibilityIdentifier = "minUppercaseLabel"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func redTextAndBorder() {
        counterCharacterLabel.textColor = UIColor.red
        inputLimitTF.borderStyle = .none
        inputLimitTF.borderStyle = .roundedRect
        inputLimitTF.layer.borderWidth = 1
        inputLimitTF.layer.cornerRadius = 5
        inputLimitTF.layer.borderColor = UIColor.red.cgColor
    }
    
    func defaultTextAndBorder() {
        counterCharacterLabel.textColor = UIColor.gray
        inputLimitTF.borderStyle = .none
        inputLimitTF.layer.borderWidth = 0
        inputLimitTF.borderStyle = .roundedRect
    }
    
    func redTextTF () {
        if let string: String = inputLimitTF.text {
            let redText = String(Array(string)[10...])
            let blackText = String(Array(string)[...9])
            let range = (string as NSString).range(of: redText, options: .backwards)
            let range2 = (string as NSString).range(of: blackText, options: .backwards)
            let attributedString = NSMutableAttributedString(string:string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range2)
            self.inputLimitTF.attributedText = attributedString
        }
        
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(jumpSafary), userInfo: nil, repeats: false)
    }
    
    @objc func jumpSafary () {
        if let webSite: String = linkTF.text {
            guard let url = URL(string: "\(webSite)") else { return }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    
    
    func progressPassword (progress: Int)  {
        if progress == 0 {
            progressOutlet.progress = 0
        } else if progress ==  1 {
            progressOutlet.progress = 0.25
            progressOutlet.tintColor = .systemRed
        } else if progress == 2 {
            progressOutlet.progress = 0.5
            progressOutlet.tintColor = .systemOrange
        } else if progress == 3 {
            progressOutlet.progress = 0.75
            progressOutlet.tintColor = .systemYellow
        } else if progress == 4 {
            progressOutlet.progress = 1.0
            progressOutlet.tintColor = .systemGreen
        }
    }
    
    func checkPassword () -> Int {
        var progress = 0
        if let password: String = passwordTF.text {
            if password.count > 7 {
                minLengthLabel.text = "✓ min length 8 characters."
                minLengthLabel.textColor = .systemGreen
                progress += 1
            } else {
                minLengthLabel.text = "- min length 8 characters."
                minLengthLabel.textColor = .black
            }
            
            if password.rangeOfCharacter(from:CharacterSet.decimalDigits) != nil {
                minNumbersLabel.text = "✓ min 1 digit."
                minNumbersLabel.textColor = .systemGreen
                progress += 1
            } else {
                minNumbersLabel.text = "- min 1 digit."
                minNumbersLabel.textColor = .black
            }
            
            if password.rangeOfCharacter(from:CharacterSet.lowercaseLetters) != nil {
                minLowercaseLabel.text = "✓ min 1 lowercased."
                minLowercaseLabel.textColor = .systemGreen
                progress += 1
            } else {
                minLowercaseLabel.text = "- min 1 lowercased."
                minLowercaseLabel.textColor = .black
            }
            
            if password.rangeOfCharacter(from:CharacterSet.uppercaseLetters) != nil  {
                minUppercaseLabel.text = "✓ min 1 uppercased."
                minUppercaseLabel.textColor = .systemGreen
                progress += 1
            } else {
                minUppercaseLabel.text = "- min 1 uppercased."
                minUppercaseLabel.textColor = .black
            }
        }
        return progress
    }
    
    func format () {
        if let lastSymbol = maskTF.text?.last {
            if lastSymbol != "-" {
                if maskTF.text?.contains("-") == false {
                    if !lastSymbol.isLetter {
                        maskTF.text?.removeLast()
                    }
                } else if !lastSymbol.isNumber {
                    maskTF.text?.removeLast()
                }
            }
        }
        
    }
    
    func chekFormat () {
        var resultString = ""
        if let string: String = maskTF.text {
            for i in string {
                if i == "-" && !resultString.contains("-"){
                    resultString.append(i)
                }
                if !resultString.contains("-") {
                    if i.isLetter {
                        resultString.append(i)
                    }
                }
                if resultString.contains("-") {
                    if i.isNumber {
                        resultString.append(i)
                    }
                }
            }
        }
        maskTF.text = resultString
    }
    
    
    
    @IBAction func changedExcludeNumberTF(_ sender: UITextField) {
        if let lastSymbol = sender.text?.last {
            if lastSymbol.isNumber {
                sender.text?.removeLast()
            }
        }
        if let text = sender.text {
            sender.text = text.filter{!$0.isNumber}
        }
    }
    
    @IBAction func changedLimitSymbolsTF(_ sender: UITextField) {
        
        if  inputLimitTF.text?.count != nil  {
            counterCharacterLabel.text = "\(10 - Int(inputLimitTF.text!.count))"
        }
        
        if Int(inputLimitTF.text!.count) > 10 {
            inputLimitTF.textColor = .black
            redTextAndBorder()
            redTextTF()
        } else {
            defaultTextAndBorder()
            inputLimitTF.textColor = .black
        }
    }
    
    @IBAction func defaultTextInTF(_ sender: UITextField) {
        linkTF.text = "https://"
    }
    
    @IBAction func maskChanged(_ sender: UITextField) {
        format()
        chekFormat ()
    }
    
    
    @IBAction func webChangedTF(_ sender: UITextField) {
        
        if let webSite: String = linkTF.text {
            if webSite.hasPrefix("https://") || webSite.hasPrefix("http://") {
                
            } else
            if webSite.contains(".") {
                linkTF.text = "https://\(webSite)"
            } else if linkTF.text!.count < 8  {
                linkTF.text = "https://"
            }
        }
        
        DispatchQueue.main.async{
            let newPosition = self.linkTF.endOfDocument
            self.linkTF.selectedTextRange = self.linkTF.textRange(from: newPosition, to: newPosition)
        }
        
        if  linkTF.text!.count > 8 {
            startTimer()
        } else {
            timer?.invalidate()
        }
    }
    
    
    @IBAction func passwordChangedTF(_ sender: UITextField) {
        progressPassword(progress: checkPassword())
    }
}



extension ViewController {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        if let scrollView = backgroundSV, let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}





