//
//  LoginViewController.swift
//  FireFun
//
//  Created by Tran Ngoc Nam on 7/3/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginFBAction(_ sender: UIButton) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil {
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    return
                }
                if fbLoginResult.grantedPermissions.contains("email") {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                if let info = result as? DICT {
                    if let email = info["email"] as? String,
                        let name = info["name"] as? String,
                        let picture = info["picture"] as? DICT,
                        let data = picture["data"] as? DICT,
                        let url = data["url"] as? String {
                        print("NamTN: \(url)")
                        
                        print("NamTN: \(name)")

                        print("NamTN: \(email)")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        UserDefaults.standard.set(url, forKey: "url")
                        
                        self.presentLoginedInScreen()
                        
                    }
                }
            }
        })
    }
    
    func presentLoginedInScreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        appDelegate.window!.rootViewController = nav
    }
}
