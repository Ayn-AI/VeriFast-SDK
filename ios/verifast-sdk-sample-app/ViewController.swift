//
//  ViewController.swift
//  verifast-sdk-sample-app
//
//  Created by Robin Ankele on 23/09/2020.
//  Copyright © 2020 EYN. All rights reserved.
//
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
