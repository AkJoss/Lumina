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
    
    // Solo un label para Email o Teléfono
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        // 1. Reset: Escondemos todo antes de validar
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        let input = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        var hasError = false
        
        // 2. Lógica Híbrida (Email o Teléfono)
        if input.isEmpty {
            emailErrorLabel.text = "Required"
            emailErrorLabel.isHidden = false
            hasError = true
        } else if input.contains("@") {
            // Caso: Correo
            if !isValidEmail(input) {
                emailErrorLabel.text = "Invalid Email"
                emailErrorLabel.isHidden = false
                hasError = true
            }
        } else if input.allSatisfy({ $0.isNumber }) {
            // Caso: Teléfono
            if input.count != 10 {
                emailErrorLabel.text = "Invalid phone number*"
                emailErrorLabel.isHidden = false
                hasError = true
            }
        } else {
            // Caso: Formato desconocido
            emailErrorLabel.text = "Invalid format"
            emailErrorLabel.isHidden = false
            hasError = true
        }
        
        // 3. Validación de Password
        if password.count < 8 {
            passwordErrorLabel.text = "Min 8 characters"
            passwordErrorLabel.isHidden = false
            hasError = true
        }
        
        // 4. Éxito: Guardado en UserDefaults
        if !hasError {
            UserDefaults.standard.set(input, forKey: "userEmail")
            UserDefaults.standard.set(password, forKey: "userPassword")
            
            print("Adri (Log): User saved: \(input)")
            
            let alert = UIAlertController(title: "Success", message: "Account created!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
