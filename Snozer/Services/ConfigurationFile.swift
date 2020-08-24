//
//  ConfigurationFile.swift
//  Cricshot
//
//  Created by SVAP's iMac on 17/05/19.
//  Copyright © 2019 SVAP Infotech. All rights reserved.
//

import Foundation
import UIKit

//MARK: - App URL / Sub URL
struct APPURL {

//    static let BaseURL = "http://139.162.28.58/snozer/admin/apis/"        /////---Local
		static let BaseURL =  "https://dev.rglabs.net/repos/snozer/wwwbackup/www/html/admin/apis/"
    /////---Live
//   http://dev.rglabs.net/repos/snozer/wwwbackup/www/html/admin/apis/mobile/v1/get_match_contest/117/45330
//"https://www.snozer.com/admin/apis/"
    static let CricketUrl = "mobile/v1/"
    static let KabaddiUrl = "mobile_kb/v1/"
    static let FootBallUrl = "mobile_soccer/v1/"
    
    static let LoginAPI =  BaseURL + CricketUrl + "login"
    static let OTPVerificationAPI =  BaseURL + CricketUrl + "verifyotp"
    static let SocialLogin =  BaseURL + CricketUrl + "social_login"
    static let RegisterAPI =  BaseURL + CricketUrl + "newuser"
    static let OtpSend = BaseURL + CricketUrl + "send_otp_mobile"
    static let ResetPasswordAPI = BaseURL + CricketUrl + "forgotpassword_email"
    static let UserCheck =  BaseURL + CricketUrl + "check_user"
    static let ProfilePictures = BaseURL + CricketUrl + "get_profile_pictures"
    static let SetProfilePicture = BaseURL + CricketUrl + "change_profile_picture"
    
    // Home
    static let GetMatchList = "get_matches";
    static let GetHeaderImage = "get_slider";
    static let GetContest = "get_match_contest";
    static let GetMatchPalyers = "get_match_players";
    static let GetCustomerContest = "get_customer_match_contest";
    static let GetWinningBreakUpData =  "get_contest_winner_breakup";
    static let CustomerMatches = "get_customer_matches";
    static let CustomerMatchContest = "get_customer_match_contest";
    
    static let MatchPlayerStats = "get_match_players_stats";
    static let DreamTeamStats = "get_match_dream_team_stats";
    static let CreateTeamPlayerStats = "get_series_by_player_statistics";
    static let CustomerTeamStats = "get_customer_match_team_stats"
    
    
    
    static let GetMatchScore = "get_match_score";
    static let GetContestTeam = "get_contest_teams";
    static let GetContestDetail = "get_match_contest_detail"
    static let leaderboarddownload = "get_match_contest_pdf"
    
    static let CreateCustomerTeam = "create_customer_team"
    static let UpdateCustomerTeam = "update_customer_team"
    
    static let PreJoinContest = "customer_pre_join_contest";
    static let CustomerJoinContest = "customer_join_contest";
    static let SwitchTeam = "customer_switch_team";
    
    //Contest
    static let DownloadTeamPdf = BaseURL + "home/download-pdf/"
    static let ContestShareDetail = "get_match_contest_share_detail";

    
    
    //Private
    static let PrivateSettings = "get_private_contest_settings";
    static let PrivateEntreeCalculate = "get_private_contest_entry_fee";
    static let PrivateChooseWinningBreakup = "get_private_contest_winning_breakup";
    static let PrivateCreateContest = "create_private_contest";
    static let CreatedTeamCount = "get_already_created_team_count";
    static let SlugContestDetail = "get_match_private_contest_detail";
    
    
    // Account
    static let WalletInfo = "get_customer_wallet_detail";
    static let GetProfile = "get_profile";
    static let GetPlayingHistory = "get_playing_history";
    static let AdduserBalance = "wallet_recharge";
    static let ApplyPromoCode = "apply_promocode";
    static let Withdrawal = "customer_withdraw_amount";
    static let GetGames = "get_games";
    
    static let UploadPanCard = BaseURL + appdelegate.matchTypeUrl + "add_pancard"
    static let UploadBankProof = BaseURL + appdelegate.matchTypeUrl + "add_bankdetail"
    
    static let VerifyEmail = BaseURL + appdelegate.matchTypeUrl + "update_verify_email";
static let VerifyMobile = BaseURL + appdelegate.matchTypeUrl + "update_verify_mobile";
    
//
	
    static let getCustomIcons = "get_app_custom_icons";
    static let UpdateUserProfile = "update_profile"
    static let GetStateList =  "states/1"
    static let ChangePassword = "change_password"
    
    static let GetSeries = "get_series";
    static let GetSeriesLeaderboard = "get_series_leaderboard";
    static let GetSeriesCustomerMatches = "get_series_leaderboard_customer_matches";
    static let GetWithdaralHistory = "get_customer_withdraw_history";
    static let GetWalletHistory = "get_customer_wallet_history_filter";
    static let GetNotification = "get_notifications";
    
    //Follow and Followers
    static let GetCustomers = "get_customers";
    static let FollowNUnFollow = "follow_unfollow_customer";
    static let CustomerProfile = "get_customer_profile";
    
    //Post Releated Mathods
    static let PostList = "get_customer_posts";
    static let ReactionList = "get_reactions";
    static let CreatePost = "create_post";
    static let PostReact = "react_post";
    static let CustomerPostReaction = "get_customer_posts_user_reaction";
    static let CustomerFeeds = "get_customer_feeds";
    
    
    //Team
    
    static let MyTeams = "get_customer_match_teams";
    static let CustomerTeamDetail = "get_customer_match_team_detail"
    static let TopTeam = "get_match_dream_team_detail"
    
    
    //More
    static let RefereDetailCash = "get_refer_earn_detail_cash";
    static let RefereDetail = "get_refer_earn_detail";
    static let GerReferEarn = "get_refer_earn";
    static let GetCustomerEnquiry = "create_customer_enquiry";
    
    static let UpdateNotificationUpdate = BaseURL + appdelegate.matchTypeUrl + "update_token";
    
    static let UpdateReferralCodeUpdate = BaseURL + appdelegate.matchTypeUrl + "updateReferralCode";
    
}

//MARK: - App Color
struct APPCOLOR {
    static let greenCustom = UIColor(red: 25.0 / 255.0, green: 186.0 / 255.0, blue: 82.0 / 255.0, alpha: 1.0)
    static let redCustom = UIColor(red: 202.0/255, green: 33.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
    static let BlueCustom = UIColor(red: 71.0 / 255.0, green: 90.0 / 255.0, blue: 148.0/255, alpha: 1.0)
    static let OrangeCustom = UIColor(red: 210.0 / 255.0, green: 140.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
    static let BlueTintCustom = UIColor(red: 7.0 / 255.0, green: 124.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    static let YellowCustom = UIColor(red: 254.0/255, green: 203.0/255, blue: 47.0/255, alpha: 1);
    static let BgColor = UIColor(red: 245.0 / 255.0, green: 247.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    static let CustomWhiteColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    
    static let TextBlackColor = UIColor.black;
    static let TextLightGrayColor = UIColor.lightGray;
    static let TextDarkGrayColor = UIColor.darkGray;
    static let TextGrayColor = UIColor.gray;
    static let TextWhiteColor = UIColor.white;
}

//MARK: - Web URL
struct WebURL {
//    static let BaseURL = "http://139.162.28.58/snozer/admin/m/pages/" // Test
    static let BaseURL = "https://www.snozer.com/admin/m/pages/" // Live
    static let TermsAndCondition = BaseURL + "terms-conditions.html"
    static let FantasyPointSystem = BaseURL + "point-sysytem.html"
    static let Faq = BaseURL + "faq.html"
    static let HowToPlay = BaseURL + "index.html#how-to-play"
    static let AboutUs = BaseURL + "about-us.html"
    static let Legality = BaseURL + "legalities-webview.html"
    static let PrivacyPolicy = BaseURL + "privacy-policy.html"
    static let Blog = BaseURL + "blogs"
}
