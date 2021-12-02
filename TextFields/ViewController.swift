//
//  ViewController.swift
//  TextFields
//
//  Created by Vitaly Khryapin on 29.11.2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maskTF.delegate = self
        progressOutlet.progressViewStyle = UIProgressView.Style.bar
        passwordTF.isSecureTextEntry = true
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
            let range = (string as NSString).range(of: redText, options: .backwards)
            let attributedString = NSMutableAttributedString(string:string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            self.inputLimitTF.attributedText = attributedString
        }
    }
    
    func jumpSafary () {
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
    
    func format(with mask: String, inputSymbols: String) -> String {
        var result = ""
        var index = inputSymbols.startIndex
        for symbolMask in mask where index < inputSymbols.endIndex {
            if symbolMask == "X" && inputSymbols[index].isLetter {
                result.append(inputSymbols[index])
                index = inputSymbols.index(after: index)
            } else if symbolMask == "d" && inputSymbols[index].isNumber {
                result.append(inputSymbols[index])
                index = inputSymbols.index(after: index)
            } else if symbolMask == "-" {
                result.append(symbolMask)
            } else {
                index = inputSymbols.index(after: index)
            }
        }
        return result
    }
    
   
    
    @IBAction func changedExcludeNumberTF(_ sender: UITextField) {
        if let lastSymbol = sender.text?.last {
            if lastSymbol.isNumber {
                sender.text?.removeLast()
            }
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
        linkTF.text = "http://"
    }
    
    @IBAction func webChangedTF(_ sender: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [self] in
            jumpSafary()
        })
    }
    
    
    @IBAction func passwordChangedTF(_ sender: UITextField) {
        progressPassword(progress: checkPassword())
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = maskTF.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        maskTF.text = format(with: "XXXXX-dddddd", inputSymbols: newString)
        return false
    }
}







