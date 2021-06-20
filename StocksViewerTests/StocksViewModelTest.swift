//
//  StocksViewModelTest.swift
//  StocksViewerTests
//
//  Created by Kevin Huang on 19/06/21.
//

import XCTest
@testable import StocksViewer

class SpyDelegate : StocksViewerViewModelDelegate {
    var models: [CryptoModel]?
    var expectation: XCTestExpectation?
    var isShowLoadingIndicatorCalled = false
    var isStopRefreshControlCalled = false
    var alertMessage = ""
    var newsViewModel : NewsViewModel?
    
    func reloadTableWith(models: [CryptoModel]?) {
        guard let expectation = expectation else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }

        self.models = models
        expectation.fulfill()
    }
    
    func presentNewsModelVC(with vm: NewsViewModel) {
        newsViewModel = vm
    }
    
    func showLoadingIndicator(isShow: Bool) {
        isShowLoadingIndicatorCalled = true
    }
    
    func showAlertWith(message: String) {
        alertMessage = message
    }
    
    func stopRefreshControl() {
        isStopRefreshControlCalled = true
    }
}

class StocksViewModelTest: XCTestCase {
    
    var viewModel : StocksViewerViewModel!
    var spyDelegate = SpyDelegate()
    
    override func setUp() {
        viewModel = StocksViewerViewModel()
        spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        spyDelegate = SpyDelegate()
        super.tearDown()
    }
    
    func test_on_view_did_load() throws {
        //Set Expectation
        let expectation = expectation(description: "View did load get not empty models from delegate and websocketmanager delegate should be set properly")
        spyDelegate.expectation = expectation
        
        //Test
        viewModel.onViewDidLoad()
        
        //Assert
        waitForExpectations(timeout: 5) {[weak self] error in
          if let error = error {
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
          }

            guard let strongSelf = self,
                let result = strongSelf.spyDelegate.models else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertGreaterThan(result.count, 0)
            XCTAssert(strongSelf.spyDelegate.isStopRefreshControlCalled)
            XCTAssert(strongSelf.spyDelegate.isShowLoadingIndicatorCalled)
        }
        
        XCTAssertNotNil(WebSocketManager.shared.delegate)
    }
    
    func test_pulled_to_refresh() throws {
        //Set Expectation
        let expectation = expectation(description: "Pulled to refresh should reset models")
        spyDelegate.expectation = expectation
        
        //Test
        viewModel.pulledToRefresh()
        
        //Assert
        waitForExpectations(timeout: 5) {[weak self] error in
          if let error = error {
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
          }

            guard let strongSelf = self,
                let result = strongSelf.spyDelegate.models else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertGreaterThan(result.count, 0)
            XCTAssert(strongSelf.spyDelegate.isStopRefreshControlCalled)
            XCTAssert(strongSelf.spyDelegate.isShowLoadingIndicatorCalled)
        }
        
        XCTAssertNotNil(WebSocketManager.shared.delegate)
    }
    
    func test_cell_tapped_at() throws {
        //Test
        viewModel.cellTapped(at: 0) //Set coin model first
        
        //Assert
        XCTAssertNil(self.spyDelegate.newsViewModel)
    }
}
