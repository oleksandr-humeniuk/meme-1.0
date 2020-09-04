//
//  SentMemesViewController.swift
//  Meme
//
//  Created by Oleksandr Humeniuk on 9/4/20.
//

import UIKit

fileprivate let ITEM_IDENTIFIER = "SentMemeItem"
fileprivate let MEME_DETAILS_ID = "MemeDetailsViewController"

class SentMemesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet
    var tableView: UITableView?
    @IBOutlet
    var collectionView: UICollectionView?
    
    private var memes: [Meme] {
        (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView?.reloadData()
        collectionView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_IDENTIFIER) as! MemeTableViewCell
        let meme = getMeme(indexPath: indexPath)
        cell.memeTitle.text = "\(meme.topText)...\(meme.bottomText)"
        cell.memeImageView.image = meme.memeImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMemeDetails(meme: getMeme(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeMeme(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITEM_IDENTIFIER, for: indexPath) as! MemeCollectionViewCell
        let meme = getMeme(indexPath: indexPath)
        cell.memeImageView.image = meme.memeImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMemeDetails(meme: getMeme(indexPath: indexPath))
    }
    
    private func memesCount() -> Int {
        return memes.count
    }
    
    private func getMeme(indexPath:IndexPath) -> Meme {
        return self.memes[(indexPath as NSIndexPath).row]
    }
    
    private func removeMeme(indexPath: IndexPath) {
        (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (indexPath as NSIndexPath).row)
        tableView?.reloadData()
    }
    
    private func navigateToMemeDetails(meme:Meme){
        let detailController = storyboard?.instantiateViewController(withIdentifier: MEME_DETAILS_ID) as! MemeDetailsViewController
        detailController.image = meme.memeImage
        navigationController?.pushViewController(detailController, animated: true)
    }
}
