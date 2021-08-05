//
//  TableViewController.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/27/21.
//

import UIKit

class TableViewController: UITableViewController {

    var giftCards: [GiftCard] = []
    var selectedCell : Int = 0
    
    func reloadAllGiftCards() {
        giftCards = CoreDataManager.shared.grabAllGiftCards()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false

        reloadAllGiftCards()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return giftCards.count
    }
    /*
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(20)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView
        
    }*/

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardEntryIdentifier", for: indexPath) as! GiftCardTableViewCell
        let item = giftCards[indexPath.row]
        
        cell.UIDOutlet!.text = String(item.uid)
        cell.restrauntOutlet!.text = item.resturant_name
        cell.amountOutlet!.text = convertToDollarAmount(amount: item.amount_left)
        cell.setNeedsLayout()
        // add border and color
        cell.backgroundColor = item.background_color?.uiColor
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.selectedCell = indexPath.row
        self.performSegue(withIdentifier: "singleGiftCardChooseSegue", sender: self)
    }
    
    private func deleteAction(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self](_, _, _) in
            guard let self = self else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        giftCards = CoreDataManager.shared.grabAllGiftCards()
        let delete = self.deleteAction(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        let cardToRemove : GiftCard = self.giftCards[indexPath.row]
        
        CoreDataManager.shared.deleteAGiftCard(cardToDelete: cardToRemove)
        giftCards = CoreDataManager.shared.grabAllGiftCards()
        //self.tableView.reloadData()
        
        return swipe
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let uuidToDelete = giftCards[indexPath.row].uuid
            let cardToRemove = CoreDataManager.shared.getSingleCard(uuid: uuidToDelete!)
            CoreDataManager.shared.deleteAGiftCard(cardToDelete: cardToRemove)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
*/
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "ToNewGiftCardSegue":
            let newGiftCardViewController = segue.destination as! UINavigationController
            let dest = newGiftCardViewController.viewControllers[0] as! NewGiftCardEntryViewController
            dest.sourceViewController = self
            dest.currentAllGiftCards = giftCards
            //assign any variables in the destination... i.e.: dest.whatever = whoever
        case "singleGiftCardChooseSegue":
            //let subViewController = segue.destination as! UINavigationController
            //let dest = subViewController.viewControllers[0] as! SubtractViewController
            let singleCardChoose = segue.destination as! UINavigationController
            let dest = singleCardChoose.viewControllers[0] as! CardSpecificChooseActionViewController
            // determine card that was selected and pass it to the SubtractViewController
            //let giftCardToEditUUID : UUID = giftCards[selectedCell].uuid!
            //let cardToEdit : GiftCard = CoreDataManager.shared.getSingleCard(uuid: giftCardToEditUUID)
            let cardToEdit : GiftCard = self.giftCards[self.selectedCell]
            // assign cardToEdit and sourceViewController to localVariables in the sourceViewController
            dest.cardToEdit = cardToEdit
            dest.sourceViewController = self
        //case "subtractAmountSegue":
            
        default:
            print("oh no shouldnt be here")
        }
    }
    
    @IBAction func unwindLocationCancel(UnwindSegue: UIStoryboardSegue) {
        
    }
    
    func convertToDollarAmount(amount : Float) -> String {
        let stringAmount = String(format: "$%.02f", amount)
        return stringAmount
    }
    

}
