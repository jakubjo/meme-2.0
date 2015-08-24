//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Jakub on 24.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var memeIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme.memedImage
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MemeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        
        vc.memeToEdit = meme
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(memeIdx)
        
        navigationController?.popViewControllerAnimated(true)
    }
}
