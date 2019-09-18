//
//  DBUtil.swift
//  Notes
//
//  Created by Андрей Олесов on 9/8/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DBUtil{
    
    static func saveNote(noteToSave:BlackNote){
        print("Added id = \(noteToSave.id)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        
        
        let note = NSManagedObject(entity: noteEntity, insertInto: managedContext)
        note.setValue(noteToSave.id, forKey: "id")
        note.setValue(noteToSave.text, forKey: "text")
        note.setValue(noteToSave.date.toString(withTime: false), forKey: "date")
        note.setValue(noteToSave.statusInInt(), forKey: "status")
        if let image = noteToSave.image{
            let imageData: NSData = image.pngData()! as NSData
            note.setValue(imageData, forKey: "image")
        }
        if let remind = noteToSave.remind{
            note.setValue(remind.toString(withTime: true), forKey: "remind")
        }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func retrieveNotes() -> [BlackNote]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [BlackNote]()}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var notes = [BlackNote]()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let text = data.value(forKey: "text") as! String
                let date = data.value(forKey: "date") as! String
                let status = data.value(forKey: "status") as! Int16
                let image = data.value(forKey: "image") as? Data
                let remind = data.value(forKey: "remind") as? String
                let id = data.value(forKey: "id") as! Int16
                var imagePNG:UIImage? = nil
                if image != nil {
                    imagePNG = UIImage(data:image! ,scale:1.0)
                }
                notes.append(BlackNote(id: Int(id), text: text, date: date.toDate()!, status: status.toStatus()!, remind: remind?.toDateTime(), image: imagePNG))
            }
            return notes
        } catch {
            
            print("Failed")
        }
        return [BlackNote]()
    }
    
    static func deleteNote(id: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                if id == data.value(forKey: "id") as! Int16 {
                    managedContext.delete(data)
                }
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            return
        } catch {
            
            print("Failed")
        }
        
    }
    
    static func updateNote(newNote: BlackNote){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Note")
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for objectUpdate in result as! [NSManagedObject] {
                if newNote.id == objectUpdate.value(forKey: "id") as! Int16 {
                    objectUpdate.setValue(newNote.text, forKey: "text")
                    objectUpdate.setValue(newNote.date.toString(withTime:false), forKey: "date")
                    objectUpdate.setValue(newNote.statusInInt(), forKey: "status")
                    if let image = newNote.image{
                        let imageData: NSData = image.pngData()! as NSData
                        objectUpdate.setValue(imageData, forKey: "image")
                    }
                    if let remind = newNote.remind{
                        objectUpdate.setValue(remind.toString(withTime:true), forKey: "remind")
                    } else {
                        objectUpdate.setValue(nil, forKey: "remind")
                    }
                }
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            return
        } catch {
            
            print("Failed")
        }
        
    }
}
