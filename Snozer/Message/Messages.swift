//
//  Messages.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation


let kErrorUserNameEmpty = "Please enter your name.";
let kErrorEmailEmpty = "Please enter email address.";
let kErrorEmailValid = "Please enter valid email address.";
let kErrorPasswordEmpty = "Please enter password.";
let kErrorPasswordValid = "Password must be 8 characters long.";
let kErrorPasswordSpace = "Password must not be contain white space.";
let kErrorNewPasswordEmpty = "Please enter new password.";
let kErrorOldPasswordEmpty = "Please enter old password";
let kErrorConfirmPasswordEmpty = "Please enter confirm password.";
let kErrorPasswordMismatch = "New password and confirm password doesn't match.";
let kErrorDobEmpty = "Please enter your date of birth";
let kErrorMobileEmpty = "Please enter your mobile number";
let kErrorMobileValid = "Please enter valid mobile number";
let kErrorAvatarNotSelected = "Please select avatar image."

let kErrorServerNotRespond = "Something went wrong, please try again."
let kErrorNoInternet = "Please check your network connection."
let kErrorExpiredToken = "Your sesson has been expired. Please login again."


let kNotificationPostUpdate = "PostUpdate";
let kNotificationPostUpdateBookmark = "PostUpdateBookmark";


struct CreateTeamAlert {
    
    
    
    static var EnoughCredit = "Not enough credits to pick this player"
    
    
    //Cricket
    static let  pickWK =  "Pick 1 Wicket-Kepper"
    static let   pickBAT =  "Pick 3 - 5 Batsmen"
    static let   pickAR =  "Pick 1 - 3 All-Rounder"
    static let   pickBOW =  "Pick 3 - 5 Bowlers"
    
    static let  strPlayerWK = "WICKET-KEEPER"
    static let   strPlayerBAT = "BATSMEN"
    static let strPlayerAR = "ALL-ROUNDERS"
    static let  strPlayerBOWL = "BOWLERS"
    
    
    static let  strPlayerGK = "GOAL-KEEPER"
    static let   strPlayerDEF = "DEFENDERS"
    static let strPlayerMID = "MID-FIELDERS"
    static let  strPlayerST = "FORWARD"
    
    
    static let  strPlayerDEFEN = "DEFENDERS"
    static let   strPlayerAL = "ALL-ROUNDER"
    static let strPlayerRAID = "RAIDERS"

    
    static let  strCategory1 = "WK"
    static let  strCategory2 = "Batsmen"
    static let strCategory3 = "All-Rounders"
    static let  strCategory4 = "Bowlers"
    static let  strCategory5 = "Extra"
    
    static let  strShortCategory1 = "WK"
    static let  strShortCategory2 = "BAT"
    static let  strShortCategory3 = "All"
    static let  strShortCategory4 = "BOWL"
    
    static let    strTotalPlayerCate = 4
    
    //////---Category image
    static let    groundImage = "teamPrev"
    static let    imgCat1 = "wicketKeeper"
    static let   imgCat2 = "batsMan"
    static let   imgCat3 = "allRounder"
    static let   imgCat4 = "bowler"
    static let  imgCat5 = "allRounder"
    
    
    //////---Create Team Alert
    static let     maximumPlayerAlert = "Maximum 11 players allow"
    static let     maximumTeamPlayerAlert = "Maximum 7 players are allow from 1 team"
    static let     nextButtonAlert = "Select 11 players to complete your team"
    static let     cat1MaxPlayerAlert = "Only 1 wicket-keeper allowed"
    static let     cat2MaxPlayerAlert = "Max 5 batsmen allowed"
    static let     cat3MaxPlayerAlert = "Max 3 all-rounders allowed"
    static let    cat4MaxPlayerAlert = "Max 5 bowlers allowed"
    
    static let   cat1MinPlayerAlert = "Pick at least 1 Wicket-Kepper"
    static let   cat2MinPlayerAlert = "Pick at least 3 Batsmen"
    static let  cat3MinPlayerAlert = "Pick at least 1 All-Rounder"
    static let cat4MinPlayerAlert = "Pick at least 3 Bowler"
    
}
