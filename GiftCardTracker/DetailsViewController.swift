//
//  DetailsViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/31/21.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var UIDLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    
    var cardForDetails: GiftCard!
    var sourceViewController: CardSpecificChooseActionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = cardForDetails.background_color?.uiColor
        createLabels()
        

        // Do any additional setup after loading the view.
    }
    
    func createLabels() {
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        //let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "copperPlate", size: 17.0)]
        // UID label
        let uidString = "ID: " + String(cardForDetails!.uid)
        let uidattributedString = NSMutableAttributedString(string: uidString)
        uidattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 2))
        //uidattributedString.addAttributes(fontAttribute as [NSAttributedString.Key : UIFont?] as [NSAttributedString.Key : Any], range: NSMakeRange(4, uidString.count - 1))
        UIDLabel.attributedText! = uidattributedString
        
        //location label
        let locationString = "Location: " + cardForDetails.resturant_name!
        let locationattributedString = NSMutableAttributedString(string: locationString)
        locationattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 8))
        //locationattributedString.addAttributes(fontAttribute as [NSAttributedString.Key : font], range: NSMakeRange(10, locationString.count - 1))
        locationLabel.attributedText! = locationattributedString
        
        // amountLabel
        let amountString = "Balance: " + convertToDollarAmount(amount: cardForDetails!.amount_left)
        let amountAttributedString = NSMutableAttributedString(string: amountString)
        amountAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 7))
        //amountAttributedString.addAttributes(fontAttribute as [NSAttributedString.Key : font], range: NSMakeRange(9, amountString.count - 1))
        amountLabel.attributedText! = amountAttributedString
        
        // card number label
        if (cardForDetails!.card_number != nil) {
            let cardNumberString = "Card Number: " + String(cardForDetails.card_number!)
            let cardNumberAttributedString = NSMutableAttributedString(string: cardNumberString)
            cardNumberAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 11))
            //cardNumberAttributedString.addAttributes(fontAttribute as [NSAttributedString.Key : font], range: NSMakeRange(12, cardNumberString.count - 1))
            cardNumberLabel.attributedText! = cardNumberAttributedString
        } else {
            cardNumberLabel.text! = ""
        }
    }
    
    func convertToDollarAmount(amount : Float) -> String {
        let stringAmount = String(format: "$%.02f", amount)
        return stringAmount
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
