//
//  NetworkHelper.swift
//  dota2api-swift
//
//  Created by Tri Vo on 7/4/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import Alamofire
import CocoaLumberjack
import ObjectMapper

class NetworkDef: NSObject {

    static let kAPI_KEY = "YOUR_API_KEY"
    static let kAPI_URL = "https://api.steampowered.com/"
    
    // MARK: - Game Resources
    
    static let kAPI_GET_ALL_HEROES = "IEconDOTA2_570/GetHeroes/v0001/?key=YOUR_API_KEY&language=en_us"
    static let kAPI_GET_GAME_ITEMS = "IEconDOTA2_570/GetGameItems/v0001/?key=YOUR_API_KEY&language=en_us"
    
    // MARK: - Match
    // 2466907405
    static let kAPI_GET_MATCH_DETAIL = "IDOTA2Match_570/GetMatchDetails/V001/?key=YOUR_API_KEY&match_id="
    static let kAPI_GET_MATCH_HISTORY = "IDOTA2Match_570/GetMatchHistory/v001/?key=YOUR_API_KEY&language=en_us&account_id=%@"
    static let kAPI_GET_MATCH_HISTORY_BY_SEQ_NUM = "IDOTA2Match_570/GetMatchHistoryBySequenceNum/v0001/"
    
    // MARK: - Player
    static let kAPI_GET_PLAYER_SUMMARIES = "ISteamUser/GetPlayerSummaries/v0002/?key=YOUR_API_KEY&language=en_us&steamids="
    
    static let kAPI_GET_RESOLVE_VANITY_URL = "ISteamUser/ResolveVanityURL/v0001/?key=YOUR_API_KEY&vanityurl="
}

class NetworkHelper: NSObject {
    class var sharedInstance : NetworkHelper {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkHelper()
        }
        
        return Static.instance!
    }
    
    override init() {
        
    }
    
    /**
     Make a request URL
     
     - parameter appendString: String need to be appended to original URL
     
     - returns: URL which will be used to make a request
     */
    static func makeRequestURL(appendString : String) -> String {
        let realURL = NetworkDef.kAPI_URL + appendString
        return realURL.urlEncode()
    }
    
    /**
     Get all heroes
     
     - parameter completion: Completion block
     - parameter failure:    Failure block
     */
    static func getHeroes(completion:()->Void?,
                          failure:(failError : NSError) -> Void?) -> Void {
        let url : String = makeRequestURL(NetworkDef.kAPI_GET_ALL_HEROES)
        
        Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                let jsonData = responseData as! NSDictionary
                
                NSLog("get heroes success: %@", jsonData.description)
                
                if (jsonData.objectForKey("result") != nil) {
                    let results = jsonData.objectForKey("result") as! NSDictionary
                    let list = results.objectForKey("heroes") as! NSArray
                    
                    let mapper = Mapper<HeroModel>()
                    var hero : HeroModel? = nil
                    
                    for index in 0 ... list.count - 1 {
                        let tempData = list.objectAtIndex(index) as! NSDictionary
                        
                        hero = mapper.map(tempData)
                        hero?.setHeroImage()
                        hero?.setNameWithoutPrefix()
                        // save DB
                        DBManager.sharedInstance.saveHero(hero!)
                    }
                }
                
                break
            case .Failure(let error):
                break
                
            }
            
        }
    }
    
    /**
     Get in-game items
     
     - parameter completion: Completion block
     - parameter failure:    Failure block
     */
    static func getGameItems(completion:() -> Void?,
                             failure:(failError : NSError) -> Void?) -> Void {
        let url : String = makeRequestURL(NetworkDef
            .kAPI_GET_GAME_ITEMS)
        
        Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                let jsonData = responseData as! NSDictionary
                
                NSLog("get game items success: %@", jsonData.description)
                if jsonData.objectForKey("result") != nil {
                    let results = jsonData.objectForKey("result") as! NSDictionary
                    let listItems = results.objectForKey("items") as! NSArray
                    
                    let mapper = Mapper<ItemModel>()
                    var item : ItemModel? = nil
                    
                    for index in 0...listItems.count - 1 {
                        let tempData = listItems.objectAtIndex(index) as! NSDictionary
                        
                        item = mapper.map(tempData)
                        item?.setItemImage()
                        if item != nil {
                            // save to DB
                            DBManager.sharedInstance.saveGameItem(item!)
                        }
                    }
                }
                
                break
            case .Failure(let error):
                break
            }
        }
    }
    
    
    
    // MARK: - Match
    
    /**
     Get match history
     
     - parameter accountId: AccountId
     */
    static func getMatchHistory(accountId : String, offset: Int,
                                completion:() -> Void?,
                                failure:(failError : NSError) -> Void?) -> Void {
        
    }
    
    /**
     Get match detail
     
     - parameter matchId:    MatchId
     - parameter completion: Completion block
     - parameter failure:    Failure block
     */
    static func getMatchDetail(matchId : String,
                               completion:() -> Void?,
                               failure:(failError : NSError) -> Void?) -> Void {
        if matchId.isEmpty == true {
            let error = NSError(domain: "Match Id cannot be empty", code: -1, userInfo: nil)
            failure(failError: error)
        }
        
        let url = makeRequestURL(NetworkDef.kAPI_GET_MATCH_DETAIL + matchId)
        
        Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                let jsonData = responseData as? NSDictionary
                let result = jsonData?.objectForKey("result") as! NSDictionary
                let mapper = Mapper<MatchModel>()
                let match = mapper.map(result)
                DBManager.sharedInstance.saveMatch(match!)
                break
                
            case .Failure(let error):
                failure(failError: error)
                break
            }
        }
    }
    
    // MARK: Player
    
    /**
     Get a player's summary
     
     - parameter steamId64Bit: SteamId 64 Bit
     - parameter completion:   Completion block
     - parameter failure:      Failure block
     */
    static func getPlayerSummaries(steamId64Bit : String,
                                   completion:() -> Void,
                                   failure:(failError : NSError) -> Void) -> Void {
        
        if steamId64Bit.isEmpty {
            
            let error = NSError(domain: "SteamId cannot be empty", code: -1, userInfo: nil)
            failure(failError: error)
        }
        
        let url = makeRequestURL(NetworkDef.kAPI_GET_PLAYER_SUMMARIES + steamId64Bit)
        
        
        Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                // parse json
                let jsonData = responseData as! NSDictionary
                NSLog("get player summaries success: %@", jsonData.description)
                let players = jsonData.objectForKey("response")?.objectForKey("players") as! NSArray
                
                let mapper = Mapper<PlayerModel>()
                let firstPlayer = players.firstObject
                
                // mapping
                let playerModel = mapper.map(firstPlayer)
                playerModel?.configSteamId32Bit()
                // save to db
                DBManager.sharedInstance.savePlayer(playerModel!)
                
                completion()
                break
            case .Failure(let error):
                failure(failError: error)
                break
            }
        }
    }
    
    /**
     Get player's SteamID 64bit based on his/her vanity URL
     
     - parameter accountName: account name
     - parameter completion:  Completion block
     - parameter failure:     Failure block
     */
    static func getPlayerSteamId64bitBasedOnVanityURL(accountName : String,
                                                      completion:(steamId : String) -> Void,
                                                      failure:(failError : NSError) -> Void) {
        if accountName.isEmpty {
            let error = NSError(domain: "accountName empty", code: -1, userInfo: nil)
            failure(failError: error)
        }
        
        let url = makeRequestURL(NetworkDef.kAPI_GET_RESOLVE_VANITY_URL + accountName)
        
        Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                let jsonData = responseData as! NSDictionary
                
                NSLog("get player steam success: " + jsonData.description)
                let result = jsonData.objectForKey("response") as! NSDictionary
                
                let steamId64Bit = result.objectForKey("steamid") as! String
                
                completion(steamId: steamId64Bit)
                
                break
            case .Failure(let error):
                failure(failError: error)
                break
            }
        }
    }

}
