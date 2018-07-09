//
//  ViewControllerHandlers.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-03.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

extension ViewController{
    func requestAccessHandler(authorized: Bool, error:Error?){
        print( "requestAccessHandler called", authorized, error ?? "No error" )
        if authorized {
            retrieveContacts( contactStore: contactStore )
        }
        else{
            DispatchQueue.main.async {
                let displayAlert = DisplayAlert()
                displayAlert.showAlertContact(title: "Contacts Settings", message: "Please allow the app to use it", viewController: self)
            }
        }
    }
}
