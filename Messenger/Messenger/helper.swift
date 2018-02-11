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
        createMessageWithText("Good Morning", steve, 2, context)
        createMessageWithText("I'm Steve Jobs", steve, 1, context)
        createMessageWithText("Would you like to buy an Apple Device", steve, 0, context)
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "donald_trump_profile"
        createMessageWithText("bruh", donald, 5, context)
            do{
               try(context.save())
            } catch let error {
                print(error)
            }
//        messages = [message, messageSteve]
        }
        loadData()
    }
    
    func createMessageWithText(_ text: String, _ friend: Friend,_ minuesAgo: Double,_ context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.time = NSDate().addingTimeInterval(-minuesAgo * 60) as Date
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

