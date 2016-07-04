//
//  ItemModel.swift
//  dotabuff
//
//  Created by Tri Vo on 6/27/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ItemModel: Object, Mappable  {
    
    
    dynamic var itemId : Int = 0
    dynamic var name : String = ""
    dynamic var localizedName : String = ""
    dynamic var recipe : Bool = false
    dynamic var cost : Int = 0
    dynamic var sideShop : Bool = false
    dynamic var urlImage : String = ""
    dynamic var secretShop : Bool = false
    
    
    required convenience init?(_ map: Map) {
        self.init()
        self.recipe = false
        self.name = ""
        self.cost = 0
        self.sideShop = false
        self.urlImage = ""
        self.secretShop = false
        self.itemId = 0
        self.localizedName = ""
    }
 
    
    func mapping(map: Map) {
        recipe <- map["recipe"]
        name <- map["name"]
        cost <- map["cost"]
        sideShop <- map["side_shop"]
        secretShop <- map["secret_shop"]
        itemId <- map["id"]
        localizedName <- map["localized_name"]
    }
    
    func setItemImage() -> Void {
        let itemNameWithoutPrefix = self.name.substring(5)
        // http://cdn.dota2.com/apps/dota2/images/items/<name>_lg.png
        let imageName = "http://cdn.dota2.com/apps/dota2/images/items/" + itemNameWithoutPrefix + "_lg.png"
        self.urlImage = imageName
    }
}
