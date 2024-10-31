//
//  RegistroUsuarioViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 31/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistroUsuarioViewController: UIViewController {

    @IBOutlet weak var txtEmailReg: UITextField!
    @IBOutlet weak var txtPasswordReg: UITextField!
    
    
    @IBAction func btnRegistrarTapped(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: self.txtEmailReg.text!, password: self.txtPasswordReg.text!, completion: {(user, error) in
            print("Intentando crear usuario...")
            if error != nil {
                print("Se presento el siguiente error al crear el usuario: \(error)")
            } else {
                print("El usuario fue creado exitosamente")
                
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)

                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.txtEmailReg.text!) se creo correctamente.", preferredStyle: .alert)
                
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {
                    (UIAlertAction) in
                    self.performSegue (withIdentifier: "iniciarsesionregistrosegue", sender: nil)
                })
                alerta.addAction (btnOK)
                self.present (alerta, animated: true, completion: nil)
            }
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
