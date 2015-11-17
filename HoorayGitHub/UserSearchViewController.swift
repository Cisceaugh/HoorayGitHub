//
//  UserSearchViewController.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/13/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchbar: UISearchBar!
        {
        didSet{
            self.searchbar.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
        {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var users = [User]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "UserSearchViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(searchTerm: String) {
        do {
            let token = try GithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            
                            // login
                            // avatar_url
                            
                            var users = [User]()
                            
                            for item in items {
                                
                                let name = item["login"] as? String
                                let profileImageUrl = item["avatar_url"] as? String
                                
                                if let name = name, profileImageUrl = profileImageUrl {
                                    
                                    users.append(User(name: name, profileImageUrl: profileImageUrl))
                                    
                                }
                                
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                            
                        }
                        
                    }
                    
                }
                
                }.resume()
        } catch {}
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else {return}
        self.update(searchWord)
    }
    
    // how many cells
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    // what in each cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // make cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCollectionViewCell", forIndexPath: indexPath) as! UserCollectionViewCell
        
        // modify cell
        let user = self.users[indexPath.row]
        cell.user = user

        // return cell
        return cell
    }
    
    
    @IBAction func performSegue(sender: UIButton) {
        self.performSegueWithIdentifier("customSegue", sender: self)
    }

}