//
//  SnapsViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 23/10/24.
//

import UIKit

class SnapsViewController: UIViewController {
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

        // Do any additional setup after loading the view.
    }
    

}
