//
//  ViewController.swift
//  Notes
//
//  Created by Андрей Олесов on 9/6/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController {

    @IBAction func deleteNote(_ sender: UIButton) {
   
        DBUtil.deleteNote(id: sender.tag)
        notes = DBUtil.retrieveNotes()
        
        self.notesCollection.performBatchUpdates({
             self.notesCollection.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
        //notesCollection.reloadData()
        NotificationsUtil.removeNotification(withIdentificator: [String(sender.tag)])
        
    }
    @IBOutlet weak var notesCollection: UICollectionView!
    private var notes = [BlackNote]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notes = DBUtil.retrieveNotes()
        self.notesCollection.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        notesCollection.delegate = self
        notesCollection.dataSource = self
        notes = DBUtil.retrieveNotes()
    }
    
    
    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 28)!]
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
    }
    
    
}

private let numOfNotesInLine:CGFloat = 3
private let borderWidth:CGFloat = 12

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            let controller = storyboard?.instantiateViewController(withIdentifier: "CreateNoteViewController")
                as! CreateNoteViewController
            controller.listOfNotesSize = notes.count
            navigationController?.pushViewController(controller, animated: true)
        } else{
            let controller = storyboard?.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
            print(indexPath.item - 1)
            controller.note = notes[indexPath.item - 1]
            controller.numOfCurrentNoteInNotesCollection = indexPath.item - 1
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNoteCell", for: indexPath) as! AddNoteCollectionViewCell
            cell.penImage.image = UIImage(named: "add")!
            cell.text.text = "Add your note"
            return cell
            
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCollectionViewCell
            let note = notes[indexPath.item - 1]
            if note.remind == nil {
                cell.clock.isHidden = true
                cell.clock.tintColor = .black
            } else {
                cell.clock.isHidden = false
            }
            cell.date.text = note.date.toString(withTime:false)
            cell.previewLabel.text = note.text
            cell.setColor(color: note.statusInColor())
            cell.cancelButton.tag = note.id
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / numOfNotesInLine) - ((numOfNotesInLine + 1) * borderWidth / numOfNotesInLine)
        let height = width + 20
        return CGSize(width: width, height: height)
    }
    
}

