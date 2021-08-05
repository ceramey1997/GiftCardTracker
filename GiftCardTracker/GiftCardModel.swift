//
//  GiftCardModel.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/27/21.
//

import Foundation
import UIKit.UIColor

class GiftCardModel: NSObject, NSCoding {
    var restaurantName:String?
    var uid:Int64?
    var amount_left: Float?
    var card_number: String?
    var background_color: SerializableColor?
    
    override init() {
        
    }
    
    required init?(coder aDecoder : NSCoder) {
        self.restaurantName = aDecoder.decodeObject(forKey: "resturant_name") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as? Int64
        self.amount_left = aDecoder.decodeObject(forKey: "amount_left") as? Float
        self.card_number = aDecoder.decodeObject(forKey: "card_number") as? String
        self.background_color = aDecoder.decodeObject(forKey: "background_color") as? SerializableColor
        //name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        //image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.restaurantName, forKey: "resturant_name")
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.amount_left, forKey: "amount_left")
        aCoder.encode(self.card_number, forKey: "card_number")
        aCoder.encode(self.background_color, forKey: "background_color")
    }
    
    
}
/*
extension GiftCardModel {
    init (giftcard:GiftCardModel) {
        self.restaurantName = giftcard.restaurantName
        self.uid = giftcard.uid
        self.amount_left = giftcard.amount_left
        if (self.card_number != "") {
            self.card_number = giftcard.card_number
        }
        self.background_color = giftcard.background_color
    }
}
*/
