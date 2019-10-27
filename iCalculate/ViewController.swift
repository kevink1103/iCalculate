//
//  ViewController.swift
//  iCalculate
//
//  Created by Kevin Kim on 5/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    let equation = Equation()
    
    @IBOutlet var fieldView: UIView!
    @IBOutlet var padView: UIView!
    @IBOutlet var inputField: UITextField!
    @IBOutlet var realtimeField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // No Keyboard Popup
        inputField.inputView = UIView()
        
        // No Navigation Bar Shadow
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Long Press
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(clipboard))
        self.fieldView.addGestureRecognizer(longPress)
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clear))
        doubleTap.numberOfTapsRequired = 2
        self.fieldView.addGestureRecognizer(doubleTap)
    }

    // MARK: Helper
    func updateFields() -> Void {
        equation.updateString(inputField.text!)
        realtimeField.text = equation.calculate()
    }
    
    // MARK: Core Data
    func saveRecord(_ data: String) -> Bool {
        let record = Record(context: CoreDataManager.context)
        record.equation = data
        record.timestamp = Date()
        
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
            print("\(error)")
            return false
        }
        return true
    }
    
    // MARK: Gesture Actions
    @objc func clipboard(sender: UITapGestureRecognizer) {
        let result: String  = equation.export()
        
        if result.count > 0 {
            UIPasteboard.general.string = result
            let alert = UIAlertController(title: "Copy Successful", message: "Copied to clipboard.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please input something.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func clear(sender: UITapGestureRecognizer) {
        inputField.text = ""
        updateFields()
        realtimeField.text = "iCalculate"
    }
    
    // MARK: Button Actions
    @IBAction func manualPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "User Manual",
                                      message: "Double-tap: CLEAR ALL equation\nLong-press: COPY equation",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postfixPressed(_ sender: UIBarButtonItem) {
        let postfix = equation.postfixEquation().joined(separator: " ")
        let alert = UIAlertController(title: "Postfix Equation",
                                      message: "\(postfix)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func delPressed(_ sender: UIButton) {
        inputField.deleteBackward()
        updateFields()
    }
    
    @IBAction func equalPressed(_ sender: UIButton) {
        let result: String = equation.calculate()
        if result.count > 0 {
            if saveRecord(equation.export()) {
                inputField.text = result
                updateFields()
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let content: String = sender.titleLabel!.text!
        inputField.insertText(content)
        updateFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputField.resignFirstResponder()
    }
}
