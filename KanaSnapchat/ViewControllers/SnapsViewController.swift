//
//  SnapsViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 23/10/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablaSnaps: UITableView!
    //tarea audio
    @IBOutlet weak var tablaAudios: UITableView!
    
    var snaps: [Snap] = []
    //tarea audio
    var audios: [Audio] = []
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        
        // Obtén el storyboard principal directamente
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Crea el view controller de inicio de sesión directamente
            let loginVC = storyboard.instantiateViewController(withIdentifier: "IniciarSesionViewController")
            
            // Crea un nuevo navigation controller con el login como root
            let loginNavController = UINavigationController(rootViewController: loginVC)
            
            // Establece el nuevo navigation controller como root
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = loginNavController
                window.makeKeyAndVisible()
                
                // Opcional: Añade una animación de transición
                UIView.transition(with: window,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil,
                                completion: nil)
            }
        
        print("sesion cerrada")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        // tarea audio
        tablaAudios.dataSource = self
        tablaAudios.delegate = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })
        
        // -------------- tarea audios --------------
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").observe(DataEventType.childAdded, with: { (myaudio) in
            let audio = Audio()
            audio.audioURL = (myaudio.value as! NSDictionary)["audioURL"] as! String
            audio.from = (myaudio.value as! NSDictionary)["from"] as! String
            audio.name = (myaudio.value as! NSDictionary)["name"] as! String
            audio.volumen = (myaudio.value as! NSDictionary)["volumen"] as! String
            audio.id = myaudio.key
            audio.audioID = (myaudio.value as! NSDictionary)["audioID"] as! String
            self.audios.append(audio)
            self.tablaAudios.reloadData()
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").observe(DataEventType.childRemoved, with: { (myaudio) in
            var iterator = 0
            for audio in self.audios {
                if audio.id == myaudio.key{
                    self.audios.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaAudios.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tablaSnaps {
            if snaps.count == 0 {
                return 1
            } else {
                return snaps.count
            }
        } else { //tarea audio
            if audios.count == 0 {
                return 1
            } else {
                return audios.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tablaSnaps {
            let cell = UITableViewCell()
            if snaps.count == 0 {
                cell.textLabel?.text = "No tienes Snaps 😭"
            } else {
                let snap = snaps[indexPath.row]
                cell.textLabel?.text = snap.from
            }
            cell.backgroundColor = UIColor.systemGray6
            return cell
        } else { //tarea audios
            let cell = UITableViewCell()
            if audios.count == 0 {
                cell.textLabel?.text = "No tienes Audios 📢"
            } else {
                let audio = audios[indexPath.row]
                cell.textLabel?.text = "\(audio.from) - \(audio.name)"
            }
            cell.backgroundColor = UIColor.systemGray6
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tablaSnaps {
            let snap = snaps[indexPath.row]
            performSegue(withIdentifier: "versnapsegue", sender: snap)
        } else { // tarea audio
            let audio = audios[indexPath.row]
            performSegue(withIdentifier: "verAudioSegue", sender: audio)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        } else if segue.identifier == "verAudioSegue" { // tarea audio
            let siguienteVC = segue.destination as! VerAudioViewController
            siguienteVC.audio = sender as! Audio
        } else if segue.identifier == "grabarAudio" {
            let siguienteVC = segue.destination as! AudioViewController
        } else if segue.identifier == "mandarFoto" {
            let siguienteVC = segue.destination as! ImagenViewController
        }
    }
    
}
