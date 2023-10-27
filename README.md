# ``LucraSDK``

TODO

## Overview

TODO

## Topics

### Initialization

Keys can be passed in thru the LucraClient initializer.

```
    LucraClient(config: .init(environment: .init(authenticationClientID: <Your API Key>,
                                                 environment: <.sandbox, .production>,
                                                 urlScheme: <Your App URL Scheme>),
                                                 appearance: ClientTheme(background: "#001448",
                                                                         surface: "#1C2575",
                                                                         primary: "#09E35F",
                                                                         secondary: "#5E5BD0",
                                                                         tertiary: "#9C99FC",
                                                                         onBackground: "#FFFFFF",
                                                                         onSurface: "#FFFFFF",
                                                                         onPrimary: "#001448",
                                                                         onSecondary: "#FFFFFF",
                                                                         onTertiary: "#FFFFFF",
                                                                         fontFamilyName: "<Your App Font>")))
```


### Required Permissions
The following keys will need to be set in Info.plist or the binary may be rejected and the app may crash.

NSBluetoothAlwaysUsageDescription
NSBluetoothPeripheralUsageDescription
NSFaceIDUsageDescription
NSLocalNetworkUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
NSLocationAlwaysUsageDescription
NSLocationWhenInUseUsageDescription
NSMotionUsageDescription
NSCameraUsageDescription
NSPhotoLibraryUsageDescription

### UI Module
#### SwiftUI
A View extension exists which presents the lucra flows as a fullScreenCover. All you need to do is create an @State var and set the appropriate flow when it needs to be launched. This is the preferred method in SwiftUI as it allows the SDK to control all presentation logic.

```
@State private var currentLucraFlow: LucraFlow?
...
.lucraFlow($currentLucraFlow, client: lucraClient)
```

To handle presentation manually the SwiftUI flows can be accessed via the LucraClient. This is useful if you want to load the flow inside your own navigation stack or modal. Internally exiting the flow via the top left x icon uses the SwiftUI dismiss EnvironmentKey which will close the sheet if presented modally or pop back to the previous screen if presented on a SwiftUI NavigationStack.

```
self.lucraClient.ui.flow(.profile)
```

#### UIKit
A UIViewController extension exists which presents the lucra flows as `modalPresentationStyle = .fullScreen`. This is the preferred method in UIKit as it allows the SDK to control all presentation logic.

```
self.present(lucraFlow: .profile, client: lucraClient, animated: true)
```

To handle presentation manually the UIKit flows can be accessed via the LucraClient. This is useful if you want to load the flow inside your own navigation stack or modal. Internally exiting the flow via the top left x icon will close the sheet if presented modally or pop back to the previous screen if presented on a UINavigationController.

```
self.lucraClient.ui.flow(.profile)
```
