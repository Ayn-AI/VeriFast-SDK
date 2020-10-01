
VeriFast-SDK-iOS
==

## Table of Contents
1. [Get EYN's VeriFast-SDK-iOS](#get_eyns_sdk)
2. [Getting Started](#getting_started)
3. [Error Handling](#error_handling)
4. [Customisation of the SDK](#customisation)
5. [Sample Implementation](#sample_implementation)

 
 <a name="get_eyns_sdk"></a>
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

<a name="getting_started"></a>
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
Eyn.shared.execute(
    onSuccess: { result in
        print(result.name)
        print(result.surname)
        print(result.birth_date)
        print(result.sex)
        print(result.country)
        print(result.nationality)
        print(result.document_type)
        print(result.document_number)
        print(result.expiry_date)
        print(result.session_id)
    },
    onError: { _ in _ },
    fromDocument: nil
)
```

The sdk only returns limited results of the checks that EYN performs on an identity document. In order to receive the full range of checks please consult EYN's API documentation at [https://api.eyn.vision](https://api.eyn.vision). Each enrolment that you perform can be linked via the `session_id`. 

### Receive Detailed Identity Check results via EYN's API

Check out our documentation at [https://api.eyn.vision](https://api.eyn.vision) or contact us at [contact@eyn.vision](mailto:contact@eyn.vision) to get a full list of identity checks performed.

#### Example Identity Check

An example response of identity checks that EYN is performing can be seen below: 

```
{ 
"face_checks" : {
    "face_matched": true,
    "face_similarity": 90.26
},
"age": {
    "years": 31,
    "months": 1,
    "days": 19
},
"dob_doe_dn_hash_present": true,
"document_checks": {
    "is_birth_date_valid": true,
    "is_document_expired": false,
    "is_document_number_valid": true,
    "is_expiry_date_valid": true
},
"right_to_work_uk_status": "passed",
"full_mrz_text": "P<GBRUK<SPECIMEN<<ANGELA<ZOE<<<<<<<<<<<<<<<<\n5334013720GBR8812049F2509286<<<<<<<<<<<<<<00",
"mrz_fields": {
    "birth_date": "19881204",
    "birth_date_hash": "9",
    "country": "GBR",
    "document_number": "533401372",
    "document_number_hash": "0",
    "document_type": "P",
    "expiry_date": "20250928",
    "expiry_date_hash": "6",
    "final_hash": "0",
    "name": "ANGELA ZOE",
    "nationality": "GBR",
    "optional_data": "",
    "optional_data_hash": "0",
    "sex": "F",
    "surname": "UK SPECIMEN"
},
"session_id": <enrolment_id>
}
```

<a name="error_handling"></a>
## Error Handling

Each function of the `Eyn` singleton is a `throwing` function, which on miss-configuration throws any of the following `EynImplementationError`s. Further, if an error occurs during runtime, we throw an `EynRuntimeError` which can be handled in the `onError` callback function in the `execute()` function. 

### Eyn Implementation Errors

There are the following implementation error types:

```
public enum EynImplementationErrorType: Error {
    case licenseError
    case documentTypeError
    case fontCustomizationError
    case stepCantExecuteSingularError
    case chipStepRequiresDocumentStepError
    case faceStepRequiresDocumentStepError
}
```

In order to handle any `EynImplementationError` it is recommended that you add a `do try catch()` block around all functions of `Eyn` singleton and handle the errors as follows:

```
do {
    try Eyn.shared.execute(
        onSuccess: { _ in _ },
        onError: { _ in _ },
        fromDocument: nil
    )
} catch {
    switch((error as! EynImplementationError).errorType) {
    case .licenseError:
        print("Call 'withLicense()' with valid parameters.")
    case .documentTypeError:
        print("Call 'execute()' with valid parameters.")
    case .fontCustomizationError:
        print("Call 'withCustomInterface()' with valid parameters.")
    case .stepCantExecuteSingularError:
        print("Call 'withSteps()' with valid parameters.")
    case .chipStepRequiresDocumentStepError:
        print("Call 'withSteps()' with valid parameters.")
    case .faceStepRequiresDocumentStepError:
        print("Call 'withSteps()' with valid parameters.")
    case .none:
        print("We won't reach here but we need a default case for Swift.")
    }
}
```

### Eyn Runtime Errors

There are the following runtime error types:

```
public enum EynRuntimeErrorType: Error {
    case cameraPermissions
    case locationPermissions
    case photoLibraryPermissions
    case eynServerError
    case unexpected
}
```

In order to handle any `EynRuntimeError` it is recommended that you implement the `onError` callback handler as follows:

```
try Eyn.shared.execute(
    onSuccess: { _ in _ },
    onError: { error in
        switch(error.errorType) {
        case .cameraPermissions:
            print("Handle camera permissions not given.")
        case .locationPermissions:
            print("Handle location permissions not given.")
        case .photoLibraryPermissions:
            print("Handle photo library permissions not given.")
        case .eynServerError:
            print(error.localizedDescription)
        case .unexpected:
            print(error.localizedDescription)
        case .none:
            print("We won't reach here but we need a default case for Swift.")
        }
    },
    fromDocument: nil
)
```

<a name="customisation"></a>
## Customisation of the SDK

In order to adapt EYN's VeriFast-SDK to your needs, you can customise our SDK as follows:

### Font

EYN's VeriFast-SDK uses three types of fonts: bold, regular and thin font. You can choose one font for each type or different fonts for each type. Currently the sizes in the SDK are fixed and will be customisable in future releases. You can select any font name or load your custom font as follows:

```
_ = Eyn.shared.withCustomInterface(
    fromFont: [UIFont(name: "Helvetica", size: 19.0)!,    // bold font
               UIFont(name: "Helvetica", size: 19.0)!,    // regular font
               UIFont(name: "Helvetica", size: 19.0)!],   // thin font
    fromColor: nil)
```

### Colour 

EYN's VeriFast-SDK colouring scheme is customisable and you can choose any colour as follows:

```
_ = Eyn.shared.withCustomInterface(
    fromFont: nil,
    fromColor: [UIColor(red: 5.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)])
```

### Document Pre-Selection

EYN's VeriFast-SDK allows for document pre-selection. You can choose any of the following document types: 

```
public enum EynDocument: String {
    case resident_permit = "resident_permit"
    case visa = "visa"
    case passport = "passport"
    case other = "other"
}
```

The document pre-selection can be configured as an additional parameter in the `execute()` function as shown below:

```
Eyn.shared.execute(
    onSuccess: { result in
        print(result.name)
        print(result.surname)
        print(result.birth_date)
        print(result.sex)
        print(result.country)
        print(result.nationality)
        print(result.document_type)
        print(result.document_number)
        print(result.expiry_date)
        print(result.session_id)
    },
    onError: { _ in _ },
    fromDocument: .passport
)
```

If the parameter `fromDocument` is given a `nil` value, then EYN's VeriFast-SDK displays a `ViewController` such that the user can choose which document they want to upload. 

### Animations 

EYN's VeriFast-SDK displays animations in order to help non-tech savy users to capture their identity documents. By default, these animations are shown. In order to display or block these animations, you can pass a parameter `withAnimations: <Bool>`  to the `execute()` function as shown below:

```
Eyn.shared.execute(
    onSuccess: { result in
        print(result.name)
        print(result.surname)
        print(result.birth_date)
        print(result.sex)
        print(result.country)
        print(result.nationality)
        print(result.document_type)
        print(result.document_number)
        print(result.expiry_date)
        print(result.session_id)
    },
    onError: { _ in _ },
    fromDocument: nil,
    withAnimation: true
)
```

### Modularisation of the SDK

EYN's VeriFast-SDK allows for a modularisation of the steps that a user has to perform. You can choose between the following steps:

```swift
public enum EynSteps: String {
    case document = "document"
    case chip = "chip"
    case face = "face"
}
```

The steps can be configured into EYN's VeriFast-SDK with the function `withSteps()` as follows:

```swift
Eyn.shared.withSteps(withSteps: [.document, .chip, .face])
```

The following combinations of steps are configurable (since chip and face reading required the document step as a pre-condition): 

 *  `[.document]`
 *  `[.document, .face]`
 *  `[.document, .chip]`
 *  `[.document, .chip, .face]`


<a name="sample_implementation"></a>
## Sample Implementation

A full example integration is shown below. 

```swift
import UIKit
import Eyn

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            var ready: Bool = false
            // don't forget to change these example license keys with your api key
            try Eyn.shared.withLicense(
                fromApiKey: "api_key_1555b89d-28ee-4021-ae2b-49eac69f4856",
                fromSiteId: "site_id_6135adaf-0671-4ecd-b040-b5a2b089d12b",
                fromEnrolee: "dev@eyn.vision",
                completionHandler: {
                    ready = true
            })
            
            while(!ready) {
            }
            
            // this step is optional for you to customise your sdk - you can choose your own font and color scheme
            try Eyn.shared.withCustomInterface(
                fromFont: [UIFont(name: "Helvetica", size: 19.0)!,
                           UIFont(name: "Helvetica", size: 19.0)!,
                           UIFont(name: "Helvetica", size: 19.0)!],
                fromColor: [UIColor(red: 5.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)])
            
            // this step is optional for you to customise your sdk - you can choose which modules you want to execute
            try Eyn.shared.withSteps(withSteps: [.document, .chip, .face])
            
            // this will load and present EYN's sdk to the user
            try Eyn.shared.execute(
                onSuccess: { result in
                    print(result.name)
                    print(result.surname)
                    print(result.birth_date)
                    print(result.sex)
                    print(result.country)
                    print(result.nationality)
                    print(result.document_type)
                    print(result.document_number)
                    print(result.expiry_date)
                    print(result.session_id)
                },
                onError: { error in
                    switch(error.errorType) {
                    case .cameraPermissions:
                        print("Handle camera permissions not given.")
                    case .locationPermissions:
                        print("Handle location permissions not given.")
                    case .photoLibraryPermissions:
                        print("Handle photo library permissions not given.")
                    case .eynServerError:
                        print(error.localizedDescription)
                    case .unexpected:
                        print(error.localizedDescription)
                    case .none:
                        print("We won't reach here but we need a default case for Swift.")
                    }
                },
                fromDocument: .passport,        // you can choose to pre-select a document
                withAnimation: true             // you can choose whether to show animations or not
            )
        } catch {
            switch((error as! EynImplementationError).errorType) {
            case .licenseError:
                print("Call 'withLicense()' with valid parameters.")
            case .documentTypeError:
                print("Call 'execute()' with valid parameters.")
            case .fontCustomizationError:
                print("Call 'withCustomInterface()' with valid parameters.")
            case .stepCantExecuteSingularError:
                print("Call 'withSteps()' with valid parameters.")
            case .chipStepRequiresDocumentStepError:
                print("Call 'withSteps()' with valid parameters.")
            case .faceStepRequiresDocumentStepError:
                print("Call 'withSteps()' with valid parameters.")
            case .none:
                print("We won't reach here but we need a default case for Swift.")
            }
        }
    }
}

```
