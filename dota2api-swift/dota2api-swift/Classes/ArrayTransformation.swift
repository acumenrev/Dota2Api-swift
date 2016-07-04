//
//  ArrayTransformation.swift
//  dotabuff
//
//  Created by Tri Vo on 7/2/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class ArrayTransform<T:RealmSwift.Object where T:Mappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    let mapper = Mapper<T>()
    
    func transformFromJSON(value: AnyObject?) -> List<T>? {
        var result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(entry)!
                result.append(model)
            }
        }
        return result
    }
    
    // transformToJson was replaced with a solution by @zendobk from https://gist.github.com/zendobk/80b16eb74524a1674871
    // to avoid confusing future visitors of this gist. Thanks to @marksbren for pointing this out (see comments of this gist)
    func transformToJSON(value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}