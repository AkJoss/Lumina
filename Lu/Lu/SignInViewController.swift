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
    
    // Tus dos labels rojos de la pantalla de Login
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ocultamos los errores al iniciar
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        // 1. Reset: Apagamos los errores cada vez que intentan entrar
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        let inputEmail = emailTextField.text ?? ""
        let inputPassword = passwordTextField.text ?? ""
        
        // 2. Traemos la información del "disco duro" (UserDefaults)
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        let savedPassword = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        
        var hasError = false
        
        // 3. Validación precisa: ¿Falla el usuario o la contraseña?
        if inputEmail.isEmpty || inputEmail != savedEmail {
            emailErrorLabel.text = "Incorrect"
            emailErrorLabel.isHidden = false
            hasError = true
        }
        
        if inputPassword.isEmpty || inputPassword != savedPassword {
            passwordErrorLabel.text = "Incorrect"
            passwordErrorLabel.isHidden = false
            hasError = true
        }
        
        // 4. Resultado final
        if !hasError {
            // ¡Éxito! Las credenciales coinciden
            print("(Log): Access Granted for \(inputEmail)")
            
            // Navegamos al Dashboard (Asegúrate de que el identificador del Segue sea correcto)
            performSegue(withIdentifier: "toHome", sender: self)
            
        } else {
            print("(Log): Access Denied - Invalid Credentials")
        }
    }
    // Esta función se activa automáticamente justo ANTES de hacer el performSegue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            // 1. Verificamos que sea la flecha correcta
            if segue.identifier == "toHome" {
                
                // 2. Atrapamos el Tab Bar Controller que está a punto de abrirse
                if let tabBarController = segue.destination as? UITabBarController {
                    
                    // 3. Cambiamos la pestaña activa.
                    // Recuerda que en programación empezamos a contar desde 0:
                    // 0 = Pestaña 1 (Home)
                    // 1 = Pestaña 2 (Biblioteca)
                    // 2 = Pestaña 3 (Búsqueda)
                    
                    tabBarController.selectedIndex = 1
                }
            }
        }
}
