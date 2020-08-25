//
//  CharactersRepositoryTest.swift
//  JustHeroesTests
//
//  Created by Daniel Mendez on 8/21/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import XCTest
@testable import JustHeroes

class CharactersRepositoryTest: XCTestCase {

    var sut: BaseRepository<MarverlCharacterDataSource, MarvelCharacterMapper>!
    
    override func setUpWithError() throws {
        let api = try! BaseAPI(baseURL: MarvelDataSource.baseURL, session: .init(configuration: .default))
        let dataSource = MarverlCharacterDataSource(api: api)
        let mapper = MarvelCharacterMapper()
        sut = BaseRepository(pageSize: 20, dataSource: dataSource, mapper: mapper)
    }

    func testExample() throws {
        let expect = expectation(description: "api call")

        sut.fetch(atPage: 1, sortedBy: .none, withTerm: nil) { (result) in
            let characters = try! result.get()
            let first = characters.first!
            XCTAssertEqual(characters.count, 20)
            XCTAssertNotNil(first.imageURL)
            expect.fulfill()
        }

        wait(for: [expect], timeout: .pi)
    }

}
