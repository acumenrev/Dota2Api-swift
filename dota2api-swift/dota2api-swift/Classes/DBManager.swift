//
//  DBManager.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import RealmSwift
import CocoaLumberjack

class DBManager: NSObject {
    var realm : Realm?
    
    class var sharedInstance : DBManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DBManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DBManager()
        }
        return Static.instance!
    }
    
    override init() {
        realm = try! Realm()
    }
    
    // MARK: - Helper methods
    
    /**
     Begin write transaction to Realm database
     */
    func beginWriteTransaction() -> Void {
        realm!.beginWrite()
    }
    
    /**
     End write transaction to Realm database
     */
    func endWriteTransaction() -> Void {
        try! realm!.commitWrite()
    }
    
    /**
     Save an object to Realm database
     
     - parameter object: RLMObject
     */
    func saveObject(object : Object!) -> Void {
        try! realm?.write({ 
            (realm?.add(object))!
        })
    }
    
    // MARK: - Items
    
    /**
     Save game item
     
     - parameter item: game Item
     
     - returns: true if everything goes OK
     */
    func saveGameItem(item : ItemModel) -> Bool {
      
        let predicate = NSPredicate(format: "itemId == %d", item.itemId)
        let results = realm!.objects(ItemModel.self).filter(predicate)
        
        if results.count == 0 {
            // insert new item
            self.saveObject(item)
        } else {
            // update existing item
            let firstItem = results.first
            self.beginWriteTransaction()
            firstItem?.cost = item.cost
            firstItem?.localizedName = item.localizedName
            firstItem?.name = item.name
            firstItem?.recipe = item.recipe
            firstItem?.secretShop = item.secretShop
            firstItem?.sideShop = item.sideShop
            firstItem?.urlImage = item.urlImage
            self.endWriteTransaction()
        }
        
        return true
    }
    
    /**
     Get game item with specific Id
     
     - parameter id: Item Id
     
     - returns: DBItem object
     */
    func getGameItem(id : Int) -> ItemModel? {
        let predicate = NSPredicate(format: "itemId == %d", id)
        let results = realm!.objects(ItemModel.self).filter(predicate)
        
        if results.count == 0 {
            return nil
        }
        
        return results.first
    }
    
    /**
     Get all game items
     
     - returns: List of in-game items
     */
    func getAllGameItems() -> NSArray {
        let results = realm!.objects(ItemModel.self)
        
        if results.count == 0 {
            return NSArray()
        }
        
        let list : NSMutableArray = NSMutableArray(capacity: results.count)
        for object in results {
            let dbItem = object as! ItemModel

            list.addObject(dbItem)
        }
        
        return list
    }
    
    // MARK: - Heroes
    
    /**
     Save information of a hero
     
     - parameter hero: HeroModel object
     
     - returns: true if everything goes OK
     */
    func saveHero(hero : HeroModel) -> Bool {
        
        let predicate = NSPredicate(format: "heroId == %d", hero.heroId)
        let results = realm!.objects(HeroModel.self).filter(predicate)
        
        if results.count == 0 {
            // insert new item
            self.saveObject(hero)
        } else {
            // update existing item
            let firstItem = results.first
            self.beginWriteTransaction()
            firstItem?.localized_name = hero.localized_name
            firstItem?.name = hero.name
            firstItem?.setHeroImage()
            self.endWriteTransaction()
        }
        
        return true
    }
    
    /**
     Get information of a hero
     
     - parameter heroId: HeroId
     
     - returns: HeroModel object
     */
    func getHero(heroId : Int) -> HeroModel? {
        let predicate = NSPredicate(format: "heroId == %d", heroId)
        let results = realm!.objects(HeroModel.self).filter(predicate)
        
        if results.count == 0 {
            return nil
        }
        
        return results.first
    }
    
    /**
     Get all heroes
     
     - returns: List of heroes
     */
    func getAllHeroes() -> NSArray {
        let results = realm!.objects(HeroModel.self)
        
        if results.count == 0 {
            return NSArray()
        }
        
        let list : NSMutableArray = NSMutableArray(capacity: results.count)
        for object in results {
            list.addObject(object)
        }
        
        return list
    }
    
    // MARK: - Ability
    
    /**
     Get ability based on abilityId
     
     - parameter abilityId: AbilityId
     
     - returns: AbilityModel
     */
    func getAbility(abilityId : String) -> AbilityModel? {
        let predicate = NSPredicate(format: "abilityId == %@", abilityId)
        let results = realm!.objects(AbilityModel.self).filter(predicate)
        if results.count == 0 {
            return nil
        }
        
        
        return results.first
    }
    
    /**
     Save an ability
     
     - parameter ability: AbilityModel
     
     - returns: true if everything goes ok
     */
    func saveAbility(ability : AbilityModel) -> Bool {
        let predicate = NSPredicate(format: "abilityId == %d", ability.abilityId)
        let results = realm!.objects(AbilityModel.self).filter(predicate)
        if results.count == 0 {
            // save to db
            self.saveObject(ability)
        } else {
            // update db
            let firstObject = results.first
            self.beginWriteTransaction()
            firstObject?.abilityName = ability.abilityName
            firstObject?.setAbilityImage()
            self.endWriteTransaction()
        }
        return true
    }
    
    
    // MARK: - Player
    
    /**
     Save a player's summary
     
     - parameter player: PlayerModel object
     
     - returns: true if everything goes OK
     */
    func savePlayer(player : PlayerModel) -> Bool {
        let predicate = NSPredicate(format: "steamId64bit == %@", player.steamId64bit)
        let results = realm!.objects(PlayerModel.self).filter(predicate)
        
        if results.count == 0 {
            // save to db
            self.saveObject(player)
        } else {
            let firstObject = results.first
            self.beginWriteTransaction()
            firstObject?.avatar = player.avatar
            firstObject?.avatarFull = player.avatarFull
            firstObject?.avatarMedium = player.avatarMedium
            firstObject?.personalName = player.personalName
            firstObject?.profileURL = player.profileURL

            self.endWriteTransaction()
        }
        
        return true
    }
    
    /**
     Get a player's summary in Database
     
     - parameter steamId64Bit: SteamId 64 bit
     
     - returns: PlayerModel object
     */
    func getPlayerSummary(steamId64Bit : String) -> PlayerModel? {
        if steamId64Bit.isEmpty {
            return nil
        }
        
        let predicate = NSPredicate(format: "steamId64bit", steamId64Bit)
        let results = realm!.objects(PlayerModel.self).filter(predicate)
        
        if results.count == 0 {
            // not found
            return nil
        }
        
        return results.first
    }
    
    // MARK: - Match
    
    /**
     Save match
     
     - parameter match: Match Model
     
     - returns: true if everything goes ok
     */
    func saveMatch(match : MatchModel) -> Bool {
        let predicate = NSPredicate(format: "matchId == %ld", match.matchId)
        let results = realm?.objects(MatchModel.self).filter(predicate)
        
        if results?.count == 0 {
            self.saveObject(match)
        } else {
            let firstObject = results?.first
            beginWriteTransaction()
            
            endWriteTransaction()
        }
        
        return true
    }
    
    /**
     Get match with id
     
     - parameter matchId: Match Id
     
     - returns: Match Model
     */
    func getMatchWithId(matchId : Int) -> MatchModel? {
        if matchId <= 0 {
            return nil
        }
        
        let prediate = NSPredicate(format: "matchId == %ld", matchId)
        let results = realm?.objects(MatchModel.self).filter(prediate)
        
        if results?.count == 0 {
            return nil
        }
        
        return results?.first
    }
    
    func getMatchHavePlayer(playerId : String) -> NSArray {
        if playerId.isEmpty == true {
            return NSArray()
        }
        
        return NSArray()
    }
    
}
