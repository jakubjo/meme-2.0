//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jakub on 02.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var autoLayoutContainer: UIView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var topTextFieldDelegate: TextFieldDelegate!
    var bottomTextFieldDelegate: TextFieldDelegate!
    
    var memeToEdit: Meme!
    var editingMode = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topTextFieldDelegate = TextFieldDelegate(textFieldType: "top", textField: topTextField)
        bottomTextFieldDelegate = TextFieldDelegate(textFieldType: "bottom", textField: bottomTextField)
        
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate

        subscribeToKeyboardNotifications()
        
        if let meme = memeToEdit {
            editingMode = true
            
            topTextField.text = meme.texts.top
            bottomTextField.text = meme.texts.bottom
            
            imageView.image = meme.image
        }
        
        if let imageViewHasImage = imageView.image {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageContainerSize()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        pickAnImage(pickFromCamera: true)
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        pickAnImage()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        topTextFieldDelegate.resetText()
        bottomTextFieldDelegate.resetText()
        imageView.image = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(activity, success, items, error) -> Void in
            if (success) {
                self.saveMeme(memedImage)
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func saveMeme(memedImageFromParam: UIImage?) {
        var memedImage: UIImage!
        
        if memedImageFromParam != nil {
            memedImage = memedImageFromParam!
        } else {
            memedImage = generateMemedImage()
        }
        
        var meme = Meme(texts: (top: topTextField.text, bottom: bottomTextField.text), image: imageView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        var multiplier = CGFloat(0)
        
        if let image = imageView.image {
            let oldImageSize = imageViewContainerWidth.constant;
            let temporarySize = (image.size.width > image.size.height) ? image.size.height : image.size.width;
        
            multiplier = (temporarySize / oldImageSize) * 2;
        }
        
        
        UIGraphicsBeginImageContextWithOptions(imageViewContainer.bounds.size, false, multiplier)
        
        imageViewContainer.drawViewHierarchyInRect(imageViewContainer.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return memedImage;
    }
    
    
    func pickAnImage(pickFromCamera:Bool = false) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if (pickFromCamera) {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        presentViewController(pickerController, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image;
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardSlideActivity:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardSlideActivity:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardSlideActivity(notification: NSNotification) {
        if (!bottomTextFieldDelegate.isActive) {
            return;
        }
        
        var keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        var keyboardSizeAsFloat = Float(keyboardSize.CGRectValue().height)
        
        var margin = Float(autoLayoutContainer.frame.height - imageViewContainer.frame.height);
        margin /= 2;
        
        keyboardSizeAsFloat -= margin;
        
        if (notification.name == "UIKeyboardWillHideNotification") {
            let multiplier: Float = -1.0
            keyboardSizeAsFloat = keyboardSizeAsFloat * multiplier;
            
        }

        imageViewContainer.frame.origin.y -= CGFloat(keyboardSizeAsFloat);
    }
    
    func updateImageContainerSize() {
        let size = (autoLayoutContainer.frame.width > autoLayoutContainer.frame.height) ? autoLayoutContainer.frame.height : autoLayoutContainer.frame.width;
        
        imageViewContainerWidth.constant = size
        imageViewContainerHeight.constant = size
    }
    
}
