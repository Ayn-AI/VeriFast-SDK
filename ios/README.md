
VeriFast-SDK-iOS
==

## Get EYN's VeriFast-SDK-iOS

EYN's VeriFast-SDK for iOS is available via [https://cocoapods.org/](https://cocoapods.org/). Follow the following steps to install `Cocoapods` and install EYN's VeriFast-SDK-iOS:

1. Install `Cocoapods` 
```
$ sudo gem install cocoapods
```
2. Create a `Podfile` with the following content:

```
# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
project '<Your XCode Project name>.xcodeproj'

target '<Your XCode Target name>' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for <Your XCode Target name>
  pod 'eyn'

end
```
3. Install all pods and dependencies

```
pod install
```

Once this is done, you can open the `<Your XCode Project name>.xcworkspace` project file and follow below steps to set up EYN's VeriFast-SDK-iOS.

## Getting Started
There are a couple of configuration steps in order to integrate EYN's VeriFast-SDK-iOS:

### App permissions
The sdk access the camera, near field communication, photo library and location. Therefore, the following permissions need to be set in your `Info.plist` file:

```
<key>NSCameraUsageDescription</key>
<string>
We require access to your camera to capture images of your identity document, and selfie to extract information such as your name, date of birth and facial image for the purpose of verifying your identity and matching your records to your account.
</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>
We require access to capture your location in order to record your current location to prevent fraud and for auditability purposes whilst capturing your identity.
</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>
We require access to your Photo Library in order to upload selected images to extract information such as your name, date of birth and facial image for the purpose of verifying your identity.
</string>
```

### NFC Configuration

EYN's VeriFast-SDK-iOS reads information from the identity documents embedded chip via near field communication. As such you have to execute a few configuration steps in order to enable the `NFC Capability` in your application.

1. Log in to [https://developer.apple.com](https://developer.apple.com) and register a new application identitfier and enable the `NFC Capability` [here](https://developer.apple.com/account/resources/identifiers/list).

2. Add a `*.entitlements` file, where `*` is your application name to your app and include in your XCode project to enable the `NFC Capability`. The file should have the following content:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>TAG</string>
    </array>
</dict>
</plist>
```

3. Add the following permissions in your `Info.plist` file:
```
<key>NFCReaderUsageDescription</key>
<string>
We require NFC access to read the embedded chip of your identity document to extract information such as your name, date of birth and facial image for the purpose of verifying your identity.
</string>
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
    <string>00000000000000</string>
</array>
```

### Firebase Configuration

In order to detect a person's face, we rely on the `Firebase MLVision` library. As such, you have to include firebase in your project. There are a few setup steps in order to include firebase in your project:

1. Head to [https://console.firebase.google.com](https://console.firebase.google.com) and create a new project. 
2. Head to [https://firebase.google.com/docs/ios/setup](https://firebase.google.com/docs/ios/setup) and follow steps 2-4 to integrate firebase into your project. 

This includes downloading your `GoogleService-Info.plist` file and adding it to your XCode project. Further, you need to initialise Firebase in your `AppDelegate.swift` as follows:

```
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
```

### Setting Up your EYN API Key

Setting up your api key is easy. You simple call EYN's singleton with the `withLicense` function and set the following keys:

```
Eyn.shared.withLicense(
    fromApiKey: "api_key_1555b89d-28ee-4021-ae2b-49eac69f4856",
    fromSiteId: "site_id_6135adaf-0671-4ecd-b040-b5a2b089d12b",
    fromEnrolee: "dev@eyn.vision",
    completionHandler: {
})
```

Don't have an api key yet? Please contact us <a href="mailto:contact@eyn.vision">here</a> to obtain your api key.


### Start Scanning ID documents

You simple call EYN's singleton with the `execute` function as shown below in your `ViewController`:

```
Eyn.shared.execute(resultHandler: { result in
    print(result.name)
    print(result.surname)
    print(result.date_of_birth)
})
```

A full example integration is shown below. 

```
import UIKit
import Eyn

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ready: Bool = false
        Eyn.shared.withLicense(
            fromApiKey: "api_key_676db5da-71f0-471f-8e3b-f4fae0f823d8",
            fromSiteId: "site_id_ba098139-1d3c-4722-b534-93c3f5734af1",
            fromEnrolee: "robin@eyn.vision",
            completionHandler: {
                ready = true
        })
        
        while(!ready) {
        }
        
        Eyn.shared.execute(resultHandler: { result in
            print(result.name)
            print(result.surname)
            print(result.date_of_birth)
        })
    }
}
```
