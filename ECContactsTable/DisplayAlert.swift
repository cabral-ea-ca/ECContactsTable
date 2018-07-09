//
//  DisplayAlert.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-03.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

class DisplayAlert{
    private func openURL( urlStr: URL){
        if #available(iOS 10.0, *){
            DispatchQueue.main.async {
                UIApplication.shared.open(urlStr, options: [:], completionHandler: nil )
            }
        }
        else{
            DispatchQueue.main.async {
                UIApplication.shared.openURL(urlStr)
            }
        }
    }
    private func settingContactHandler(alert: UIAlertAction!) {
        print( "DisplayAlert: settingContactHandler called" )
        let urlStr = URL( string: "App-Prefs:root=Privacy&path=CONTACTS" )
        openURL(urlStr: urlStr!)
        justClose(alert: alert)
    }
    
    private func justClose(alert: UIAlertAction!){
        print( "DisplayAlert: justClose called" )
    }
    
    public func showAlertContact( title:String, message:String, viewController : UIViewController){
        print( "DisplayAlert: showAlertContact called" )
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Setting action"), style: .cancel, handler: settingContactHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"), style: .default, handler: justClose ))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
