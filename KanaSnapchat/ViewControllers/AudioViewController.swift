//
//  AudioViewController.swift
//  KanaSnapchat
//
//  Created by Willian Kana Choquenaira on 7/11/24.
//

import UIKit
import AVFoundation
import FirebaseStorage

class AudioViewController: UIViewController {
    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio: AVAudioPlayer?
    var audioURLpath : URL?
    
    // contador duracion
    @IBOutlet weak var lblContadorSegundos: UILabel!
    var timer: Timer?
    var elapsedTimeInSeconds = 0
    var audioDuracion: String = "00:00"
    
    // cambio de volumen con slider
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var lblVolumen: UILabel!
    var volumenFinal: Float = 0.5
    
    //extra agregado en este lab
    @IBOutlet weak var enviarButton: UIButton!
    var audioID = NSUUID().uuidString
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        let value = sender.value
        reproducirAudio?.volume = value
        updateVolumeLabel(value: value)
        volumenFinal = value
    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            enviarButton.isEnabled = true
            // Detener el timer
            timer?.invalidate()
            timer = nil
            //elapsedTimeInSeconds = 0
            updateTimerLabel()
            audioDuracion = lblContadorSegundos.text!
        } else {
            grabarAudio?.record()
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
            // Iniciar el timer
            elapsedTimeInSeconds = 0
            updateTimerLabel()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURLpath!)
            reproducirAudio?.volume = volumenFinal
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch {}
    }
    
    @IBAction func enviarTapped(_ sender: Any) {
        do {
            let audioFolder = Storage.storage().reference().child("audios")
            let audioData = try Data(contentsOf: audioURLpath!)
            let cargarAudio = audioFolder.child("\(audioID).m4a")
            cargarAudio.putData(audioData, metadata: nil) {  (metadata, error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio, verifique su conexion a internet y vuelva a acerptarlo", accion: "Aceptar")
                    self.enviarButton.isEnabled = true
                    print("Ocurrion un error al subir la imagen \(error)")
                } else {
                    cargarAudio.downloadURL(completion: {(url, error) in
                        guard let enlaceURL = url else{
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion del audio.", accion: "Cancelar")
                            self.enviarButton.isEnabled = true
                            print("Ocurrio un error al obtener informacion del audio: \(error)")
                            return
                        }
                        self.performSegue(withIdentifier: "seleccionarContactoAudioSegue", sender: url?.absoluteString)
                    })
                }
                
            }
        } catch{
            print("Error al convertir audio a Data: \(error.localizedDescription)")
        }
        
        
    }
    
    func mostrarAlerta (titulo: String, mensaje: String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        enviarButton.isEnabled = false
    }
    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURLpath = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("**************************")
            print(audioURLpath!)
            print("**************************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURLpath!, settings: settings)
            grabarAudio!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    // visualizar duracion en segundos
    // Función que se ejecuta cada segundo para actualizar el timer
    @objc func updateTimer() {
        elapsedTimeInSeconds += 1
        updateTimerLabel()
    }
    // Función para actualizar el texto del label
    func updateTimerLabel() {
        let minutes = elapsedTimeInSeconds / 60
        let seconds = elapsedTimeInSeconds % 60
        lblContadorSegundos.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // volumen modificar
    func setupVolumeControl() {
        // Configurar el slider
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = 0.5 // Valor inicial
    
        // Agregar imágenes para los extremos (opcional)
        volumeSlider.minimumValueImage = UIImage(systemName: "speaker.fill")
        volumeSlider.maximumValueImage = UIImage(systemName: "speaker.wave.3.fill")
            
        // Configurar el color del slider
        volumeSlider.tintColor = .systemBlue
            
        // Actualizar el label inicial
        updateVolumeLabel(value: volumeSlider.value)
    }
    
    func updateVolumeLabel(value: Float) {
        // Convertir el valor a porcentaje
        let percentage = Int(value * 100)
        lblVolumen.text = "\(percentage) %"
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguientVC = segue.destination as! ElegirUsuarioViewController
        siguientVC.audioURL = sender as! String
        siguientVC.audioName = nombreTextField.text!
        siguientVC.audioID = audioID
        siguientVC.audioVolumen = String(volumenFinal)
    }

}
