//
//  TextFieldController.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 11.03.22.
//

import UIKit

class TextFieldViewController: BaseListViewController {
    
    let cellID = "formItem"
    let searchCellID = "searchCell"
    let customCellID = "customTextFieldCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfiguration = { cellView, model in
            guard let label = cellView.contentView.subviews.first(where: { $0 is UILabel }) as? UILabel else {
                return
            }
            label.text = model.title
        }
        
        tableContent.append(contentsOf: [
            .init(title: "Tinted Title",
                  cellID: cellID,
                  configHandler: configureTintedTextField),
            .init(title: "Secure",
                  cellID: cellID,
                  configHandler: configureSecureTextField),
            .init(title: "Search",
                  cellID: searchCellID,
                  configHandler: configureSearchTextField),
            .init(title: "Specific Keyboard",
                  cellID: cellID,
                  configHandler: configureSpecificKeyboardTextField),
            .init(title: "Custom Text Field",
                  cellID: customCellID,
                  configHandler: configureCustomTextField)
        ])
    }
    
    override func targetView(_ cell: UITableViewCell) -> UIView? {
        return cell.contentView.subviews.first(where: { $0 is UITextField })
    }

    // MARK: - Configuration

    func configureTintedTextField(_ textField: UITextField) {
        textField.tintColor = UIColor.systemBlue
        textField.textColor = UIColor.systemGreen

        textField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        textField.returnKeyType = .done
    }

    func configureSecureTextField(_ textField: UITextField) {
        textField.isSecureTextEntry = true

        textField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        textField.returnKeyType = .done
        textField.clearButtonMode = .always
    }
    
    func configureSearchTextField(_ textField: UISearchTextField) {
        textField.placeholder = NSLocalizedString("Enter search text", comment: "")
        textField.returnKeyType = .done
        textField.clearButtonMode = .always
        textField.allowsDeletingTokens = true
        
        // Setup the left view as a symbol image view.
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor.systemGray
        textField.leftView = searchIcon
        textField.leftViewMode = .always
        
        let secondToken = UISearchToken(icon: UIImage(systemName: "staroflife"), text: "Token 2")
        textField.insertToken(secondToken, at: 0)
        
        let firstToken = UISearchToken(icon: UIImage(systemName: "staroflife.fill"), text: "Token 1")
        textField.insertToken(firstToken, at: 0)
    }

    func configureSpecificKeyboardTextField(_ textField: UITextField) {
        textField.keyboardType = .emailAddress

        textField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        textField.returnKeyType = .done
    }

    func configureCustomTextField(_ textField: UITextField) {
        // Text fields with custom image backgrounds must have no border.
        textField.borderStyle = .none
        textField.background = createImage(size: CGSize(width: 200, height: 60))
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(systemName: "eraser.fill")
        let rightButton = UIButton(configuration: buttonConfiguration)
        rightButton.addTarget(self, action: #selector(customTextFieldButtonClicked), for: .touchUpInside)
        textField.rightView = rightButton
        textField.rightViewMode = .always

        textField.placeholder = NSLocalizedString("Placeholder text", comment: "")
        textField.autocorrectionType = .no
        textField.clearButtonMode = .never
        textField.returnKeyType = .done
    }
    
    // MARK: - Actions
    
    @objc
    func customTextFieldButtonClicked() {
        debugPrint("The custom text field's right button was clicked.")
    }

    func createImage(size: CGSize) -> UIImage? {
        let colorComponents = [#colorLiteral(red: 0.5172183963, green: 0.9686274529, blue: 0.4146369815, alpha: 0.7860527455), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.3388534331), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.3458681778)].compactMap { $0.cgColor.components }.flatMap { $0 }
        let locations: [CGFloat] = [0, 0.4, 0.8]
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(),
                                        colorComponents: colorComponents,
                                        locations: locations,
                                        count: colorComponents.count) else { return nil }
        
        context.drawLinearGradient(gradient,
                                   start: CGPoint.zero,
                                   end: CGPoint(x: size.width, y: size.height),
                                   options: CGGradientDrawingOptions())
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        return UIImage(cgImage: image)
    }

}

// MARK: - UITextFieldDelegate

extension TextFieldViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // User changed the text selection.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Return false to not change text.
        return true
    }
}

// Custom text field for controlling input text placement.
class CustomTextField: UITextField {
    let leftMarginPadding: CGFloat = 50
    let rightMarginPadding: CGFloat = 50
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.origin.x += leftMarginPadding
        rect.size.width -= rightMarginPadding
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.origin.x += leftMarginPadding
        rect.size.width -= rightMarginPadding
        return rect
    }
}
