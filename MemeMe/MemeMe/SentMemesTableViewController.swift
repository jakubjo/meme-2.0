//
//  ViewController.swift
//  MemeMe
//
//  Created by Jakub on 02.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes = [Meme]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        tableView.reloadData()
        navigationItem.title = "Sent Memes"
    }

    @IBAction func createNewMeme(sender: AnyObject?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MemeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell") as! UITableViewCell
        
        // Set the name and image
        cell.textLabel?.text = meme.texts.top + " ... " + meme.texts.bottom
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailViewController = storyboard.instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        
        vc.meme = memes[indexPath.row]
        vc.memeIdx = indexPath.row
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

