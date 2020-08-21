//
//  CharactersRepositoryTest.swift
//  JustHeroesTests
//
//  Created by Daniel Mendez on 8/21/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import XCTest
@testable import JustHeroes

struct CharactersRepositoryMapperMock: CharactersRepositoryMapper {
    func map<T>(fromObject object: T) -> [JHCharacter] where T : Decodable, T : Encodable {
        return []
    }
}

class CharactersRepositoryTest: XCTestCase {

    var sut: CharactersRepository<MarvelDataSource>!
    
    override func setUpWithError() throws {
        let api = try! BaseAPI(baseURL: MarvelDataSource.baseURL, session: .init(configuration: .default))
        let dataSource = MarvelDataSource(api: api)
        sut = CharactersRepository(pageSize: 20, dataSource: dataSource, mapper: CharactersRepositoryMapperMock())
    }

    func testExample() throws {
        let expect = expectation(description: "api call")

        self.measure {
            sut.fetchCharacters(atPage: 1) { (result) in
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: .pi)
    }

}
