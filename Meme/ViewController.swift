//
//  ViewController.swift
//  Meme
//
//  Created by Oleksandr Humeniuk on 9/3/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet
    var cameraButton: UIBarButtonItem!
    @IBOutlet
    var imageView: UIImageView!
    @IBOutlet
    var topTextField: UITextField!
    @IBOutlet
    var bottomTextField: UITextField!
    @IBOutlet
    var topToolbar: UINavigationBar!
    @IBOutlet
    var bottomToolbar: UIToolbar!
    
    private let memeTextFieldDelegate = MemeTextFieldDelegate()
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -3.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),
    ]
    
    class Strings{
        static let TOP_INITIAL_TEXT = "TOP"
        static let BOTTOM_INITIAL_TEXT = "BOTTOM"
        static let IMAGE_NOT_SET_ALERT = "Choose image to create meme"
        static let ALERT_OK_BUTTON = "OK"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        prepareTextField(topTextField, initialText: Strings.TOP_INITIAL_TEXT )
        prepareTextField(bottomTextField, initialText: Strings.BOTTOM_INITIAL_TEXT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction
    func onChooseImageFromAlbumClicked() {
        pickImage(from: .photoLibrary)
    }
    
    @IBAction
    func onChooseImageFromCameraClicked() {
        pickImage(from: .camera)
    }
    
    @IBAction
    func resetMeme() {
        topTextField.text = Strings.TOP_INITIAL_TEXT
        bottomTextField.text = Strings.BOTTOM_INITIAL_TEXT
        imageView.image = nil
    }
    
    @IBAction
    func shareMeme() {
        if imageView.image == nil {
            showAlert(message: Strings.IMAGE_NOT_SET_ALERT)
            return
        }
        let generatedMemeImage = generateMeme()
        let activityViewController = UIActivityViewController(activityItems: [generatedMemeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (_,completed,_,_) in
            if completed {
                self.saveMeme(memeImage: generatedMemeImage)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func generateMeme() -> UIImage {
        prepareUIForMeme(hide: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        prepareUIForMeme(hide: false)
        return memedImage
    }
    private func saveMeme(memeImage: UIImage){
        let savedMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!,
                             memeImage: memeImage)
    }
    
    private func prepareUIForMeme(hide:Bool){
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    private func prepareTextField(_ textField: UITextField, initialText: String){
        textField.delegate = memeTextFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = initialText
        textField.textAlignment = .center
    }
    
    private func pickImage(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func showAlert(message:String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ALERT_OK_BUTTON, style: .default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
