//
//  ElegirUsuarioViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 30/10/24.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftUI

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    
    var audioURL = ""
    var audioName = ""
    var audioID = ""
    var audioVolumen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary) ["email" ] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if imagenID != ""{
            let usuario = usuarios[indexPath.row]
            let snap = ["from": Auth.auth().currentUser?.email, "descripcion": descrip, "imagenURL": imagenURL, "imagenID": imagenID]
            Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
            navigationController?.popViewController(animated: true)
        } else {
            let usuario = usuarios[indexPath.row]
            let audio = ["from": Auth.auth().currentUser?.email, "name": audioName, "volumen": audioVolumen, "audioURL": audioURL, "audioID": audioID]
            Database.database().reference().child("usuarios").child(usuario.uid).child("audios").childByAutoId().setValue(audio)
            navigationController?.popViewController(animated: true)
        }
        
    }

}
