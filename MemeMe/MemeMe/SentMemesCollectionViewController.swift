//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jakub on 12.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes = [Meme]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        collectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        collectionView.reloadData()
        
        navigationItem.title = "Sent Memes"
    }
    
    @IBAction func createNewMeme(sender: AnyObject?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MemeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCellId", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        cell.backgroundView = imageView
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailViewController = storyboard.instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        
        vc.meme = memes[indexPath.item]
        vc.memeIdx = indexPath.item
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


