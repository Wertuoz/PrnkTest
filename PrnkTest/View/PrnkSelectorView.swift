//
//  PrnkSelectorView.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit
import DLRadioButton

/// Protocol to communicate with delegate
protocol PrnkSelectorViewdelegate: class {
    func radioButtonSelected(id: Int, text: String)
}

/// Control with selectors
class PrnkSelectorView: UIView {
    
    private var radioGroup: DLRadioButton?
    private var stackView: UIStackView?
    public weak var delegate: PrnkSelectorViewdelegate?
    
    required init(withFrame: CGRect) {
        super.init(frame: withFrame)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View initialize
    
    private func setupView() {
        stackView = UIStackView()
        stackView?.axis = .vertical
        stackView?.alignment = .center
        stackView?.distribution = .fill
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView!)
    }
    
    private func setupLayout() {
        stackView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 22, weight: .medium);
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: []);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.isMultipleSelectionEnabled = false
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(logSelectedButton), for: UIControl.Event.touchUpInside);

        return radioButton;
    }
    
    @objc private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                delegate?.radioButtonSelected(id: button.tag, text: button.titleLabel!.text!)
            }
        } else {
            delegate?.radioButtonSelected(id: radioButton.tag, text: radioButton.titleLabel!.text!)
        }
    }
}

/// Protocol to communicate with viewcontroller
extension PrnkSelectorView: PrnkViewWithData {
    func updateData(data: NamedData) {
        radioGroup = nil
        stackView?.removeAllSubView()
        
        var btns = [DLRadioButton]()
        guard let variants = data.getVariants() else {
            return
        }
        
        guard let selectedId = data.getSelectedId() else {
            return
        }
        
        for option in variants {
            let btn = createRadioButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40), title: option.text, color: UIColor.black)
            if selectedId == option.id {
                btn.isSelected = true
            }
            btn.tag = option.id
            btn.widthAnchor.constraint(equalToConstant: btn.frame.width).isActive = true
            btn.heightAnchor.constraint(equalToConstant: btn.frame.height).isActive = true
            
            btns.append(btn)
            stackView?.addArrangedSubview(btn)
            if radioGroup == nil {
                radioGroup = btn
            } else {
                radioGroup?.otherButtons.append(btn)
            }
        }
    }
}
