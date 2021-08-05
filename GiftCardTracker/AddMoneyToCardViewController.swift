//
//  AddMoneyToCardViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/31/21.
//

import UIKit

class AddMoneyToCardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var moneyToAddTextField: UITextField!
    @IBOutlet weak var UIDOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var previousAmountOutlet: UILabel!
    @IBOutlet weak var cardNumberOutlet: UILabel!
    
    var cardToAddMoneyTo : GiftCard!
    var sourceViewController : CardSpecificChooseActionViewController!
    var currentAmt : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = cardToAddMoneyTo.background_color?.uiColor
        createLabels()
        
        moneyToAddTextField.delegate = self
        moneyToAddTextField.placeholder = updateAmount()

        // Do any additional setup after loading the view.
    }
    @IBAction func tapGestureRecognized(_ sender: Any) {
        moneyToAddTextField.resignFirstResponder()
    }
    
    @IBAction func didExitAfterEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func createLabels() {
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        // UID label
        let uidString = "ID: " + String(cardToAddMoneyTo!.uid)
        let uidattributedString = NSMutableAttributedString(string: uidString)
        uidattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 2))
        UIDOutlet.attributedText! = uidattributedString
        
        //location label
        let locationString = "Location: " + cardToAddMoneyTo.resturant_name!
        let locationattributedString = NSMutableAttributedString(string: locationString)
        locationattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 8))
        locationOutlet.attributedText! = locationattributedString
        
        // amountLabel
        let amountString = "Balance: " + convertToDollarAmount(amount: cardToAddMoneyTo!.amount_left)
        let amountAttributedString = NSMutableAttributedString(string: amountString)
        amountAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 7))
        previousAmountOutlet.attributedText! = amountAttributedString
        
        // card number label
        if (cardToAddMoneyTo!.card_number != nil) {
            let cardNumberString = "Card Number: " + String(cardToAddMoneyTo.card_number!)
            let cardNumberAttributedString = NSMutableAttributedString(string: cardNumberString)
            cardNumberAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 11))
            cardNumberOutlet.attributedText! = cardNumberAttributedString
        } else {
            cardNumberOutlet.text! = ""
        }
    }
    
    // MARK: - Amount Text Field Things
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            currentAmt = currentAmt * 10 + digit
            moneyToAddTextField.text = updateAmount()
        }
        if string == "" {
            currentAmt = currentAmt / 10
            moneyToAddTextField.text = updateAmount()
        }
        return false
    }
    
    func updateAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amount = Double(currentAmt/100) + Double(currentAmt%100)/100
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    func setNewAmount() {
        //newAmount = cardToEdit.amount_left - Float(amountSpentOutlet.text!)!
        let newAmount = cardToAddMoneyTo!.amount_left + currentAmountValueToFloat()
        saveEditItem(newAmount: newAmount)
        //twoBackSourceViewController?.reloadAllGiftCards()
        //twoBackSourceViewController?.tableView.reloadData()
    }
    
    func currentAmountValueToFloat() -> Float {
        let amount = Double(currentAmt/100) + Double(currentAmt%100)/100
        return Float(amount)
    }
    
    func saveEditItem(newAmount: Float) {
        CoreDataManager.shared.editAmountGiftCard(amount: newAmount, giftCardToEdit: cardToAddMoneyTo!)
    }
    
    func convertToDollarAmount(amount : Float) -> String {
        let stringAmount = String(format: "$%.02f", amount)
        return stringAmount
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "addMoneySaveSegue":
            setNewAmount()
        default:
            print("I'm in default, in AddMoneyToGiftCard")
        }
    }

}
