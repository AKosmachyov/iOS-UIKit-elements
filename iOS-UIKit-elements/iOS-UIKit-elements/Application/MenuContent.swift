//
//  MenuContent.swift
//  iOS-UIKit-elements
//
//  Created by Alexander Kosmachyov on 30.10.22.
//

import Foundation

class MenuItem: Identifiable, Hashable, Equatable {
    let title: String
    let subItems: [MenuItem]
    let storyboardName: String?
    let storyboardID: String?
    let imageName: String?
    
    init(
        title: String,
        imageName: String?,
        storyboardName: String? = nil,
        storyboardID: String? = nil,
        subItems: [MenuItem] = []
    ) {
        self.title = title
        self.subItems = subItems
        self.storyboardName = storyboardName
        self.storyboardID = storyboardID
        self.imageName = imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class MenuContent {
    lazy var menuItems: [MenuItem] = {
        return [
            formControlMenuItem,
            layoutContainersMenuItem,
            contentViewMenuItem,
            customComponentsMenuItem
        ]
    }()
    
    lazy var formControlMenuItem: MenuItem = {
        let items = [
            MenuItem(title: "UITextField", imageName: nil, storyboardName: nil),
            MenuItem(title: "UITextView", imageName: nil, storyboardName: nil),
            MenuItem(title: "UIButton", imageName: nil, storyboardName: nil),
            MenuItem(title: "UISlider", imageName: nil, storyboardName: nil),
            MenuItem(title: "UISwitch", imageName: nil, storyboardName: nil),
            MenuItem(title: "UIColorWell", imageName: nil, storyboardName: nil),
            MenuItem(title: "UIStepper", imageName: nil, storyboardName: nil),
            MenuItem(title: "UIDatePicker", imageName: nil, storyboardName: nil),
            MenuItem(title: "UIPickerView", imageName: nil, storyboardName: nil),
        ]
        
        return MenuItem(title: "Form Control", imageName: "slider.horizontal.3", subItems: items)
    }()
    
    lazy var layoutContainersMenuItem: MenuItem = {
        let items = [
            MenuItem(title: "UICollectionView", imageName: nil, storyboardName: "Layout Containers", storyboardID: "collectionViewController"),
        ]
        return MenuItem(title: "Layout Containers", imageName: nil, subItems: items)
    }()
    
    lazy var contentViewMenuItem: MenuItem = {
        return MenuItem(title: "Content View", imageName: "globe.desk")
    }()
    
    lazy var customComponentsMenuItem: MenuItem = {
        return MenuItem(title: "Custom Components", imageName: "figure.climbing")
    }()
}
