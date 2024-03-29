//
//  Constants.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 22.01.2024.
//

import UIKit

enum SFSymbols {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
    static let login = UIImage(systemName: "person.badge.key")
}

enum Images {
    static let ghLogo = UIImage(named: "gh-logo")
    static let placeholderImage = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
    static let followImage = UIImage(resource: .follow)
}

enum GitHub {
    static var clientID: String {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let clientID = configDict["GitHubClientID"] as? String else {
            fatalError("GitHub client ID not found in configuration file.")
        }
        return clientID
    }

    static var clientSecret: String {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let clientSecret = configDict["GitHubClientSecret"] as? String else {
            fatalError("GitHub client secret not found in configuration file.")
        }
        return clientSecret
    }

    static let redirectURI = "cz.marcel.ghfollowers://auth"
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
