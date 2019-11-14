//
//  UserViewController.swift
//  GitHub Searcher
//
//  Created by IMCS2 on 11/12/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoNamesCopy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = RepoTableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoTableViewCell
        
        
        let currentRepoName = repoNamesCopy[indexPath.row]
        cell.repoNameLbl.text = currentRepoName
       
    
        let currentRepoForks = repoForksCopy[indexPath.row]
        
        
        cell.repoForksLbl.text = String (currentRepoForks) + " Forks"
        
        
        let currentRepoStars = repoStarsCopy[indexPath.row]
        
        cell.repoStarsLbl.text = String (currentRepoStars) + " Stars"
        

        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repoName = repoNamesCopy[indexPath.row]
        
        let myUrl = "https://github.com/" + recUserName! + "/" + repoName
        
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
       
    }
    
    
    
    var recUserImage:UIImage?
    var recUserName:String?
    var recequiredRepoNum:Int?
    var recUserFollower:Int = 0
    var recUserFollowing:Int = 0
    var recUserBio:String?
    var recUserJoinDate:String?
    var recUserLocation:String?
    var recUserEmail:String?
    
    var repoNames: [String] = []
    var repoForks: [Int] = []
    var repoStars: [Int] = []
    
    var repoNamesCopy: [String] = []
    var repoForksCopy: [Int] = []
    var repoStarsCopy: [Int] = []
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        repoNamesCopy = searchText.isEmpty ? repoNames : repoNames.filter { (item: String) -> Bool in
           
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        RepoTableView.reloadData()
    }
        
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SearchRepos.delegate = self
        
        RepoTableView.dataSource = self
        RepoTableView.delegate = self
        
        
     
        let nibName = UINib(nibName: "RepoTableViewCell", bundle: nil)
        RepoTableView.register(nibName, forCellReuseIdentifier: "repoCell")
        
      
        UserLargeImage.image = recUserImage
        
        UserName.text = "Username: " + recUserName!
        UserName.textAlignment = NSTextAlignment.left
        
        Email.text = "E-mail: " + recUserEmail!
        Email.textAlignment = NSTextAlignment.left
        
        let tmpLoc = "Location: " + recUserLocation!
        
        Location.text = tmpLoc
        Location.textAlignment = NSTextAlignment.left
        
        let tmpJD = "Join Date: " + recUserJoinDate!
        JoinDate.text = tmpJD
        JoinDate.textAlignment = NSTextAlignment.left
        
        let followers = recUserFollower
        Followers.text = String (followers) + " Followers"
        Followers.textAlignment = NSTextAlignment.left
       
        let following  = recUserFollowing
        Following.text = "Following " + String (following)
        
        Following.textAlignment = NSTextAlignment.left
        Bio.text = recUserBio
        Bio.sizeToFit()
        
        
     
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        let url = URL(string: "https://api.github.com/users/" + recUserName! + "/repos?per_page=2500")
            let task = URLSession.shared.dataTask(with: url!){ (Data, response, error) in

                if error == nil {
                    if let unWrappedData = Data {

                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: unWrappedData,
                                                                              options: JSONSerialization.ReadingOptions.mutableContainers) as?
                            NSArray

                            for item in jsonResult! {

                                let itemsDictionary = item as! NSDictionary

                                let name = itemsDictionary["name"]!
                                let forks = itemsDictionary["forks_count"]!
                                let stars = itemsDictionary["stargazers_count"]!

                                self.repoNames.append(name as! String)
                                self.repoForks.append(forks as! Int)
                                self.repoStars.append(stars as! Int)
                                
                                self.repoNamesCopy = self.repoNames
                                self.repoForksCopy = self.repoForks
                                self.repoStarsCopy = self.repoStars
                            }
                            
                            DispatchQueue.main.async {
                                self.RepoTableView.reloadData()
                            }
                        }
                        catch {
                            print ("Error in fetcing Data")

                        }
                    }
                }

            }

            task.resume()
    }



    
    @IBOutlet var UserLargeImage: UIImageView!
    
    @IBOutlet var UserName: UILabel!
    
    @IBOutlet var Email: UILabel!
    
    @IBOutlet var Location: UILabel!
    
    @IBOutlet var JoinDate: UILabel!
    
    @IBOutlet var Followers: UILabel!
    
    @IBOutlet var Following: UILabel!
    
    @IBOutlet var Bio: UILabel!
    
    @IBOutlet var SearchRepos: UISearchBar!
    
    @IBOutlet var RepoTableView: UITableView!
    
}
