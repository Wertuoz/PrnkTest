//
//  ViewController.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 31/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

/// Available controlls types
enum ViewType: String {
    case text = "hz"
    case pic = "picture"
    case selector = "selector"
}

/// Protocol to communicate with views
protocol PrnkViewWithData {
    func updateData(data: NamedData)
    init(withFrame: CGRect)
}

/// Class to catch touch events from subviews of containerview
class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
}

class PrnkViewController: UIViewController {
    
    @IBOutlet weak var showNextBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    private let presenter = PrnkViewPresenter(service: PrnkViewService())
    private var dataToDisplay: ViewListData?
    private var currentViewIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        activityIndicator.hidesWhenStopped = true
        presenter.fetchData()
    }
    
    // MARK: Presenter's callbacks to call
    
    private func updateView() {
        guard let data = dataToDisplay else {
            return
        }
        containerView.removeAllSubView()
        presenter.getCurrentViewData(index: currentViewIndex, data: data)
    }
    
    private func updateViewWithData(data: NamedData) {
        guard let viewWithData = getViewByType(viewType: data.name) else {
            return
        }
        containerView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        containerView.addView(viewWithData as! UIView)
        viewWithData.updateData(data: data)
    }
    
    /// MARK: Helpers
    
    @IBAction func onNextViewClick(_ sender: Any) {
        currentViewIndex += 1
        updateView()
        guard let data = dataToDisplay else {
            return
        }
        if currentViewIndex >= data.viewSequence.count - 1 {
            currentViewIndex = -1
        }
    }
    
    ///  Fabric method instatiates views by control name
    private func getViewByType(viewType: String) -> PrnkViewWithData? {
        switch viewType {
        case ViewType.text.rawValue:
            let tempView = PrnkTextView(withFrame: view.frame)
            tempView.delegate = self
            return tempView
        case ViewType.pic.rawValue:
            let tempView = PrnkPictureView(withFrame: view.frame)
            tempView.delegate = self
            return tempView
        case ViewType.selector.rawValue:
            let tempView = PrnkSelectorView(withFrame: view.frame)
            tempView.delegate = self
            return tempView
        default:
            return nil
        }
    }
}

// Extension to communicate with presenter
extension PrnkViewController: PrnkControlsView {
    func setCurrentViewData(data: NamedData?) {
        guard let currentData = data else {
            return
        }
        updateViewWithData(data: currentData)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        showNextBtn.isEnabled = false
    }
    
    func finishLoading() {
        activityIndicator.stopAnimating()
        showNextBtn.isEnabled = true
    }
    
    func setViewData(viewListData: ViewListData) {
        self.dataToDisplay = viewListData
        updateView()
    }
    
    func setEmptyData() {
        print("data is empty")
    }
    
    func setErrorFetchData(error: Error) {
        print(error.localizedDescription)
    }
}

/// MARK: Extensions to react on views actions

extension PrnkViewController: PrnkPictureViewDelegate {
    func pictureViewTapped(text: String, url: String) {
        print("Tapped PictureView with text: \(text) and url: \(url)")
    }
}

extension PrnkViewController: PrnkSelectorViewdelegate {
    func radioButtonSelected(id: Int, text: String) {
        print("Tapped SelectorView with id: \(id) and text: \(text)")
    }
}

extension PrnkViewController: PrnkTextViewDelegate {
    func textViewTapped(text: String) {
        print("Tapped TextView with text: \(text)")
    }
}

