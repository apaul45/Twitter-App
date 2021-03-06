//
//  tweetCell.swift
//  Twitter
//
//  Created by Ayon Paul on 2/28/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class tweetCell: UITableViewCell {

   
    @IBOutlet weak var rtTweet: UIButton!
    @IBAction func favButton(_ sender: UIButton) {
        let toBeFavorited = !favorited
        if (toBeFavorited){
            //Same process as tweeting but with the setFavorite method
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success:{ self.setFavorite(isFavorited: true)}, failure:{(error) in print("Error favoriting \(error)")})
        }
        else{
            //Same process as favoriting but setFavorite set to false
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success:{ self.setFavorite(isFavorited: false)}, failure:{(error) in print("Error unfavoriting \(error)")})
        }
    }
    @IBAction func rtButton(_ sender: UIButton) {
        let toBeRetweetted = !retweeted
        if (toBeRetweetted){
            //Same process as tweeting but with the setRetweeted method
            TwitterAPICaller.client?.retweetTweet(tweetID: tweetID, success:{ self.setRetweeted(isRetweeted: true)}, failure:{(error) in print("Error retweetting \(error)")})
        }
    }

    @IBOutlet weak var favTweet: UIButton!
    var favorited:Bool = false
    var tweetID: Int = -1
    var retweeted:Bool = false
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //This function changes the color of the favorite button when signaled by a incoming boolean value whose value is determined by the user favoriting or not favoriting a tweet-- that is, it comes from the twitter api.
    func setFavorite(isFavorited: Bool){
        favorited = isFavorited
        if (favorited){
            favTweet.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favTweet.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //Same process as favorited function
    func setRetweeted( isRetweeted: Bool){
        if (isRetweeted){
            rtTweet.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            rtTweet.isEnabled = false
        }
        else{
            rtTweet.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            rtTweet.isEnabled = true
        }
    }

}
