//
//  StringExt.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-04.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import Foundation

extension String{
    public func firstLetterToIdx() -> UInt32{
        let range = self.rangeOfCharacter(from: .letters)
        if range != nil{
            let firstLetter = String( self[range!.lowerBound] as Character ).lowercased()
            return firstLetter.unicodeScalars.map { $0.value }.reduce(0, +)
        }
        return 26
    }
}
