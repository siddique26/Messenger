//
//  helper.swift
//  Messenger
//
//  Created by Siddique on 10/02/18.
//  Copyright © 2018 Siddique. All rights reserved.
//

import UIKit
import CoreData

extension  FriendViewController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let enitityNames = ["Friend", "Message"]
                for entityName in enitityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try(context.fetch(fetchRequest))
                    for object in objects {
                        context.delete(object as! NSManagedObject)
                    }
                }
                try(context.save())
            } catch let error {
                print(error)
            }
        }
    }
    
    func setupData(){
        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zukerberg"
            mark.profileImageName = "zuckprofile"
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = mark
        message.text = "Hello, my name is Mark! Nice to meet you."
            message.time = NSDate() as Date
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
            FriendViewController.createMessageWithText("Good Morning", steve, 2, context)
            FriendViewController.createMessageWithText("I'm Steve Jobs", steve, 1, context)
            FriendViewController.createMessageWithText("Are you interested in buying an Apple device? We have a wide variety of Apple devices that will suit your needs.  Please make your purchase with us.", steve, 1, context)
            FriendViewController.createMessageWithText("Yes. I would love to buy iPhone X", steve, 1, context, isSender: true)
            FriendViewController.createMessageWithText("Totally understand that you want the new iPhone 7, but you'll have to wait until September for the new release. Sorry but thats just how Apple likes to do things.", steve, 1, context)
            FriendViewController.createMessageWithText("Absolutely, I'll just use my gigantic iPhone 6 Plus until then!!!", steve, 1, context, isSender: true)
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "donald_trump_profile"
            FriendViewController.createMessageWithText("bruh", donald, 5, context)
        let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
            FriendViewController.createMessageWithText("Love, Peace, and Joy", gandhi, 60 * 24, context)
        
        let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        hillary.name = "Hillary Clinton"
        hillary.profileImageName = "hillary_profile"
        
            FriendViewController.createMessageWithText("Please vote for me, you did for Billy!", hillary, 20 * 60 * 24, context)
            do{
               try(context.save())
            } catch let error {
                print(error)
            }
//        messages = [message, messageSteve]
        }
        loadData()
    }
    
   static func createMessageWithText(_ text: String, _ friend: Friend,_ minuesAgo: Double,_ context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.time = NSDate().addingTimeInterval(-minuesAgo * 60) as Date
        message.isSender = NSNumber(booleanLiteral: isSender) as! Bool
        return message
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
           if let  friends = fetchFriend() {
                messages = [Message]()
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do{
                        let fetchMessage = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchMessage!)
                    } catch let error {
                        print(error)
                    }
                }
            messages = messages?.sorted(by: {$0.time!.compare($1.time!) == .orderedDescending})
            }
        }
    }
    func fetchFriend() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                return try(context.fetch(request)) as? [Friend]
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}

