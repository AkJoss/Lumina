//
//  SignUpViewController.swift
//  Lu
//
//  Created by José Alberto Rocha Munguía on 04/04/26.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        print("Adri (Log): Registration attempt detected")
    }
}
