//
//  CoreDataTokenRepositoryTests.swift
//  GHFollowersTests
//
//  Created by Marcel Mravec on 13.02.2024.
//

import XCTest
@testable import GHFollowers

class CoreDataTokenRepositoryTests: XCTestCase {

    var sut: CoreDataTokenRepository!

    override func setUp() {
        super.setUp()
        // Initialize the CoreDataTokenRepository instance
        // You may need to set up any necessary dependencies or mock objects here
        sut = CoreDataTokenRepository()
    }

    override func tearDown() {
        // Clean up any resources after each test case is executed
        sut = nil
        super.tearDown()
    }

    func testTokenRetrieval() {
        // Simulate saving a token
        let tokenBag = TokenBag(accessToken: "testAccessToken")
        do {
            try sut.setToken(tokenBag: tokenBag)
        } catch {
            XCTFail("Failed to save token: \(error)")
        }

        // Retrieve the token and verify it matches the expected value
        let retrievedTokenBag = sut.getToken()
        XCTAssertNotNil(retrievedTokenBag)
        XCTAssertEqual(retrievedTokenBag?.accessToken, "testAccessToken")
    }

    func testTokenPersistence() {
        // Create a new token
        let accessToken = "testAccessToken"

        // Save the token
        do {
            try sut.setToken(tokenBag: TokenBag(accessToken: accessToken))
        } catch {
            XCTFail("Failed to save token: \(error)")
        }

        // Retrieve the token and verify its access token matches the saved value
        let retrievedTokenBag = sut.getToken()
        XCTAssertEqual(retrievedTokenBag?.accessToken, accessToken)
    }

    func testTokenReset() {
        // Save a token
        let tokenBag = TokenBag(accessToken: "testAccessToken")
        do {
            try sut.setToken(tokenBag: tokenBag)
        } catch {
            XCTFail("Failed to save token: \(error)")
        }

        // Reset the token
        do {
            try sut.resetToken()
        } catch {
            XCTFail("Failed to reset token: \(error)")
        }

        // Verify that the token is nil after reset
        XCTAssertNil(sut.getToken())
    }

    func testWhenNoTokenSavedThenNoTokenRetrieved() {
        let accessToken: String? = nil
        do {
            try sut.resetToken()
        } catch {
            XCTFail("Failed to save token: \(error)")
        }
        XCTAssertNil(sut.getToken())
    }

}
