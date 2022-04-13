//
//  TextFieldController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 11.03.22.
//

import UIKit

class TextFieldController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Text Field"
        
        
        let textField = UITextField()
        textField.delegate = self
    }    

}

extension TextFieldController: UITextFieldDelegate {
    
}
