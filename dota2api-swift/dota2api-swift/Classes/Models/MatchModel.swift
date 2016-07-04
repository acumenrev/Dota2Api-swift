//
//  MatchModel.swift
//  dotabuff
//
//  Created by Tri Vo on 7/2/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import RealmSwift
import ObjectMapper


class PickBanModel: Object, Mappable {
        /// true if this hero is picked
    dynamic var isPick : Bool = false
        /// Numeric Id of the hero
    dynamic var heroId : Int = 0
        /// True if team is radiant
    dynamic var team : Bool = false
        /// Order number of this ban/pick
    dynamic var order : Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        isPick <- map["Bool"]
        heroId <- map["hero_id"]
        team <- (map["team"], IntToBoolTransformation())
        order <- map["order"]
    }
}

class MatchModel: Object, Mappable {
    
        /// Numeric Id of the match
    dynamic var matchId : Int = 0
        /// Bool value indicate if radiant wins the match
    dynamic var radiantWin : Bool = false
        /// Duration of the match in seconds
    dynamic var duration : Int = 0
        /// Time that first blood occurs in seconds
    dynamic var firstBloodTime : Int = 0
        /// Epoch time indicate time when this match starts
    dynamic var startTime : Int = 0
        /// Match seq number
    dynamic var matchSeqNumber : Int = 0
        /// Game mode
    dynamic var gameMode : Int = 0
        /// Status of radiant tower
    dynamic var towerStatusRadiant : Int = 0
        /// Status of radiant tower
    dynamic var towerStatusDire : Int = 0
        /// Status of radiant barracks
    dynamic var barracksStatusRadiant : Int = 0
        /// Status of dire barracks
    dynamic var barracksStatusDire : Int = 0
    
    dynamic var lobbyType : Int = 0
        /// Number of players are human
    dynamic var humanPlayers : Int = 0
        /// Numeric Id of league
    dynamic var leagueId : Int = 0
        /// Numeric Id of server
    dynamic var cluster : Int = 0
        /// Number of thumb up votes
    dynamic var positiveVotes : Int = 0
        /// Number of thumb down votes
    dynamic var negativeVotes : Int = 0
        /// Name of radiant team
    dynamic var radiantTeamName : String = ""
        /// Numeric of radiant team
    dynamic var radiantTeamId : Int = 0
        /// Id of radiant team logo
    dynamic var radiantTeamLogo : String = ""
        /// true if all players on radiant belong to this team, false otherwise (i.e. are the stand-ins {false} or not {true})
    dynamic var radiantTeamComplete : Bool = false
        /// Dire's team ID
    dynamic var direTeamId : Int = 0
        /// Dire's team name
    dynamic var direTeamName : String = ""
        /// Dire's team logo Id
    dynamic var direTeamLogo : String = ""
    /// true if all players on dire belong to this team, false otherwise (i.e. are the stand-ins {false} or not {true})
    dynamic var direTeamComplete : Bool = false
    
    dynamic var engine : Int  = 0
        /// Radiant's Captain's Id
    dynamic var radiantCaptain : Int = 0
        /// Dire's Captain's Id
    dynamic var direCaptain : Int = 0
        /// Radiant's Score
    dynamic var radiantScore : Int = 0
        /// Dire's Score
    dynamic var direScore : Int = 0
        /// Pre game duration
    dynamic var preGameDuration : Int = 0
    
    var picksBans : List<PickBanModel> = List<PickBanModel>()
    
    var players : List<SlotModel> = List<SlotModel>()

    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        radiantWin <- map["radiant_win"]
        duration <- map["duration"]
        preGameDuration <- map["pre_game_duration"]
        matchId <- map["match_id"]
        startTime <- map["start_time"]
        matchSeqNumber <- map["match_seq_num"]
        towerStatusRadiant <- map["tower_status_radiant"]
        towerStatusDire <- map["tower_status_dire"]
        barracksStatusDire <- map["barracks_status_dire"]
        barracksStatusRadiant <- map["barracks_status_radiant"]
        cluster <- map["cluster"]
        firstBloodTime <- map["first_blood_time"]
        lobbyType <- map["lobby_type"]
        humanPlayers <- map["human_players"]
        leagueId <- map["leagueid"]
        positiveVotes <- map["positive_votes"]
        negativeVotes <- map["negative_votes"]
        gameMode <- map["game_mode"]
        engine <- map["engine"]
        radiantScore <- map["radiant_score"]
        direScore <- map["dire_score"]
        radiantTeamId <- map["radiant_team_id"]
        radiantTeamName <- map["radiant_name"]
        radiantTeamLogo <- map["radiant_logo"]
        radiantTeamComplete <- (map["radiant_team_complete"], IntToBoolTransformation())
        direTeamId <- map["dire_team_id"]
        direTeamName <- map["dire_name"]
        direTeamLogo <- map["dire_logo"]
        direTeamComplete <- (map["dire_team_complete"], IntToBoolTransformation())
        radiantCaptain <- map["radiant_captain"]
        direCaptain <- map["dire_captain"]
        players <- (map["players"], ArrayTransform<SlotModel>())
        picksBans <- (map["picks_bans"], ArrayTransform<PickBanModel>())
    }
}
