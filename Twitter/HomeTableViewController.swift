//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ayon Paul on 2/28/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    @objc func loadTweets(){
        //Call the api using tweetapicaller, and the ethod getdictionarIES (for MULTIPLE tweets, getdictionARY is for a single tweet_
        numberOfTweets = 20
        TwitterAPICaller.client?.getDictionariesRequest(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["count":numberOfTweets], success: { (tweets: [NSDictionary]) in
            //To empty the entire array before fetching the new list from the api call above, use removeAll on tweetArray
            self.tweetArray.removeAll()
            //Add info of each tweet to the tweetArray, which of of type NSDictionary
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //Always reloading data from the api everytime the api is called
            self.tableView.reloadData()
            //In order fo the spinning bar to disappear when we pull down in the app, have to call the endRefreshing method after the tweets have been loaded and the data has been reloadedm
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("could not retrieve tweet")
        })
    }
    //In order for our newly tweeted twee to pop up as soon we post, we need to override the existing viewDidAppear method so that our tweet appear right away instead of right after refreshing
    //In order to implement a infinite scroll, need to add a number to the numberOfTweets variable, and then load in that specific number of tweets. When the user is near the end of the table, the loadMoreTweets method should be triggered and thus, a infinite scroll should occur
    func loadMoreTweets(){
        //Call the api using tweetapicaller, and the ethod getdictionarIES (for MULTIPLE tweets, getdictionARY is for a single tweet
        //Load in additional 30 tweets as part of the infinite scroll
        numberOfTweets = numberOfTweets + 30
        TwitterAPICaller.client?.getDictionariesRequest(url: "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["count":numberOfTweets], success: { (tweets: [NSDictionary]) in
            //To empty the entire array before fetching the new list from the api call above, use removeAll on tweetArray
            self.tweetArray.removeAll()
            //Add info of each tweet to the tweetArray, which of of type NSDictionary
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //Always reloading data from the api everytime the api is called
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("could not retrieve tweet")
        })
    }
    //This method triggers loadMoreTweets when a user nears the end of the existing table
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //For pull down to refresh, can use the addTarget method of a UIRefreshControl object, and then specify which refresh control is for the tableView with tableView.refreshControl =  myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        //Have to call loadTweets here so that the api is called everytime the home age is loaded onto the screen of the device we are using
        loadTweets()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //In order for our newly tweeted twee to pop up as soon we post, we need to override the existing viewDidAppear method so that our tweet appear right away instead of right after refreshing

    //This method performs an action when the user clicks logout on the home page of the twitter app-- using the logout method from the twitter api caller
    //Then use self.dismiss to return to the home page (ie, the initial view controller)-- essentially making the home page "disappear"
    //In order to fully make sure that a user can stay logged in, the UserDefaults bool for the login key has to be set to false when the logout button is pressed, so that once the condition is checkled in viewdidAppear in the initial view controller, the app immediately defaults to the login screen
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Need an identifier for this prototype cell to assure we are dequeueing the correct one, and the have to return along with setting the number of rows and sections below to see the proper number of rows of cells in the app
        //Making the cell of a type tweetCell, so that we have access to the name, image view, and tweet content label
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        //Since user is a key containing keys that lead to info about the user, we can extract this by first extracting the user key using tweetArray[indexPath.row], and then doing user["name"] to load the actual name of the user
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        let imageURL = URL(string:(user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        if let imageData = data{
            cell.profileImage.image = UIImage(data: imageData)
        }
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Only return the number of tweets/rows returned by twitter api
        //This can be set in the var variable above ([count:10] returns 10 tweets, [count:20] returns 20 tweets, etc)
        return tweetArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
