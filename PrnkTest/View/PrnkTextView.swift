//
//  TextView.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

/// Protocol to communicate with delegate
protocol PrnkTextViewDelegate: class {
    func textViewTapped(text: String)
}

/// Control to represent text
class PrnkTextView: UIView {
    
    private let textLabel = UILabel()
    private var text: String?
    public weak var delegate: PrnkTextViewDelegate?
    
    required init(withFrame: CGRect) {
        super.init(frame: withFrame)
        setupView()
        setupLayout()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View initialize
    
    private func setupView() {
        isUserInteractionEnabled = true
        textLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
    }
    
    private func setupLayout() {
        textLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    // MARK: Gestures
    
    // Gesture to communicate with delegate
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    // Callback for taprecognizer
    @objc private func handleTap() {
        delegate?.textViewTapped(text: text ?? "")
    }
}

/// Protocol to communicate with viewcontroller
extension PrnkTextView: PrnkViewWithData {
    func updateData(data: NamedData) {
        self.text = data.getText()
        textLabel.text = self.text
    }
}
