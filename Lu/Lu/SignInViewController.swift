//
//  SignInViewController.swift
//  Lu
//
//  Created by José Alberto Rocha Munguía on 04/04/26.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        print("Adri (Log): Login attempt detected")
    }
}
