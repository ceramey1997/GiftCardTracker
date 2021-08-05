//
//  CardSpecificChooseActionViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/31/21.
//

import UIKit

class CardSpecificChooseActionViewController: UIViewController {

    @IBOutlet weak var viewDetailsButtonOutlet: UIButton!
    @IBOutlet weak var subtractMoneyButtonOutlet: UIButton!
    @IBOutlet weak var addMoneyToCardButtonOutlet: UIButton!
    @IBOutlet weak var adjustAmountButtonOutlet: UIButton!
    
    var cardToEdit : GiftCard!
    var sourceViewController: TableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let color = cardToEdit.background_color as? UIColor
        //self.view.backgroundColor = color?.withAlphaComponent(0.75)
        self.view.backgroundColor = cardToEdit.background_color?.uiColor
        // button config
        self.configureButtons()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "subtractAmount":
            let subtractViewNavigator = segue.destination as! UINavigationController
            let dest = subtractViewNavigator.viewControllers[0] as! SubtractViewController
            dest.cardToEdit = cardToEdit
            dest.sourceViewController = self
        case "showDetailsIdentifier":
            let detailsView = segue.destination as! DetailsViewController
            detailsView.cardForDetails = cardToEdit
            detailsView.sourceViewController = self
        case "addMoneyToCardSegue":
            let addViewNavigator = segue.destination as! UINavigationController
            let dest = addViewNavigator.viewControllers[0] as! AddMoneyToCardViewController
            dest.cardToAddMoneyTo = cardToEdit
            dest.sourceViewController = self
        case "adjustAmountSegue":
            let adjustViewNavigator = segue.destination as! UINavigationController
            let dest = adjustViewNavigator.viewControllers[0] as! AdjustAmountViewController
            dest.cardToAdjustAmount = cardToEdit
            dest.sourceViewController = self
        case "goBackSegue":
            sourceViewController.reloadAllGiftCards()
            sourceViewController.tableView.reloadData()
        default:
            print("oh no shouldnt be here")
        }
    }
    
    func configureButtons() {
        // button config
        viewDetailsButtonOutlet.layer.cornerRadius = 10
        viewDetailsButtonOutlet.layer.borderWidth = 1
        viewDetailsButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        subtractMoneyButtonOutlet.layer.cornerRadius = 10
        subtractMoneyButtonOutlet.layer.borderWidth = 1
        subtractMoneyButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        addMoneyToCardButtonOutlet.layer.cornerRadius = 10
        addMoneyToCardButtonOutlet.layer.borderWidth = 1
        addMoneyToCardButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        adjustAmountButtonOutlet.layer.cornerRadius = 10
        adjustAmountButtonOutlet.layer.borderWidth = 1
        adjustAmountButtonOutlet.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func unwindLocationCancel(UnwindSegue: UIStoryboardSegue) {
        
    }

}
