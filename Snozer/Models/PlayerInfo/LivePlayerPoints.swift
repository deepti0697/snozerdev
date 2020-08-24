//
//    LivePlayerPoints.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class LivePlayerPoints : NSObject, NSCoding, Mappable{
    
    var battingNegativePoints : Float!
    var bonus : String!
    var bonusPoints : Float!
    var bowlingNegativePoints : Float!
    var catchPoints : Float!
    var catches : Int!
    var century : Int!
    var centuryPoints : Float!
    var duck : String!
    var duckPoints : Float!
    var economyRate : Double!
    var economyRatePoints : Float!
    var fifty : Int!
    var fiftyPoints : Float!
    var fiveWicketPoints : Float!
    var fiveWickets : Int!
    var fourPoints : Float!
    var fourWicketPoints : Float!
    var fourWickets : Int!
    var fours : Int!
    var isSnozer : Bool!
    var maidenOverPoints : Float!
    var maidenOvers : Int!
    var playerCredits : Float!
    var playerImage : String!
    var playerName : String!
    var playerRole : String!
    var SnozerPoints : Float!
    var runOutStumbedPoints : Float!
    var runOutStumbeds : Int!
    var runPoints : Float!
    var runs : Int!
    var sixPoints : Float!
    var sixes : Int!
    var strikeRate : Double!
    var teamName : String!
    var totalPoints : Float!
    var wicketPoints : Float!
    var wickets : Int!
    
    override init() {
        
    }
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        battingNegativePoints <- map["BattingNegativePoints"];
        bonus <- map["Bonus"];
        bonusPoints <- map["BonusPoints"];
        bowlingNegativePoints <- map["BowlingNegativePoints"];
        catchPoints <- map["CatchPoints"];
        catches <- map["Catches"];
        
        century <- map["Century"];
        centuryPoints <- map["CenturyPoints"];
        duck <- map["Duck"];
        duckPoints <- map["DuckPoints"];
        economyRate <- map["EconomyRate"];
        economyRatePoints <- map["EconomyRatePoints"];
        
        fifty <- map["Fifty"];
        fiftyPoints <- map["FiftyPoints"];
        fiveWicketPoints <- map["FiveWicketPoints"];
        fiveWickets <- map["FiveWickets"];
        fourPoints <- map["FourPoints"];
        fourWicketPoints <- map["FourWicketPoints"];
        
        
        fourWickets <- map["FourWickets"];
        fours <- map["Fours"];
        isSnozer <- map["IsSnozer"];
        maidenOverPoints <- map["MaidenOverPoints"];
        maidenOvers <- map["MaidenOvers"];
        playerCredits <- map["PlayerCredits"];
        
        playerImage <- map["PlayerImage"];
        playerName <- map["PlayerName"];
        playerRole <- map["PlayerRole"];
        SnozerPoints <- map["SnozerPoints"];
        runOutStumbedPoints <- map["RunOutStumbedPoints"];
        
        runOutStumbeds <- map["RunOutStumbeds"];
        runPoints <- map["RunPoints"];
        runs <- map["Runs"];
        sixPoints <- map["SixPoints"];
        sixes <- map["Sixes"];
        strikeRate <- map["StrikeRate"];
        
        teamName <- map["TeamName"];
        totalPoints <- map["TotalPoints"];
        wicketPoints <- map["WicketPoints"];
        wickets <- map["Wickets"];
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        battingNegativePoints = dictionary["BattingNegativePoints"] as? Float
        bonus = dictionary["Bonus"] as? String
        bonusPoints = dictionary["BonusPoints"] as? Float
        bowlingNegativePoints = dictionary["BowlingNegativePoints"] as? Float
        catchPoints = dictionary["CatchPoints"] as? Float
        catches = dictionary["Catches"] as? Int
        century = dictionary["Century"] as? Int
        centuryPoints = dictionary["CenturyPoints"] as? Float
        duck = dictionary["Duck"] as? String
        duckPoints = dictionary["DuckPoints"] as? Float
        economyRate = dictionary["EconomyRate"] as? Double
        economyRatePoints = dictionary["EconomyRatePoints"] as? Float
        fifty = dictionary["Fifty"] as? Int
        fiftyPoints = dictionary["FiftyPoints"] as? Float
        fiveWicketPoints = dictionary["FiveWicketPoints"] as? Float
        fiveWickets = dictionary["FiveWickets"] as? Int
        fourPoints = dictionary["FourPoints"] as? Float
        fourWicketPoints = dictionary["FourWicketPoints"] as? Float
        fourWickets = dictionary["FourWickets"] as? Int
        fours = dictionary["Fours"] as? Int
        isSnozer = dictionary["IsSnozer"] as? Bool
        maidenOverPoints = dictionary["MaidenOverPoints"] as? Float
        maidenOvers = dictionary["MaidenOvers"] as? Int
        playerCredits = dictionary["PlayerCredits"] as? Float
        playerImage = dictionary["PlayerImage"] as? String
        playerName = dictionary["PlayerName"] as? String
        playerRole = dictionary["PlayerRole"] as? String
        SnozerPoints = dictionary["SnozerPoints"] as? Float
        runOutStumbedPoints = dictionary["RunOutStumbedPoints"] as? Float
        runOutStumbeds = dictionary["RunOutStumbeds"] as? Int
        runPoints = dictionary["RunPoints"] as? Float
        runs = dictionary["Runs"] as? Int
        sixPoints = dictionary["SixPoints"] as? Float
        sixes = dictionary["Sixes"] as? Int
        strikeRate = dictionary["StrikeRate"] as? Double
        teamName = dictionary["TeamName"] as? String
        totalPoints = dictionary["TotalPoints"] as? Float
        wicketPoints = dictionary["WicketPoints"] as? Float
        wickets = dictionary["Wickets"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if battingNegativePoints != nil{
            dictionary["BattingNegativePoints"] = battingNegativePoints
        }
        if bonus != nil{
            dictionary["Bonus"] = bonus
        }
        if bonusPoints != nil{
            dictionary["BonusPoints"] = bonusPoints
        }
        if bowlingNegativePoints != nil{
            dictionary["BowlingNegativePoints"] = bowlingNegativePoints
        }
        if catchPoints != nil{
            dictionary["CatchPoints"] = catchPoints
        }
        if catches != nil{
            dictionary["Catches"] = catches
        }
        if century != nil{
            dictionary["Century"] = century
        }
        if centuryPoints != nil{
            dictionary["CenturyPoints"] = centuryPoints
        }
        if duck != nil{
            dictionary["Duck"] = duck
        }
        if duckPoints != nil{
            dictionary["DuckPoints"] = duckPoints
        }
        if economyRate != nil{
            dictionary["EconomyRate"] = economyRate
        }
        if economyRatePoints != nil{
            dictionary["EconomyRatePoints"] = economyRatePoints
        }
        if fifty != nil{
            dictionary["Fifty"] = fifty
        }
        if fiftyPoints != nil{
            dictionary["FiftyPoints"] = fiftyPoints
        }
        if fiveWicketPoints != nil{
            dictionary["FiveWicketPoints"] = fiveWicketPoints
        }
        if fiveWickets != nil{
            dictionary["FiveWickets"] = fiveWickets
        }
        if fourPoints != nil{
            dictionary["FourPoints"] = fourPoints
        }
        if fourWicketPoints != nil{
            dictionary["FourWicketPoints"] = fourWicketPoints
        }
        if fourWickets != nil{
            dictionary["FourWickets"] = fourWickets
        }
        if fours != nil{
            dictionary["Fours"] = fours
        }
        if isSnozer != nil{
            dictionary["IsSnozer"] = isSnozer
        }
        if maidenOverPoints != nil{
            dictionary["MaidenOverPoints"] = maidenOverPoints
        }
        if maidenOvers != nil{
            dictionary["MaidenOvers"] = maidenOvers
        }
        if playerCredits != nil{
            dictionary["PlayerCredits"] = playerCredits
        }
        if playerImage != nil{
            dictionary["PlayerImage"] = playerImage
        }
        if playerName != nil{
            dictionary["PlayerName"] = playerName
        }
        if playerRole != nil{
            dictionary["PlayerRole"] = playerRole
        }
        if SnozerPoints != nil{
            dictionary["SnozerPoints"] = SnozerPoints
        }
        if runOutStumbedPoints != nil{
            dictionary["RunOutStumbedPoints"] = runOutStumbedPoints
        }
        if runOutStumbeds != nil{
            dictionary["RunOutStumbeds"] = runOutStumbeds
        }
        if runPoints != nil{
            dictionary["RunPoints"] = runPoints
        }
        if runs != nil{
            dictionary["Runs"] = runs
        }
        if sixPoints != nil{
            dictionary["SixPoints"] = sixPoints
        }
        if sixes != nil{
            dictionary["Sixes"] = sixes
        }
        if strikeRate != nil{
            dictionary["StrikeRate"] = strikeRate
        }
        if teamName != nil{
            dictionary["TeamName"] = teamName
        }
        if totalPoints != nil{
            dictionary["TotalPoints"] = totalPoints
        }
        if wicketPoints != nil{
            dictionary["WicketPoints"] = wicketPoints
        }
        if wickets != nil{
            dictionary["Wickets"] = wickets
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        battingNegativePoints = aDecoder.decodeObject(forKey: "BattingNegativePoints") as? Float
        bonus = aDecoder.decodeObject(forKey: "Bonus") as? String
        bonusPoints = aDecoder.decodeObject(forKey: "BonusPoints") as? Float
        bowlingNegativePoints = aDecoder.decodeObject(forKey: "BowlingNegativePoints") as? Float
        catchPoints = aDecoder.decodeObject(forKey: "CatchPoints") as? Float
        catches = aDecoder.decodeObject(forKey: "Catches") as? Int
        century = aDecoder.decodeObject(forKey: "Century") as? Int
        centuryPoints = aDecoder.decodeObject(forKey: "CenturyPoints") as? Float
        duck = aDecoder.decodeObject(forKey: "Duck") as? String
        duckPoints = aDecoder.decodeObject(forKey: "DuckPoints") as? Float
        economyRate = aDecoder.decodeObject(forKey: "EconomyRate") as? Double
        economyRatePoints = aDecoder.decodeObject(forKey: "EconomyRatePoints") as? Float
        fifty = aDecoder.decodeObject(forKey: "Fifty") as? Int
        fiftyPoints = aDecoder.decodeObject(forKey: "FiftyPoints") as? Float
        fiveWicketPoints = aDecoder.decodeObject(forKey: "FiveWicketPoints") as? Float
        fiveWickets = aDecoder.decodeObject(forKey: "FiveWickets") as? Int
        fourPoints = aDecoder.decodeObject(forKey: "FourPoints") as? Float
        fourWicketPoints = aDecoder.decodeObject(forKey: "FourWicketPoints") as? Float
        fourWickets = aDecoder.decodeObject(forKey: "FourWickets") as? Int
        fours = aDecoder.decodeObject(forKey: "Fours") as? Int
        isSnozer = aDecoder.decodeObject(forKey: "IsSnozer") as? Bool
        maidenOverPoints = aDecoder.decodeObject(forKey: "MaidenOverPoints") as? Float
        maidenOvers = aDecoder.decodeObject(forKey: "MaidenOvers") as? Int
        playerCredits = aDecoder.decodeObject(forKey: "PlayerCredits") as? Float
        playerImage = aDecoder.decodeObject(forKey: "PlayerImage") as? String
        playerName = aDecoder.decodeObject(forKey: "PlayerName") as? String
        playerRole = aDecoder.decodeObject(forKey: "PlayerRole") as? String
        SnozerPoints = aDecoder.decodeObject(forKey: "SnozerPoints") as? Float
        runOutStumbedPoints = aDecoder.decodeObject(forKey: "RunOutStumbedPoints") as? Float
        runOutStumbeds = aDecoder.decodeObject(forKey: "RunOutStumbeds") as? Int
        runPoints = aDecoder.decodeObject(forKey: "RunPoints") as? Float
        runs = aDecoder.decodeObject(forKey: "Runs") as? Int
        sixPoints = aDecoder.decodeObject(forKey: "SixPoints") as? Float
        sixes = aDecoder.decodeObject(forKey: "Sixes") as? Int
        strikeRate = aDecoder.decodeObject(forKey: "StrikeRate") as? Double
        teamName = aDecoder.decodeObject(forKey: "TeamName") as? String
        totalPoints = aDecoder.decodeObject(forKey: "TotalPoints") as? Float
        wicketPoints = aDecoder.decodeObject(forKey: "WicketPoints") as? Float
        wickets = aDecoder.decodeObject(forKey: "Wickets") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if battingNegativePoints != nil{
            aCoder.encode(battingNegativePoints, forKey: "BattingNegativePoints")
        }
        if bonus != nil{
            aCoder.encode(bonus, forKey: "Bonus")
        }
        if bonusPoints != nil{
            aCoder.encode(bonusPoints, forKey: "BonusPoints")
        }
        if bowlingNegativePoints != nil{
            aCoder.encode(bowlingNegativePoints, forKey: "BowlingNegativePoints")
        }
        if catchPoints != nil{
            aCoder.encode(catchPoints, forKey: "CatchPoints")
        }
        if catches != nil{
            aCoder.encode(catches, forKey: "Catches")
        }
        if century != nil{
            aCoder.encode(century, forKey: "Century")
        }
        if centuryPoints != nil{
            aCoder.encode(centuryPoints, forKey: "CenturyPoints")
        }
        if duck != nil{
            aCoder.encode(duck, forKey: "Duck")
        }
        if duckPoints != nil{
            aCoder.encode(duckPoints, forKey: "DuckPoints")
        }
        if economyRate != nil{
            aCoder.encode(economyRate, forKey: "EconomyRate")
        }
        if economyRatePoints != nil{
            aCoder.encode(economyRatePoints, forKey: "EconomyRatePoints")
        }
        if fifty != nil{
            aCoder.encode(fifty, forKey: "Fifty")
        }
        if fiftyPoints != nil{
            aCoder.encode(fiftyPoints, forKey: "FiftyPoints")
        }
        if fiveWicketPoints != nil{
            aCoder.encode(fiveWicketPoints, forKey: "FiveWicketPoints")
        }
        if fiveWickets != nil{
            aCoder.encode(fiveWickets, forKey: "FiveWickets")
        }
        if fourPoints != nil{
            aCoder.encode(fourPoints, forKey: "FourPoints")
        }
        if fourWicketPoints != nil{
            aCoder.encode(fourWicketPoints, forKey: "FourWicketPoints")
        }
        if fourWickets != nil{
            aCoder.encode(fourWickets, forKey: "FourWickets")
        }
        if fours != nil{
            aCoder.encode(fours, forKey: "Fours")
        }
        if isSnozer != nil{
            aCoder.encode(isSnozer, forKey: "IsSnozer")
        }
        if maidenOverPoints != nil{
            aCoder.encode(maidenOverPoints, forKey: "MaidenOverPoints")
        }
        if maidenOvers != nil{
            aCoder.encode(maidenOvers, forKey: "MaidenOvers")
        }
        if playerCredits != nil{
            aCoder.encode(playerCredits, forKey: "PlayerCredits")
        }
        if playerImage != nil{
            aCoder.encode(playerImage, forKey: "PlayerImage")
        }
        if playerName != nil{
            aCoder.encode(playerName, forKey: "PlayerName")
        }
        if playerRole != nil{
            aCoder.encode(playerRole, forKey: "PlayerRole")
        }
        if SnozerPoints != nil{
            aCoder.encode(SnozerPoints, forKey: "SnozerPoints")
        }
        if runOutStumbedPoints != nil{
            aCoder.encode(runOutStumbedPoints, forKey: "RunOutStumbedPoints")
        }
        if runOutStumbeds != nil{
            aCoder.encode(runOutStumbeds, forKey: "RunOutStumbeds")
        }
        if runPoints != nil{
            aCoder.encode(runPoints, forKey: "RunPoints")
        }
        if runs != nil{
            aCoder.encode(runs, forKey: "Runs")
        }
        if sixPoints != nil{
            aCoder.encode(sixPoints, forKey: "SixPoints")
        }
        if sixes != nil{
            aCoder.encode(sixes, forKey: "Sixes")
        }
        if strikeRate != nil{
            aCoder.encode(strikeRate, forKey: "StrikeRate")
        }
        if teamName != nil{
            aCoder.encode(teamName, forKey: "TeamName")
        }
        if totalPoints != nil{
            aCoder.encode(totalPoints, forKey: "TotalPoints")
        }
        if wicketPoints != nil{
            aCoder.encode(wicketPoints, forKey: "WicketPoints")
        }
        if wickets != nil{
            aCoder.encode(wickets, forKey: "Wickets")
        }
        
    }
    
}
