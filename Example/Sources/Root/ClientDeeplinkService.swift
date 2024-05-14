//
//  ClientDeeplinkService.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 3/18/24.
//

import SwiftUI
import FirebaseDynamicLinks

class ClientDeeplinkService: ObservableObject {
    private enum GenerateDeeplinkError: Error {
        case invalidUrl
    }
    
    func unpack(deeplink: URL, completion: @escaping (URL) -> (Void)) {
        DynamicLinks.dynamicLinks()
            .handleUniversalLink(deeplink) { dynamicLink, _ in
                guard let url = dynamicLink?.url else { return }
                completion(url)
            }

        // If universal link didn't handle it we need to try custom scheme which is what Firebase uses on an initial app install
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: deeplink),
           let url = dynamicLink.url {
            completion(url)
        }
    }
    
    func pack(deeplink: String) async -> String {
        await withCheckedContinuation { continuation in
            guard let url = URL(string: deeplink),
                  let linkBuilder = DynamicLinkComponents(link: url,
                                                          domainURIPrefix: "https://lucrasdk.page.link")
            else {
                return continuation.resume(returning: "")
            }
            
            if let myBundleId = Bundle.main.bundleIdentifier {
                linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
            }

            linkBuilder.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
            linkBuilder.navigationInfoParameters?.isForcedRedirectEnabled = false
            linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.lucrasports.sdk.app")
            
            guard let longDynamicLink = linkBuilder.url else { return }
            
            linkBuilder.shorten { url, warnings, error in
                if let error = error {
                    return
                }
          
                guard let url = url else {
                    return continuation.resume(returning: longDynamicLink.absoluteString)
                }

                continuation.resume(returning: url.absoluteString)
            }
        }
    }
}
