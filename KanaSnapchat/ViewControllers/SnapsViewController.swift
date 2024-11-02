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
    
    var snaps: [Snap] = []
    
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
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
}
