//
//  DeepLinkTest.swift
//  GHFollowersTests
//
//  Created by Marcel Mravec on 09.02.2024.
//

import Foundation
import XCTest
@testable import GHFollowers

class DeepLinkTest: XCTestCase {
    func test_oAuthUrl_createDeepLink() {
        let url = URL(string: "\(GitHub.redirectURI)?code=aCode")!

        let deepLink = DeepLink(url: url)

        XCTAssertNotNil(deepLink)
    }

    func test_unknownUrl_notCreateDeepLink() {
        let url = URL(string: "cz.marcel.ghfollowers://notKnownPath")!

        let deepLink = DeepLink(url: url)

        XCTAssertNil(deepLink)
    }

    func test_deepLinkHandler_executeCallback_forOauthDeepLink_ifAdded() {
        var receivedDeeplink: DeepLink?

        let expect = expectation(description: "Wait promise fulfill")
        let deepLink = DeepLink(url: URL(string: GitHub.redirectURI)!)
        let deepLinkHandler = DeepLinkHandler()
        let callback: (DeepLink) -> Void = { deepLink in
            receivedDeeplink = deepLink
            expect.fulfill()
        }

        deepLinkHandler.addCallback(callback, forDeepLink: deepLink!)
        let actualDeepLink = DeepLink(url: URL(string: "\(GitHub.redirectURI)?code=code&state=state")!)
        deepLinkHandler.handleDeepLinkIfPossible(deepLink: actualDeepLink!)

        wait(for: [expect], timeout: 0.5)
        XCTAssertEqual(actualDeepLink, receivedDeeplink)
    }
}
