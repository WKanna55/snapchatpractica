//
//  ViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 16/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class IniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
                
                /*
                 
                
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
                    print("Intentando crear usuario...")
                    if error != nil {
                        print("Se presento el siguiente error al crear el usuario: \(error)")
                    } else {
                        print("El usuario fue creado exitosamente")
                        
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)

                        let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!) se creo correctamente.", preferredStyle: .alert)
                        
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {
                            (UIAlertAction) in
                            self.performSegue (withIdentifier: "iniciarsesionsegue", sender: nil)
                        })
                        alerta.addAction (btnOK)
                        self.present (alerta, animated: true, completion: nil)
                    }
                })
                
                 */
                let alerta = UIAlertController(title: "Usuario no encontrado", message: "Usuario: \(self.emailTextField.text!) no se encuentra registrado.", preferredStyle: .alert)
                
                let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: {
                    (UIAlertAction) in
                    self.performSegue (withIdentifier: "registrarusuariosegue", sender: nil)
                })
                let btnCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction (btnCrear)
                alerta.addAction (btnCancelar)
                self.present (alerta, animated: true, completion: nil)
                
            } else {
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
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
                    self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

