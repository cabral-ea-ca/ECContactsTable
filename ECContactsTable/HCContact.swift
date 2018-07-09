//
//  HCContact.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-03.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit
import Contacts

class HCContact{
    private var contact = CNContact()
    private var strKey = String()
    private var keyIdx = -1
    var contactImage: UIImage?
    
    init( contact:CNContact){
        self.contact = contact
        if( !contact.familyName.isEmpty ){
            strKey = contact.familyName
            keyIdx = 1
        }
        else if( !contact.givenName.isEmpty ){
            strKey = contact.givenName
            keyIdx = 0
        }
        else if( !contact.organizationName.isEmpty ){
            strKey = contact.organizationName
            keyIdx = 2
        }
    }
    
    public func attributedText(ofSize fontSize: CGFloat) -> NSMutableAttributedString{
        let formattedText = NSMutableAttributedString()
        switch keyIdx{
        case 0:
            formattedText.bold(contact.givenName, ofSize: fontSize)
            formattedText.normal(" "+contact.familyName)
            
        case 1:
            formattedText.normal(contact.givenName+" ")
            formattedText.bold(contact.familyName, ofSize: fontSize)
            
        case 2:
            formattedText.bold(contact.organizationName, ofSize: fontSize)
            
        default:
            formattedText.normal("")
        }
        
        return formattedText
    }
    
    public var name: String{
        get{
            if( !contact.givenName.isEmpty || !contact.familyName.isEmpty ){
                return( "\(contact.givenName) \(contact.familyName)" )
            }
            else{
                return contact.organizationName
            }
        }
    }
    
    public func fetchImageIfNeeded(){
        if let imageData = contact.imageData, contactImage == nil {
            contactImage = UIImage(data: imageData)
        }
    }
    
    public func startingLettertoIdx() -> Int{
        let lettersInAlphabet = 26
        var RtnValue:Int = lettersInAlphabet // 0..25 : "A".."Z", 26:"Unknown prefix"
        let smallA = "a"
        if( strKey != "" ){
            RtnValue = Int(strKey.firstLetterToIdx() - smallA.firstLetterToIdx())
            if( RtnValue < 0 || RtnValue >= lettersInAlphabet){
                RtnValue = lettersInAlphabet
            }
        }
        return RtnValue
    }
}

