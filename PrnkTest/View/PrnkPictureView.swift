//
//  PrnkPictureView.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

/// Protocol to communicate with delegate
protocol PrnkPictureViewDelegate: class {
    func pictureViewTapped(text: String, url: String)
}

/// Control with picture and text
class PrnkPictureView: UIView {
    private let picture = UIImageView()
    private let textLabel = UILabel()
    
    private var text: String?
    private var url: String?
    public weak var delegate: PrnkPictureViewDelegate?
    
    let imageSize: CGFloat = 100
    
    required init(withFrame: CGRect) {
        super.init(frame: withFrame)
        setupView()
        setupLayout()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadImage(url: String) {
        picture.loadImage(fromUrl: url)
    }
    
    // MARK: View initialize
    
    private func setupView() {
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picture)
        
        textLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
    }
    
    private func setupLayout() {
        picture.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -imageSize / 4).isActive = true
        picture.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        picture.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        picture.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: picture.bottomAnchor).isActive = true
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
        delegate?.pictureViewTapped(text: text ?? "", url: url ?? "")
    }
}

/// Protocol to communicate with viewcontroller
extension PrnkPictureView: PrnkViewWithData {
    func updateData(data: NamedData) {
        self.text = data.getText()
        self.url = data.getUrl()
        textLabel.text = text
        loadImage(url: url!)
    }
}



