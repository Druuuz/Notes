//
//  CreateNoteViewController.swift
//  Notes
//
//  Created by Андрей Олесов on 9/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var doneNavButton: UIBarButtonItem!
    @IBOutlet var statusButtons: [UIButton]!
    @IBOutlet weak var text: UITextView!
    
    let placeHolder = "Write down your note"
    let imagePicker = UIImagePickerController()
    let datePiker = UIDatePicker()
    var note:BlackNote?
    var numOfCurrentNoteInNotesCollection:Int?
    var listOfNotesSize:Int?
    
    @IBAction func changeStatus(_ sender: UIButton) {
        if sender.backgroundColor == .black{
            for i in 0..<statusButtons.count{
                statusButtons[i].backgroundColor = .black
            }
            sender.backgroundColor = sender.tintColor
        } else {
            sender.backgroundColor = .black
        }
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        if text.text == placeHolder{
            showWarning()
        } else{
            saveNote()
        }
    }
    
    @IBAction func tapOnView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            attachmentImage.image = pickerImage
        }
        dismiss(animated: true, completion: nil)
    }
    

    private func saveNote(){
        var imageToSave:UIImage?
        if attachmentImage.image == UIImage(named: "emptyImage"){
            imageToSave = nil
        } else{
            imageToSave = attachmentImage.image
        }
        if let note = note{
            DBUtil.updateNote(newNote: BlackNote(id: note.id, text: text.text, date: Date(), status: self.status, remind: dateField.text?.toDateTime(), image:imageToSave))
            
            if let date = dateField.text?.toDateTime(){
                NotificationsUtil.createNotification(inSeconds: date.timeIntervalSinceNow, withIdentificator: String(note.id), withText: text.text)
            } else {
                NotificationsUtil.removeNotification(withIdentificator: [String(note.id)])
            }
        } else{
            let id = DefaultsUtil.getNewId()
            if let date = dateField.text?.toDateTime(){
                NotificationsUtil.createNotification(inSeconds: date.timeIntervalSinceNow, withIdentificator: String(id), withText: text.text)
                
            }
            DBUtil.saveNote(noteToSave: BlackNote(id: id,text: text.text, date: Date(), status: self.status, remind: dateField.text?.toDateTime(), image:imageToSave))
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    private var status: Status {
        switch getNumOfFilledStatusButton(){
        case 0: return .normal
        case 1: return .specific
        case 2: return .important
        default:
            return .normal
        }
    }
    
    private func getNumOfFilledStatusButton() -> Int{
        for i in 0..<statusButtons.count{
            if statusButtons[i].backgroundColor != .black{
                return i
            }
        }
        return 0
    }
    
    func getDateFromPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateField.text = formatter.string(from: datePiker.date)
        
    }
    
    @objc func doneToolBarButtonAction(_ sender: UIBarButtonItem){
        getDateFromPicker()
        view.endEditing(true)
        UIView.animate(withDuration: 0.7, animations: {
            self.dateImage.tintColor = .white
        })
    }
    
    @objc func cancelToolBarButtonAction(_ sender: UIBarButtonItem){
        dateField.text = nil
        view.endEditing(true)
        UIView.animate(withDuration: 0.7, animations: {
            self.dateImage.tintColor = .black
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewSettings()
        setUpStatusButtons()
        setUpTextNote()
        setUpDatePicker()
        setKeyBoardNotifications()
        setUpAttachemntGesture()
    }
    
    func setUpViewSettings(){
        cameraImage.tintColor = .white
        dateImage.tintColor = .black
        dateImage.backgroundColor = .purple
        dateImage.layer.cornerRadius = 6
    }
    
    func setKeyBoardNotifications(){
        text.delegate = self
        self.addDoneButtonOnKeyboard()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setUpAttachemntGesture(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_ :)))
        cameraImage.addGestureRecognizer(tapGesture)
        cameraImage.isUserInteractionEnabled = true
        attachmentImage.tintColor = .white
        
        let tapGestureAttachment = UITapGestureRecognizer(target: self, action: #selector(tapOnAttachement(_ :)))
        attachmentImage.addGestureRecognizer(tapGestureAttachment)
        attachmentImage.isUserInteractionEnabled = true
    }
    
    func setUpDatePicker(){
        dateField.inputView = datePiker
        datePiker.datePickerMode = .dateAndTime
        datePiker.backgroundColor = .black
        datePiker.setValue(UIColor.white, forKey: "textColor")
        let localeID = Locale.preferredLanguages.first
        datePiker.locale = Locale(identifier: localeID!)
        let toolBar = UIToolbar()
        toolBar.barTintColor = .black
        toolBar.sizeToFit()
        
        let doneToolBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToolBarButtonAction(_:)))
        let cancelToolBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelToolBarButtonAction(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelToolBarButton, flexSpace, doneToolBarButton], animated: true)
        dateField.inputAccessoryView = toolBar
    }
    
    @objc func tapOnAttachement(_ sender: UITapGestureRecognizer){

        guard (attachmentImage.image != UIImage(named: "emptyImage")) else {return}
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
        VC.imageForDisplay = attachmentImage.image
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @objc func tapOnImage(_ sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAlert = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let libraryAlert = UIAlertAction(title: "Library", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAlert)
        alert.addAction(libraryAlert)
        alert.addAction(cancelAlert)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            text.contentInset = .zero
        } else {
            text.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        text.scrollIndicatorInsets = text.contentInset
        
        let selectedRange = text.selectedRange
        text.scrollRangeToVisible(selectedRange)
    }
    
  
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.black
        doneToolbar.tintColor = .white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.text.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text.textColor == #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1) {
            text.text = ""
            text.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.text == "" {
            text.text = placeHolder
            text.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        }
    }
    
    func showWarning(){
        let alert = UIAlertController(title: "You tried to create empty note", message: "Please, add note", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func setUpTextNote(){
        if note != nil{
            text.textColor = .white
            self.text.text = note!.text
            if let date = note?.remind?.toString(withTime: true){
                self.dateField.text = date
                dateImage.tintColor = .white
            }
            if note?.image == nil{
                attachmentImage.image = UIImage(named: "emptyImage")
            } else{
                attachmentImage.image = note?.image
            }
        } else {
            text.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            text.text = placeHolder
        }
    }
    
    private func setUpStatusButtons(){
        for i in 0..<statusButtons.count{
            statusButtons[i].backgroundColor = .black
        }
        if note != nil {
            let numOfStatusButtons:Int = Int(note!.statusInInt()) - 1
            
            statusButtons![numOfStatusButtons].backgroundColor = statusButtons![numOfStatusButtons].tintColor
        } else{
            statusButtons[0].backgroundColor = statusButtons[0].tintColor
        }
        
    }
    
}
