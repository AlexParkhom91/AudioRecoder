//
//  ExtentionButton.swift
//  AudioRecorder
//
//  Created by Александр Пархамович on 7.09.22.
//

import Foundation
import Foundation
import UIKit


extension ViewController{
    
    func createNewButton(buttonTitle: String) -> UIButton {
        let newButton = UIButton()
        
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.backgroundColor = .systemGray4
        newButton.layer.cornerRadius = 10
        newButton.layer.opacity = 0.95
        newButton.layer.masksToBounds = false
        newButton.titleLabel?.font = UIFont(name: "Zapfiro", size: 22)
        newButton.setTitle(buttonTitle, for: .normal)
        newButton.setTitleColor(UIColor.orange, for: .normal)
        
        return newButton
        
    }
    
}
