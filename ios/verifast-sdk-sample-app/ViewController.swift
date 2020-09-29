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
        
        var ready: Bool = false
        Eyn.shared.withLicense(
            fromApiKey: "api_key_1555b89d-28ee-4021-ae2b-49eac69f4856",
            fromSiteId: "site_id_6135adaf-0671-4ecd-b040-b5a2b089d12b",
            fromEnrolee: "dev@eyn.vision",
            completionHandler: {
                ready = true
        })
        
        while(!ready) {
        }
        
        _ = Eyn.shared.withCustomInterface(
        fromFont: [UIFont(name: "Helvetica", size: 19.0)!,
                   UIFont(name: "Helvetica", size: 19.0)!,
                   UIFont(name: "Helvetica", size: 19.0)!],
        fromColor: [UIColor(red: 5.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)])
        
        _ = Eyn.shared.execute(resultHandler: { result in
            print(result.name)
            print(result.surname)
            print(result.birth_date)
            print(result.sex)
            print(result.country)
            print(result.nationality)
            print(result.document_type)
            print(result.document_number)
            print(result.expiry_date)
       })
    }
}

