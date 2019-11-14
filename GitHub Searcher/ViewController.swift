//
//  ViewController.swift
//  GitHub Searcher
//
//  Created by IMCS2 on 11/12/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchQuery:String?
    var requiredRepoNum:Int? = nil
    
    var userImage: [String] = []
    var userName: [String] = []
    var userRepo: [String] = []
    var repoNumber:String?
    
    var requiredRepoNums: [Int] = []
    var userFollowers: [Int] = []
    var userFollowing: [Int] = []
    var userBio: [String] = []
    var userJoinDate: [String] = []
    var userLocation: [String] = []
    var userEmail: [String] = []
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = GitTableView.dequeueReusableCell(withIdentifier: "userReuse", for: indexPath) as! UserNameTableViewCell
    
    
        let imageUrl = userImage[indexPath.row]
        
        let url = URL(string:imageUrl)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.userImage.image = image
        }
        
       
        
        let currentUserName = userName[indexPath.row]
        cell.userName.text = currentUserName
        
      //  self.repoApiCall(number :currentUserName)
   
       
        let reqRep = requiredRepoNums[indexPath.row]
        
        cell.userRepo.text = "Repo: " + String (reqRep)
        
        return cell
        

    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUserInfo",
            let destination = segue.destination as? UserViewController,
            
            let index = GitTableView.indexPathForSelectedRow?.row
        {
            let imageUrl = userImage[index]
            
            let url = URL(string:imageUrl)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                destination.recUserImage = image
            }
            
            let currentUserName = userName[index]
            destination.recUserName = currentUserName
            
            let currentEmail = userEmail[index]
            destination.recUserEmail = currentEmail
            
            let currentLocation = userLocation[index]
            destination.recUserLocation = currentLocation
            
            let currentJoinDate = userJoinDate[index]
            destination.recUserJoinDate = currentJoinDate
            
            let currentFollowers = userFollowers[index]
            destination.recUserFollower = currentFollowers
            
            let currentFollowing = userFollowing[index]
            destination.recUserFollowing = currentFollowing
            
            let currentBio = userBio[index]
            destination.recUserBio = currentBio
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toUserInfo", sender: self)
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userSearch.delegate = self
        
        GitTableView.dataSource = self
        GitTableView.delegate = self
        
        let nibName = UINib(nibName: "UserNameTableViewCell", bundle: nil)
        GitTableView.register(nibName, forCellReuseIdentifier: "userReuse")
        
    
    }
    @IBOutlet var GitTableView: UITableView!
    
    @IBOutlet var userSearch: UISearchBar!
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        apiCall ()
    }
    
    
    func repoApiCall()  {
       
        
        for name in userName {
            
        
        
        let url = URL(string: "https://api.github.com/users/" + name)
        let task = URLSession.shared.dataTask(with: url!){ (Data, response, error) in
            
            if error == nil {
                if let unWrappedData = Data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: unWrappedData,
                                                                          options: JSONSerialization.ReadingOptions.mutableContainers) as?
                        NSDictionary
                       
                        let repos = jsonResult!["public_repos"]!
                        let emails = jsonResult!["email"]! as? String
                        
                        if emails == nil {
                                 self.userEmail.append("Null")
                            
                        }
                        else
                        {
                            self.userEmail.append(emails!)
                        }
                        
                        
                        let locations = jsonResult!["location"]! as? String
                        
                        if locations == nil {
                            self.userLocation.append("Null")
                            
                        }
                        else
                        {
                              self.userLocation.append(locations!)
                        }
                        
                        let joinDate = jsonResult!["created_at"]!
                        let followers = jsonResult!["followers"]!
                        let following = jsonResult!["following"]!
                        
                        let bio = jsonResult!["bio"]! as? String
                        
                        if bio == nil {
                            self.userBio.append("No Bio by the User")
                        }
                        else
                        {
                               self.userBio.append(bio!)
                        }
                        self.requiredRepoNums.append(repos as! Int)
                      
                      
                        self.userJoinDate.append(joinDate as! String)
                        self.userFollowers.append(followers as! Int)
                        self.userFollowing.append(following as! Int)
                    
                       
                        
                    }
                    catch {
                        print ("Error in fetcing Data")
                        
                    }
                }
            }
            
        }
        
        task.resume()
        }
        
    }
    
    
    func apiCall () {
        
        requiredRepoNums.removeAll()
        userRepo.removeAll()
        userImage.removeAll()
        userName.removeAll()
        
        searchQuery = userSearch?.text
        
      
        if (((searchQuery!.contains("‘")))) || (((searchQuery!.contains("%")))) || (((searchQuery!.contains("^")))) || (((searchQuery!.contains(">")))) || (((searchQuery!.contains("<")))) || (((searchQuery!.contains("`"))))
        {
            
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Invalid Character", message: "Invalid Character", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK :)", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
           
        }
            
        else if searchQuery!.isEmpty {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Textfield is Empty", message: "Please enter some query", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK :)", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        }
            
        else {
            
          
            
           let finalSearch = searchQuery!.replacingOccurrences(of: " ", with: "+")
            
            let url = URL(string: "https://api.github.com/search/users?q=" + finalSearch)
            
            let task = URLSession.shared.dataTask(with: url!){ (Data, response, error) in
                
                if error == nil {
                    if let unWrappedData = Data {
                        
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: unWrappedData,
                                                                              options: JSONSerialization.ReadingOptions.mutableContainers) as?
                            NSDictionary
                            
                            let items = jsonResult?["items"] as! [[String: AnyObject]]
                            
                            let refinedItems = items as NSArray
                           
                            
                            for item in refinedItems {
                                
                                let itemsDictionary = item as! NSDictionary
                                
                                let name = itemsDictionary["login"]!
                                let img = itemsDictionary["avatar_url"]!
                                let repo = itemsDictionary["repos_url"]!

                                self.userName.append(name as! String)
                                self.userImage.append(img as! String)
                                self.userRepo.append(repo as! String)
                                
                            }
                            
                            self.repoApiCall()


                                DispatchQueue.main.async {
                                    self.GitTableView.reloadData()
                                }

                        }
                            
                        catch {
                            print ("Error in fetcing Data")
                            
                            DispatchQueue.main.async {
                                
                                
                                let alert = UIAlertController(title: "Invalid Character", message: "Invalid Character", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "OK :)", style: .cancel, handler: nil))
                                
                                self.present(alert, animated: true)
                            }
                            
                            
                        }
                    }
                }
                
            }
            
            task.resume()
            
        }
    }

    
        
        
    }
    
    
    


