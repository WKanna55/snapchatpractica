//
//  VerSnapViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 2/11/24.
//

import UIKit

class VerSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    var snap = Snap()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
    }

}
