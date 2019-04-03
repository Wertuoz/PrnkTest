//
//  PrnkViewPresenter.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

/// Protocol to connect with presenter
protocol PrnkControlsView: class {
    func startLoading()
    func finishLoading()
    func setViewData(viewListData: ViewListData)
    func setEmptyData()
    func setErrorFetchData(error: Error)
    func setCurrentViewData(data: NamedData?)
}

/// Presenter for PrnkViewController
class PrnkViewPresenter {
    private let service: PrnkViewService
    weak fileprivate var controlsView: PrnkControlsView?
    
    init(service: PrnkViewService) {
        self.service = service
    }
    
    /// Attach to call controller
    func attachView(_ view: PrnkControlsView) {
        self.controlsView = view
    }
    
    func detachView() {
        self.controlsView = nil
    }
    
    // MARK: Work with service and data
    
    /// Request data from service
    func fetchData() {
        self.controlsView?.startLoading()
        service.fetchData { [weak self] (viewData, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.controlsView?.setErrorFetchData(error: error!)
                } else {
                    if let fetchedData = viewData {
                        self?.controlsView?.setViewData(viewListData: fetchedData)
                    } else {
                        self?.controlsView?.setEmptyData()
                    }
                }
                self?.controlsView?.finishLoading()
            }
        }
    }
    
    /// get view to represent from data and call viewcontroller(view)
    func getCurrentViewData(index: Int, data: ViewListData) {
        let name = data.viewSequence[index]
        guard let viewType = ViewType(rawValue: name) else {
            return
        }
        
        self.controlsView?.setCurrentViewData(data: getDataByType(viewType: viewType, dataList: data))
    }
    
    /// get active control to go next
    func getDataByType(viewType: ViewType, dataList: ViewListData) -> NamedData? {
        return dataList.getDataByName(name: viewType.rawValue)
    }
}
