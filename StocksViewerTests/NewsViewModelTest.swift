//
//  NewsViewModelTest.swift
//  StocksViewerTests
//
//  Created by Kevin Huang on 20/06/21.
//

import XCTest
@testable import StocksViewer

class NewsSpyDelegate : NewsViewModelDelegate {
    var newsModelArray = [CryptoNewsModel]()
    var expectDelegateCalled : XCTestExpectation?
    
    func reloadTableWith(newsModelArray: [CryptoNewsModel]?) {
        guard let expectation = expectDelegateCalled else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        guard let newsModelArray = newsModelArray else {
            XCTFail("News Model Array returned nil")
            return
        }
        self.newsModelArray = newsModelArray
        expectation.fulfill()
    }
}

class NewsViewModelTest: XCTestCase {
    var viewModel : NewsViewModel?
    var newsSpyDelegate : NewsSpyDelegate?
    var dummyNewsModel : [CryptoNewsModel]?
    
    override func setUp() {
        dummyNewsModel = [CryptoNewsModel(title: "title", source_info_name: "source_info_name", body: "body")]
        newsSpyDelegate = NewsSpyDelegate()
        
        guard let dummyNewsModel = dummyNewsModel,
              let newsSpyDelegate = newsSpyDelegate else {
            XCTFail("Expected dummyNewsModel and newsSpyDelegate not to be nil")
            return
        }
        
        viewModel = NewsViewModel(newsModel: dummyNewsModel)
        guard let viewModel = viewModel else {
            XCTFail("Expected viewModel not to be nil")
            return
        }
        viewModel.delegate = newsSpyDelegate
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        newsSpyDelegate = nil
        dummyNewsModel = nil
        super.tearDown()
    }
    
    func test_on_view_did_load() {
        //Set Expectation
        let expectation = expectation(description: "View did load get not empty models from delegate and websocketmanager delegate should be set properly")
        newsSpyDelegate?.expectDelegateCalled = expectation
        
        //Test
        guard let viewModel = viewModel else {
            XCTFail("Expected viewModel not to be nil")
            return
        }
        viewModel.onViewDidLoad()
        
        //Assert
        waitForExpectations(timeout: 0) {[weak self] error in
          if let error = error {
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
          }

            guard let strongSelf = self,
                let newsModelArray = strongSelf.newsSpyDelegate?.newsModelArray else {
                XCTFail("Expected not nil")
                return
            }
            XCTAssertEqual(newsModelArray[0].body, "body")
            XCTAssertEqual(newsModelArray[0].title, "title")
            XCTAssertEqual(newsModelArray[0].source_info_name, "source_info_name")
        }
        
        XCTAssertNotNil(WebSocketeManager.shared.delegate)
    }
}
