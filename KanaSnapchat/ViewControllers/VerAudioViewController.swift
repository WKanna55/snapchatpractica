//
//  VerAudioViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 8/11/24.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class VerAudioViewController: UIViewController {
    
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var reproducirAudioRecibido: AVPlayer?
    var audio = Audio()
    
    
    @IBAction func reproducirReceivedAudioTapped(_ sender: Any) {
        do {
            // Crea un AVPlayerItem a partir de la URL
            let playerItem = AVPlayerItem(url: URL(string: audio.audioURL)!)
                    
            // Crea el AVPlayer
            reproducirAudioRecibido = AVPlayer(playerItem: playerItem)
                    
            // Reproduce el audio
            reproducirAudioRecibido?.play()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblFrom.text = audio.from
        lblName.text = audio.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("audios").child(audio.id).removeValue()
        
        Storage.storage().reference().child("audios").child("\(audio.audioID).m4a").delete{ (error) in
            print("Se elimino el audio correctamente ")
        }
    }

}
