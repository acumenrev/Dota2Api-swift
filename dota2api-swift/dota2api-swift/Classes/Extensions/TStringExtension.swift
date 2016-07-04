//
//  TStringExtension.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import Foundation

extension String {
    /**
     Get name of a class
     
     - parameter aClass: Class
     
     - returns: Class name
     */
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    /**
     Substring from specific index
     
     - parameter from: Index
     
     - returns: Substring value
     */
    func substring(from: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(from))
    }
    
        /// Length of String
    var length: Int {
        return self.characters.count
    }
    
    /**
     Encoding URL with special characters
     
     - returns: Encoded URL
     */
    func urlEncode() -> String {
        let chars = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
//        chars.removeCharactersInString("&")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(chars)!
    }
}