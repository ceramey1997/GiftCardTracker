//
//  NewGiftCardEntryViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/27/21.
//

import UIKit
import Combine

class NewGiftCardEntryViewController: UIViewController, UITextFieldDelegate {

    // UI Outlets
    @IBOutlet weak var restrauntTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var chooseColorButtonOutlet: UIButton!
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    // Segue related var's
    var color: UIColor!
    var cancellable: AnyCancellable?
    var sourceViewController : TableViewController!
    var currentAllGiftCards : [GiftCard]!
    var uidForCurrentCardAdd : Int!
    var currentAmt : Int = 0
    var newCardNumber : String = ""
    var chooseColor : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uidLabel.text! = String(determineNextUID())
        amountTextField.delegate = self
        amountTextField.placeholder = updateAmount()
        
        // button config
        chooseColorButtonOutlet.layer.cornerRadius = 5
        chooseColorButtonOutlet.layer.borderWidth = 1
        chooseColorButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        // save button config
        saveButtonOutlet.layer.cornerRadius = 5
        saveButtonOutlet.layer.borderWidth = 1
        saveButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Color Choosing Functions
    @IBAction func chooseBackgroundColor(_ sender: UIButton) {
        // Initializing Color Picker
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false

        // Setting the Initial Color of the Picker
        picker.selectedColor = self.view.backgroundColor!
        self.cancellable = picker.publisher(for: \.selectedColor)
                .sink { color in
                    
                    //  Changing view color on main thread.
                    DispatchQueue.main.async {
                        self.view.backgroundColor = color
                        self.color = color
                        self.chooseColor = true
                    }
                }
        // Presenting the Color Picker
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func saveItemAction(_ sender: Any) {
        if (self.chooseColor == false) {
            presentTheAlert()
            return
        }
        cardNumberCheck()
        saveNewItem(uid: Int64(uidForCurrentCardAdd), resturaunt: restrauntTextField.text!, amount: currentAmountValueToFloat(), cardNumber: newCardNumber, color: self.color)
        sourceViewController?.reloadAllGiftCards()
        sourceViewController?.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "saveNewGiftCardSegue", sender: self)
    }
    
    // MARK: - Text Field Functions
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func onTapGestureRecognized(_ sender: Any) {
        restrauntTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
        cardNumberTextField.resignFirstResponder()
    }
    @IBAction func textFieldFinishedChanges(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            currentAmt = currentAmt * 10 + digit
            amountTextField.text = updateAmount()
        }
        if string == "" {
            currentAmt = currentAmt / 10
            amountTextField.text = updateAmount()
        }
        return false
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
    
    // Need to determine what the next UID can be.
    func determineNextUID() -> Int {
        var nextUID = currentAllGiftCards.count + 1
        for singleGiftCard : GiftCard in currentAllGiftCards {
            if (singleGiftCard.uid == nextUID) {
                nextUID+=1
            }
        }
        uidForCurrentCardAdd = nextUID
        return nextUID
    }
    
    //could add some error checking to ensure that the card number follows the correct param's
    func cardNumberCheck() {
        if (cardNumberTextField.text! != "") {
            newCardNumber = cardNumberTextField.text!
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "saveNewGiftCardSegue":
            //need error checking because i am force unwrapping the UID and amount
            cardNumberCheck()
            saveNewItem(uid: Int64(uidForCurrentCardAdd), resturaunt: restrauntTextField.text!, amount: currentAmountValueToFloat(), cardNumber: newCardNumber, color: self.color)
            sourceViewController?.reloadAllGiftCards()
            sourceViewController?.tableView.reloadData()
            print("item saved")
        case "cancelNewGiftCardSegue":
            print("cancel click")
        default:
            print("Oh No.... This shouldn't be happening")
        }
    }
    
    func saveNewItem(uid: Int64, resturaunt: String, amount: Float, cardNumber: String? = "", color : UIColor) {
        let newGiftCard = GiftCardModel()
        newGiftCard.uid = uid
        newGiftCard.restaurantName = resturaunt
        newGiftCard.amount_left = amount
        //error checking for card number?
        if (cardNumber != "") {
            newGiftCard.card_number = cardNumber
        }
        
        newGiftCard.background_color = SerializableColor(from: color)
        //save new gift card to the core data
        CoreDataManager.shared.addGiftCard(newGiftCard)
    }
    func presentTheAlert() {
        let msg = "You Must Choose a Custom Color for a new gift card entry."
        let controller = UIAlertController(title: "Choose a color", message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Ok", style: .destructive, handler: { action in })
        
        controller.addAction(yesAction)
        
        //if the controller is a popoverpresentationcontroller (witch it should be)
        //we'll set the size of the sender to be its bounds, so that the dialog won't be bigger than the view
        if let ppc = controller.popoverPresentationController {
            ppc.sourceView = self.view
            ppc.sourceRect = self.view.bounds
        }
        
        //this makes it display the controller.
        present(controller, animated: true, completion: nil)
    }

}

extension NewGiftCardEntryViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            self.view.backgroundColor = viewController.selectedColor
    }
}





