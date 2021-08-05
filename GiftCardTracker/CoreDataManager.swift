//
//  CoreDataManager.swift
//  GiftCardTracker
//
//  Created by Cole Ramey on 7/27/21.
//

import Foundation
import CoreData
import UIKit.UIColor

struct CoreDataManager {
    let container:NSPersistentContainer
    init() {
        container = NSPersistentContainer(name:"GiftCardModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        })
    }
    
    func addGiftCard(_ item: GiftCardModel) {
        let newGiftCard = GiftCard(context: container.viewContext)
        newGiftCard.resturant_name = item.restaurantName
        newGiftCard.uid = item.uid!
        newGiftCard.amount_left = item.amount_left!
        newGiftCard.uuid = UUID()
        if (item.card_number != "") {
            newGiftCard.card_number = item.card_number
        }
        newGiftCard.background_color = item.background_color
        //newGiftCard.id = item.uuid!
        save()
    }
    
    private func save() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func editAmountGiftCard(amount: Float, giftCardToEdit: GiftCard) {
        giftCardToEdit.amount_left = amount
        save()
    }
    
    func grabAllGiftCards() -> [GiftCard] {
        var AllGiftCardsArray: [GiftCard] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GiftCard")
        do {
            
            let fetchResults = try container.viewContext.fetch(request) as! [GiftCard]
            
            AllGiftCardsArray = fetchResults
            //AllGiftCardsArray = fetchResults as! [GiftCardModel]
        } catch let error as NSError {
            print("woe grabAllGiftCards:  \(error)")
        }
        return AllGiftCardsArray
    }
    
    func deleteAGiftCard(cardToDelete : GiftCard) {
        container.viewContext.delete(cardToDelete)
        save()
    }
    
    func getSingleCard(uuid: UUID) -> GiftCard {
        var singleGiftCard : GiftCard = GiftCard()
        
        let query = NSPredicate(format: "%K == %@", "uuid", uuid as CVarArg)
        let request : NSFetchRequest<GiftCard> = GiftCard.fetchRequest()
        request.predicate = query
        
        do {
            let foundEntities : [GiftCard] = try container.viewContext.fetch(request)
            singleGiftCard = foundEntities[0]
        } catch let error as NSError {
            print("Oh no an error when looking for Objects \(error)")
        }
        return singleGiftCard
    }
}
