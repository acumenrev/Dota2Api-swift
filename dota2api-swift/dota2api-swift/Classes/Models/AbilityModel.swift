//
//  AbilityModel.swift
//  dotabuff
//
//  Created by Tri Vo on 6/28/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import RealmSwift
import ObjectMapper

class AbilityModel: Object, Mappable {
    
    dynamic var abilityId : String = ""
    dynamic var abilityName : String = ""
    dynamic var abilityImageURL : String = ""
    dynamic var heroId : Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        abilityId <- map["id"]
        abilityName <- map["name"]
    }
    
    func setAbilityImage() -> Void {
        // http://cdn.dota2.com/apps/dota2/images/abilities/drow_ranger_wave_of_silence_hp1.png
        let url = "http://cdn.dota2.com/apps/dota2/images/abilities/"
        
        self.abilityImageURL = url + self.abilityName + "_hp1.png"
    }
}
