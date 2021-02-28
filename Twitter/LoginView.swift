//
//  LoginView.swift
//  Twitter
//
//  Created by Ayon Paul on 2/28/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //Can use viewDidAppear to initially check if the user initially logged into the app or not-- that way, the segue can happen automatically and the user can see the home page right away instead of the login page
    //Aka, it checks if the "note" from user defaults was made and proceeds to perform the segue to the home page if the note stored as boolean = true
    override func viewDidAppear(_ animated: Bool) {
        //Checks if the user default for the key userLoggedIn is true-- that is, when the user initially logs in, a key is made to represent that the user has completed the login and a bool is set to true to indicate that no more logins need to take place until logouts occur.
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
   //Since this is a action connection, anytime someone clicks the login button,
   // whatever is written in the function will occur in the app/console
    @IBAction func onLoginButton(_ sender: Any) {
        //.client.loginhas 3 components: the url to call the api from, the action
        // to take if login is successful, and the action to take if login failed
        //For success, need to perform a segue to the nav controller identified by loginToHome using performSegue with identifier (url brings us to a login page, that where we once login brings us to that nav view controller)
        //Want to also assure that the user is logged in until they manually log out
        TwitterAPICaller.client?.login(url: "https://api.twitter.com/oauth/request_token", success: {
        //Can assure that the user is logged in by using user defaults, which allows a note to be kept of a user's login to be used every time that user closes and reopens the app without logging out
        UserDefaults.standard.set(true, forKey:"userLoggedIn")
        self.performSegue(withIdentifier: "loginToHome", sender: self)}, failure: { (Error) in
            print("Something went wrong!")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
