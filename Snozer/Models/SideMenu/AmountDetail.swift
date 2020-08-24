//
//	AmountDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class AmountDetail : NSObject, Mappable{

    var bAmount : Any?
	var bonusAmount : Double{
        if let e = bAmount as? String{
            return Double(e)!;
        }
        if let e = bAmount as? Int{
            return Double(e);
        }
        if let e = bAmount as? Double{
            return e;
        }
        
        return 0;
    }
    var dAmount: Any?
	var depositAmount : Double{
        if let e = dAmount as? String{
            return Double(e)!;
        }
        if let e = dAmount as? Int{
            return Double(e);
        }
        if let e = dAmount as? Double{
            return e;
        }
        return 0;
    }
    var pWAmount: Any?
	var pendingWidAmount : Double{
        if let e = pWAmount as? String{
            return Double(e)!;
        }
        if let e = pWAmount as? Int{
            return Double(e);
        }
        
        if let e = pWAmount as? Double{
            return e;
        }
        
        return 0;
    }
    var wAmount: Any?
	var winningAmount : Double{
        if let e = wAmount as? String{
            return Double(e)!;
        }
        if let e = wAmount as? Int{
            return Double(e);
        }
        
        if let e = wAmount as? Double{
            return e;
        }
        return 0;
    }
    var totalAmount: Double = 0;

    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        bAmount <- map["bonus_wallet"];
        dAmount <- map["deposit_wallet"];
        wAmount <- map["winning_wallet"];
        pWAmount <- map["pending_wid_amount"];
    }

}

class ContestAmountDetail : NSObject, Mappable{

    var aSuggest : [Any?] = []
    var amountSuggest : [Double]{
        if let e = aSuggest as? [String]{
            return e.map({Double($0)!})
        }
        if let e = aSuggest as? [Int]{
            return e.map({Double($0)})
        }
        
        if let e = aSuggest as? [Double]{
            return e
        }
        
        return [];
    }
    var eFees : Any?
    var entryFees : Double{
        if let e = eFees as? String{
            return Double(e)!;
        }
        if let e = eFees as? Int{
            return Double(e);
        }
        if let e = eFees as? Double{
            return e;
        }
        return 0;
    }
    var nPay: Any?
    var needPay : Double{
        if let e = nPay as? String{
            return Double(e)!;
        }
        if let e = nPay as? Int{
            return Double(e);
        }
        if let e = nPay as? Double{
            return e;
        }
        return 0;
    }
    var tPay: Any?
    var toPay : Double{
        if let e = tPay as? String{
            return Double(e)!;
        }
        if let e = tPay as? Int{
            return Double(e);
        }
        if let e = tPay as? Double{
            return e;
        }
        return 0;
    }
    var uBonus: Any?
    var usedBonus: Double{
        if let e = uBonus as? String{
            return Double(e)!;
        }
        if let e = uBonus as? Int{
            return Double(e);
        }
        if let e = uBonus as? Double{
            return e;
        }
        return 0;
    }
    var uDeposit: Any?
    var usedDeposit : Double{
        if let e = uDeposit as? String{
            return Double(e)!;
        }
        if let e = uDeposit as? Int{
            return Double(e);
        }
        if let e = uDeposit as? Double{
            return e;
        }
        return 0;
    }
    var uWinning: Any?
    var usedWinning : Double{
        if let e = uWinning as? String{
            return Double(e)!;
        }
        if let e = uWinning as? Int{
            return Double(e);
        }
        if let e = uWinning as? Double{
            return e;
        }
        return 0;
    }
    var wallet: AmountDetail?;

    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        aSuggest <- map["amount_suggest"];
        eFees <- map["entry_fees"];
        nPay <- map["need_pay"];
        tPay <- map["to_pay"];
        uBonus <- map["used_bonus"];
        uDeposit <- map["used_deposit"];
        uWinning <- map["used_winning"];
        wallet <- map["wallet"];
        
        
    }

}
