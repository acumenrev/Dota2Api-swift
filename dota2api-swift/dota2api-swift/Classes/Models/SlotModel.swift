//
//  SlotModel.swift
//  dotabuff
//
//  Created by Tri Vo on 7/1/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import RealmSwift
import ObjectMapper

class AbilityUpgradeModel: Object, Mappable {
    
        /// Ability Id
    dynamic var abilityId : Int = 0
        /// Time when player learns this ability
    dynamic var time : Int = 0
        /// Level when player learns this ability
    dynamic var level : Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        abilityId <- map["ability"]
        time <- map["time"]
        level <- map["level"]
    }
}

class AdditionalUnitModel: Object, Mappable {
        /// Unit name like spirit_bear
    dynamic var unitname : String = ""
        /// the numeric ID of the item that unit finished with in their top-left slot.
    dynamic var itemTopLeft : Int = 0
        /// the numeric ID of the item that unit finished with in their top-center slot.
    dynamic var itemTopCenter : Int = 0
        /// the numeric ID of the item that unit finished with in their top-right slot.
    dynamic var itemTopRight : Int = 0
        /// the numeric ID of the item that unit finished with in their bottom-left slot.
    dynamic var itemBottomLeft : Int = 0
        /// the numeric ID of the item that unit finished with in their bottom-center slot.
    dynamic var itemBottomCenter : Int = 0
        /// the numeric ID of the item that unit finished with in their bottom-right slot.
    dynamic var itemBottomRight : Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        unitname <- map["unitname"]
        itemTopLeft <- map["item_0"]
        itemTopCenter <- map["item_1"]
        itemTopRight <- map["item_2"]
        itemBottomLeft <- map["item_3"]
        itemBottomCenter <- map["item_4"]
        itemBottomRight <- map["item_5"]
    }
}

class SlotModel: Object, Mappable {
    
        /// the player's 32-bit Steam ID - will be set to "4294967295" if the player has set their account to private
    dynamic var accountId : Int = 0
        /// if the left-most bit is set, the player was on dire. the two right-most bits represent the player slot (0-4)
    dynamic var playerSlot : Int = 0
        /// the numeric ID of the hero that the player used.
    dynamic var heroId : Int = 0
        /// the numeric ID of the item that player finished with in their top-center slot.
    dynamic var itemTopCenter : Int = 0
        /// the numeric ID of the item that player finished with in their top-right slot.
    dynamic var itemTopRight : Int = 0
        /// the numeric ID of the item that player finished with in their top-left slot.
    dynamic var itemTopLeft : Int = 0
        /// the numeric ID of the item that player finished with in their bottom-left slot.
    dynamic var itemBottomLeft : Int = 0
        /// the numeric ID of the item that player finished with in their bottom-center slot.
    dynamic var itemBottomCenter : Int = 0
        /// the numeric ID of the item that player finished with in their bottom-right slot.
    dynamic var itemBottomRight : Int = 0
        /// the number of kills the player got.
    dynamic var kills : Int = 0
        /// the number of times the player died.
    dynamic var deaths : Int = 0
        /// the number of assists the player got.
    dynamic var assists : Int = 0
    /**
     * NULL - player is a bot.
     * 2 - player abandoned game.
     * 1 - player left game after the game has become safe to leave.
     * 0 - Player stayed for the entire match.
     
     */
    dynamic var leaverStatus : Int = 0
        /// the number of times a player last-hit a creep
    dynamic var lastHits : Int = 0
        /// the number of times a player denied a creep
    dynamic var denies : Int = 0
        /// the player's total gold/min
    dynamic var goldPerMin : Int = 0
        /// the player's total xp/min
    dynamic var expPerMin : Int = 0
        /// the player's final level
    dynamic var level : Int = 0
        /// the amount of gold the player had left at the end of the match
    dynamic var gold : Int = 0
        /// the total amount of gold the player spent over the entire match
    dynamic var goldSpent : Int = 0
        /// the amount of damage the player dealt to heroes
    dynamic var heroDamage : Int = 0
        /// the amount of damage on other players that the player healed
    dynamic var heroHealing : Int = 0
        /// the amount of damage the player dealt to towers
    dynamic var towerDamage : Int = 0
        /// Array of ability upgrades for player in this slot (can be empty)
    var abilitiesUpgrade : List<AbilityUpgradeModel> = List<AbilityUpgradeModel>()
        /// Array of additional units like Spirit Bear
    var additionalUnits : List<AdditionalUnitModel> = List<AdditionalUnitModel>()
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        accountId <- map["account_id"]
        playerSlot <- map["player_slot"]
        heroId <- map["hero_id"]
        itemTopLeft <- map["item_0"]
        itemTopCenter <- map["item_1"]
        itemTopRight <- map["item_2"]
        itemBottomLeft <- map["item_3"]
        itemBottomCenter <- map["item_4"]
        itemBottomRight <- map["item_5"]
        kills <- map["kills"]
        deaths <- map["deaths"]
        assists <- map["assists"]
        leaverStatus <- map["leaver_status"]
        lastHits <- map["last_hits"]
        denies <- map["denies"]
        goldPerMin <- map["gold_per_min"]
        expPerMin <- map["xp_per_min"]
        level <- map["level"]
        gold <- map["gold"]
        goldSpent <- map["gold_spent"]
        heroDamage <- map["hero_damage"]
        towerDamage <- map["tower_damage"]
        heroHealing <- map["hero_healing"]
        abilitiesUpgrade <- (map["ability_upgrades"], ArrayTransform<AbilityUpgradeModel>())
        additionalUnits <- (map["additional_units"], ArrayTransform<AdditionalUnitModel>())
    }
    
    /**
     Check if user sets their account to private
     
     - returns: true if user's account is private
     */
    func isAnonymous() -> Bool {
        if self.accountId == 4294967295 {
            return true
        }
        
        return false
    }
}
