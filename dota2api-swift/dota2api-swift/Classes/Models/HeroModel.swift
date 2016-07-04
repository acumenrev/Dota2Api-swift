//
//  HeroModel.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class HeroModel: Object, Mappable {
    
    dynamic var heroId : Int = 0
    dynamic var name : String = ""
    dynamic var localized_name : String = ""
    dynamic var nameWithoutPrefix : String = ""
    dynamic var url_small_portrait : String = ""
    dynamic var url_large_portrait : String = ""
    dynamic var url_full_portrait : String = ""
    dynamic var url_vertical_portrait : String = ""
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        heroId <- map["id"]
        localized_name <- map["localized_name"]
        
        
    }
    
    func setHeroImage() -> Void {
    
        let heroNameWithoutPrefix = self.name.substring(14)
        
        let url = "http://cdn.dota2.com/apps/dota2/images/heroes/"
        
        // small horizontal portrait - 59x33px
        let sb = url + heroNameWithoutPrefix + "_sb.png"
        
        // large horizontal portrait - 205x11px
        let lg = url + heroNameWithoutPrefix + "_lg.png"
        
        // full quality horizontal portrait - 256x114px
        let fullSize = url + heroNameWithoutPrefix + "_full.png"
        
        // full quality vertical portrait - 234x272px (note this is a .jpg)
        let vertical = url + heroNameWithoutPrefix + "_vert.jpg"
        
        self.url_full_portrait = fullSize
        self.url_large_portrait = lg
        self.url_vertical_portrait = vertical
        self.url_small_portrait = sb
    }
    
    func setNameWithoutPrefix() -> Void {
        self.nameWithoutPrefix = self.name.substring(14)
        
    }
}
