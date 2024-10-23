//
//  ViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 16/10/24.
//

import UIKit
import FirebaseAuth

class IniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
            } else {
                print("Inicio de sesion exitoso")
            }
            
        }
    }
    
    @IBAction func ingresarAnonimoTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { (authResult, error) in
                print("Intentando iniciar sesión anónima")
                if let error = error {
                    print("Se presentó el siguiente error: \(error.localizedDescription)")
                } else {
                    print("Inicio de sesión anónimo exitoso")
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

