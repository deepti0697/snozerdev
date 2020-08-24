//
//  constant.swift
//  Snozer
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 Calieo Technologies. All rights reserved.
//
//

import Foundation
import UIKit

let appdelegate = UIApplication.shared.delegate as! AppDelegate
let defaults:UserDefaults = UserDefaults.standard;
let isDebug = true;

let playerTypeDict: [String: String] = ["wicketkeeper":"WK", "batsman":"BAT", "bowler":"BOW", "allrounderc":"AR", "goalkeeper":"GK", "forward":"ST", "midfielder":"MID", "defender":"DEF", "allrounder":"ALL", "raider":"RAI"];


let kAdminCommission = 15.0;
let rupeeSymbol = "\u{20B9}"
let kGoogleClientID = "394656611433-4isvd1b4ps51a3ai3q956hh19jege51a.apps.googleusercontent.com"


let kUniqueDeviceId = UIDevice.current.identifierForVendor!.uuidString;
let kAppName = "Snozer";

let kAuthExpire = "authExpire";
let kExpireToken = "expireToken";
let kUserId = "userId";
let kUserInfo = "userInfo";
let kUserType = "UserType";
let kSkipTutorialPages = "skipTutorialPages"
let kIsAutoLogin = "IsAutoLogin";
let kIsDeepLink = "isDeepLink";
let kIsFirebaseReferesh = "isFirebaseReferesh";
let kPlayType = "PlayType";
let kSelectedSportsId = "SelectedSportsId";
let kSelectedSports = "SelectedSports";

let kCounrtyCode = "+91";

//Sports Name
let Cricket = "CRICKET";
let Football = "FOOTBALL";
let Kabaddi = "KABADDI";
let Volleyball = "VOLLEYBALL"

//all path key
let kCategoryImagePath = "categoryImagePath";
let kNewsImagePath = "newsImagePath";
let kShareUrlPath = "shareUrlPath";
let kProfielImagePath = "profileImagePath";
let kMagazineImagePath = "magazineImagePath";
let kTopicImagePath = "topicImagePath";
let kShareShortUrl = "shareShortUrl";
let kShareMagazineUrl = "shareMagzineUrl";

let kNewsCategory = "NewsCategory";
let kNewsType = "NewsType";

let kHomeTopButtonsIntro = "HomeTopButtonsIntro";
let kNewsScrollIntro = "NewsScrollIntro";
let kScreenTapInfo = "ScreenTapInfo";
let kNewsRightSwipeInfo = "NewsRightSwipeInfo";
let kNewsTopScrollInfo = "NewsTopScrollInfo";
let kLastCheckinFormat = "hh:mm a dd MMMM, yyyy";
let kIdealSecond : Double = 60*15;


let kCategoriesLastid = "categoryLastid";
let kTopicLastid = "topicLastid";


let kSignInEmail = 1;
let kSignInFacebook = 2;
let kSignInGoogle = 3;


let kCricket = "0"
let kKabaddi = "1"
let kFootball = "2"

let screen_height = UIScreen.main.bounds.size.height;
let screen_width = UIScreen.main.bounds.size.width;

let font_reguler = "Roboto-Regular";
let font_light = "Roboto-Light";
let font_thin = "Roboto-Thin";
let font_medium = "Roboto-Medium";
let font_bold = "Roboto-Bold";


let AppBlue = UIColor(named: "AppBlue") ?? UIColor(red: 0/255, green: 63.0/255, blue: 147.0/255, alpha: 1);
let AppGreen = UIColor(named: "AppGreen") ?? UIColor(red: 17.0/255, green: 201.0/255, blue: 103.0/255, alpha: 1);
let AppInsideBgColor = UIColor(named: "AppInsideBg") ?? UIColor(red: 210.0/255, green: 224.0/255, blue: 243.0/255, alpha: 1);
let AppGrayTextColor = UIColor(named: "AppGrayText") ?? UIColor(red: 133.0/255, green: 133.0/255, blue: 133.0/255, alpha: 1);
let whiteColor = UIColor.white;
let AppLightGrayColor = UIColor(red: 244.0/255, green: 242.0/255, blue: 243.0/255, alpha: 1);
let AppDarkGrayColor = UIColor(named: "AppDarkGray") ?? UIColor(red: 187.0/255, green: 195.0/255, blue: 206.0/255, alpha: 1);
let AppLightGrayTextColor = UIColor(named: "AppLightGrayText") ?? UIColor(red: 213.0/255, green: 213.0/255, blue: 213.0/255, alpha: 1);
let AppPlaceholderColor = UIColor(red: 225.0/255, green: 225.0/255, blue: 225.0/255, alpha: 1);
let AppDefualtTextColor = UIColor.white;

let AppGradiant1 = UIColor(red: 2.0/255, green: 92.0/255, blue: 212.0/255, alpha: 1);
let AppGradiant2 = UIColor(red: 17.0/255, green: 201.0/255, blue: 103.0/255, alpha: 1);

let AppYellow = UIColor(red: 251.0/255, green: 185.0/255, blue: 5.0/255, alpha: 1);

let AppBlackColor = UIColor(red: 51.0/255, green: 51.0/255, blue: 51.0/255, alpha: 1);
let AppBlackLightColor = UIColor(red: 91.0/255, green: 91.0/255, blue: 91.0/255, alpha: 1);


let kLightTheme = "LightTheme";
let kDarkTheme = "DarkTheme";

let kImageCorrectTick = UIImage(named: "rightBlue");
let kImageWrongTick = UIImage(named: "crosRed")

