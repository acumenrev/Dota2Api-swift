//
//  BoolIntTransformation.swift
//  dotabuff
//
//  Created by Tri Vo on 7/2/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import Foundation
import ObjectMapper

public class BoolToIntTransformation : TransformType {
    public typealias Object = Int
    public typealias JSON = Bool
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Int? {
        if let bValue = value as? Bool {
            if bValue == false {
                return 0
            }
            
            return 1
        }
        
        return 0
    }
    
    public func transformToJSON(value: Int?) -> Bool? {
        if value == 0 {
            return false
        }
        
        return true
    }
}

public class IntToBoolTransformation : TransformType {
    public typealias Object = Bool
    public typealias JSON = Int
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Bool? {
        if let iValue = value as? Int {
            if iValue == 0 {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    public func transformToJSON(value: Bool?) -> Int? {
        if value == false {
            return 0
        }
        
        return 1
    }
}

