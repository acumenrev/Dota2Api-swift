//
//  PlayerModel.swift
//  dotabuff
//
//  Created by Tri Vo on 6/28/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import RealmSwift
import ObjectMapper

class PlayerModel: Object, Mappable {
    
    dynamic var steamId64bit : String = ""
    dynamic var steamId32Bit : String = ""
    dynamic var personalName : String = ""
    dynamic var profileURL : String = ""
    dynamic var avatar : String = ""
    dynamic var avatarMedium : String = ""
    dynamic var avatarFull : String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        steamId64bit <- map["steamid"]
        personalName <- map["personaname"]
        profileURL <- map["profileurl"];
        avatar <- map["avatar"]
        avatarMedium <- map["avatarmedium"]
        avatarFull <- map["avatarfull"]
    }
    
    func configSteamId64Bit() -> Void {
        
    }
    
    func configSteamId32Bit() -> Void {
        let numberSteamid64bit = UInt64(self.steamId64bit)
        let steamId32BitValue = numberSteamid64bit! - 76561197960265728
        self.steamId32Bit = String(steamId32BitValue)
    }
}
