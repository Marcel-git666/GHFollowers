This iOS app uses GitHub API to show followers of a user as well as some user info.
Also makes OAuth 2.0 call and allows you to follow a user.

It is made as UIKit application, but also show how to use SwiftUI view. 

If you wish to try, you need to create config.plist with similiar content:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>GitHubClientID</key>
        <string>yourID</string>
        <key>GitHubClientSecret</key>
        <string>Your secret</string>
</dict>
</plist>
```

App is originally made by Sean Allan, but I have changed it quite a lot. 
https://seanallen.teachable.com/courses/enrolled/681906

Also OAuth 2.0 is made by Iacopo Pazzaglia
https://medium.com/swlh/how-to-build-an-ios-app-with-oauth2-authentication-flow-github-example-part-1-ca4be718d5c4
