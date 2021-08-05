//
//  SubtractViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/28/21.
//

import UIKit
class SubtractViewController: UIViewController, UITextFieldDelegate {

    var cardToEdit : GiftCard!
    var sourceViewController : CardSpecificChooseActionViewController!
    var newAmount : Float!
    
    var currentAmt : Int = 0
    
    @IBOutlet weak var amountSpentOutlet: UITextField!
    @IBOutlet weak var uidOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var balanceOutlet: UILabel!
    @IBOutlet weak var cardNumberOutlet: UILabel!
    
    
    @IBAction func SaveButtonAction(_ sender: UIBarButtonItem) {
        print("I am here!!! in the SaveButtonAction")
        determineNewAmountAction()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = cardToEdit.background_color?.uiColor
        
        amountSpentOutlet.delegate = self
        amountSpentOutlet.placeholder = updateAmount()
        createLabels()
        
    }
    
    func createLabels() {
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        //let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "copperPlate", size: 17.0)]
        
        // UID label
        let uidString = "ID: " + String(cardToEdit!.uid)
        let uidattributedString = NSMutableAttributedString(string: uidString)
        uidattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 2))
        //uidattributedString.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(4, uidString.count))

        uidOutlet.attributedText! = uidattributedString
        
        //location label
        let locationString = "Location: " + cardToEdit.resturant_name!
        let locationattributedString = NSMutableAttributedString(string: locationString)
        locationattributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 8))
        //locationattributedString.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(10, locationString.count))
        locationOutlet.attributedText! = locationattributedString
        
        // amountLabel
        let amountString = "Balance: " + convertToDollarAmount(amount: cardToEdit!.amount_left)
        let amountAttributedString = NSMutableAttributedString(string: amountString)
        amountAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 7))
        //amountAttributedString.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(9, amountString.count))
        balanceOutlet.attributedText! = amountAttributedString
        
        // card number label
        if (cardToEdit!.card_number != nil) {
            let cardNumberString = "Card Number: " + String(cardToEdit.card_number!)
            let cardNumberAttributedString = NSMutableAttributedString(string: cardNumberString)
            cardNumberAttributedString.addAttributes(boldFontAttribute, range: NSMakeRange(0, 11))
            //cardNumberAttributedString.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(12, cardNumberString.count))
            cardNumberOutlet.attributedText! = cardNumberAttributedString
        } else {
            cardNumberOutlet.text! = ""
        }
    }
    
    @IBAction func onTapGestureRecognized(_ sender: Any) {
        amountSpentOutlet.resignFirstResponder()
    }
    
    @IBAction func didExitEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    // MARK: - Currency Formatting Things
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            currentAmt = currentAmt * 10 + digit
            amountSpentOutlet.text = updateAmount()
        }
        if string == "" {
            currentAmt = currentAmt / 10
            amountSpentOutlet.text = updateAmount()
        }
        return false
    }
    
    func formatBalance() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amount = cardToEdit!.amount_left
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    func updateAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amount = Double(currentAmt/100) + Double(currentAmt%100)/100
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    func currentAmountValueToFloat() -> Float {
        let amount = Double(currentAmt/100) + Double(currentAmt%100)/100
        return Float(amount)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "cancelSubtractSegue":
            print("cancel subtract")
        default:
            print("I'm Propably here because im calling fromViewToExit segue with the save button and there is no preperation to be done.")
        }
    }
    
    func determineNewAmountAction() {
        let oldAmount = cardToEdit!.amount_left
        let amountSpent : Float = currentAmountValueToFloat()
        
        if (oldAmount < amountSpent) {
            //send a notification that input'd amount is more than remaining amount
            print("Amount Spent is more than Remaining Amount")
            presentSubtractedToMuchMoneyAlert()
        } else if ((oldAmount - amountSpent) < 1) {
            presentTheAlert()
            //CoreDataManager.shared.deleteAGiftCard(cardToDelete: cardToEdit)
        } else {
            print("i am now setting the new amount...")
            setNewAmount()
            //self.performSegue(withIdentifier: "goBack", sender: self)
            //self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteCardLessThanOneDollar() {
        CoreDataManager.shared.deleteAGiftCard(cardToDelete: self.cardToEdit!)
    }
    
    func setNewAmount() {
        let newAmount = cardToEdit!.amount_left - currentAmountValueToFloat()
        saveEditItem(newAmount: newAmount)
    }
    
    func saveEditItem(newAmount: Float) {
        CoreDataManager.shared.editAmountGiftCard(amount: newAmount, giftCardToEdit: cardToEdit!)
    }
    
    func presentTheAlert() {
        let msg = "Amount Left is Less than $1.00, would you like to delete the current card?"
        let controller = UIAlertController(title: "Remove?", message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.deleteCardLessThanOneDollar()
            self.dismiss(animated: true, completion: nil)
        })
        
        let noAction = UIAlertAction(title: "No", style: .destructive, handler: {action in
            self.setNewAmount()
            self.dismiss(animated: true, completion: nil)
        })
        
        //Adds the yes and no actions to the controller
        controller.addAction(yesAction)
        controller.addAction(noAction)
        
        //if the controller is a popoverpresentationcontroller (witch it should be)
        //we'll set the size of the sender to be its bounds, so that the dialog won't be bigger than the view
        if let ppc = controller.popoverPresentationController {
            ppc.sourceView = self.view
            ppc.sourceRect = self.view.bounds
        }
        
        //this makes it display the controller.
        present(controller, animated: true, completion: nil)
    }
    
    func presentSubtractedToMuchMoneyAlert() {
        let msg = "Subtracted Amount is more than the curent amount."
        let controller = UIAlertController(title: "Invalid Entry", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        
        controller.addAction(okAction)
        
        if let ppc = controller.popoverPresentationController {
            ppc.sourceView = self.view
            ppc.sourceRect = self.view.bounds
        }
        present(controller, animated: true, completion: nil)
    }
    
    func convertToDollarAmount(amount : Float) -> String {
        let stringAmount = String(format: "$%.02f", amount)
        return stringAmount
    }

}
