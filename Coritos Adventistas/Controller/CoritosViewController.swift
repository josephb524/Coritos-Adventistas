//
//  CoritosViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 5/12/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit
import AVFoundation

class CoritosViewController: UIViewController {

    @IBOutlet weak var coritoTitle: UINavigationItem!
    @IBOutlet weak var fontView: UIView!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var textDisplay: UITextView!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var reproducirItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var favoritoBtn: UITabBarItem!
    
    var coritos = CoritosBrain()
    var indexCorito = 1
    var slider = SliderFont()
    
    var favoritosArray = [Int]()
    var coritosDisplay = [Coritos]()
    
    var coritoFavorito: Bool = false
    var highlight: UIColor = #colorLiteral(red: 0.09795290977, green: 0.2151759565, blue: 0.3877361715, alpha: 1)
    var favoritoTitle: String = ""
    var audioPlayer: AVPlayer?
    
    var coritoRate: Float = 0.0
    
    let defaults = UserDefaults.standard
    
    func loadCorito() {
        
        textDisplay.text = coritosDisplay[indexCorito].coritos
        coritoTitle.title = "#" + coritosDisplay[indexCorito].title
        
        favoritosArray = defaults.array(forKey: "Favoritos") as? [Int] ?? [Int]()

        if let font = defaults.string(forKey: "FontSize") {
            
            slider.fontChange(value: font, textDisplay: textDisplay, fontLabel: fontLabel)
            fontSlider.value = Float(font) ?? 1.5
        }
        
        tabBar.delegate = self
        
        //to swipe left or right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        textDisplay.addGestureRecognizer(leftSwipe)
        textDisplay.addGestureRecognizer(rightSwipe)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCorito()
        
    }
    
    
    func getCoritoIndex(index: Int, favoritos: [Coritos], checkWhichController: Bool) {
        
        indexCorito = index
        coritosDisplay = favoritos
        coritoFavorito = checkWhichController 
    }
    
    
    @IBAction func fontActionSlider(_ sender: Any) {
        
        let values = (String(format: "%.1f", fontSlider.value))
        
        slider.fontChange(value: values, textDisplay: textDisplay, fontLabel: fontLabel)
    
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        //print(coritoRate)
        if coritoRate == 1.0 {
            
            audioPlayer!.pause()
            
            coritoRate = 0.0
        }
        
        if (sender.direction == .left) {
            
             if indexCorito < (coritosDisplay.count - 1) {
                
                indexCorito += 1
                
                loadView()
                loadCorito()
            }
            
        }
        
        if (sender.direction == .right) {
            
             if indexCorito != 0{
                
                indexCorito -= 1
                
                loadView()
                loadCorito()
            }
            
        }
        
    }
}
    
extension CoritosViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag == 1) {
            
            if(coritoFavorito) {
                
                let count = (coritos.coritos.count)
                var i = 0

                while i <= count {
                    
                    if coritosDisplay[indexCorito].title.contains(coritos.coritos[i].title) {
                        
                        favoritosArray.remove(at: favoritosArray.firstIndex(of: i)!)
                        
                        i = (count + count)
                    }
                    
                    else if i == count {
                        
                        favoritosArray.append(indexCorito)
                    }
                    
                    i += 1
                }
            }
            
            else {
                
                if favoritosArray.contains(indexCorito) {
                    
                    favoritosArray.remove(at: favoritosArray.firstIndex(of: indexCorito)!)
                    //favoritosArray.remove(at: favoritosArray.index()
                }
                
                else {
                    
                    favoritosArray.append(indexCorito)
                }
            }
            
            self.defaults.set(favoritosArray, forKey: "Favoritos")
        }
            
        else if(item.tag == 2) {
           
            if fontView.isHidden {
                
                fontView.isHidden = false
            }
            
            else {
                
                fontView.isHidden = true
            }
        }
        
        else if(item.tag == 3) {
            
            if coritosDisplay[indexCorito].coritoUrl != "" {
                
                let urlString: String?
                urlString = coritosDisplay[indexCorito].coritoUrl
                
                guard let url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                else {return}
                
                audioPlayer = AVPlayer(url: url)
                
                if coritoRate == 1.0 {
                    audioPlayer!.pause()
                    
                    reproducirItem.title = "Reproducir"
                    coritoRate = 0.0
                }
                
                else if audioPlayer!.rate == 0.0 {
                    
                    if (coritosDisplay[indexCorito].title == "23. DIOS ESTÁ AQUÍ" || coritosDisplay[indexCorito].title == "33. SI NO ES ESO AMOR" || coritosDisplay[indexCorito].title == "70. CON GRAN GOZO Y PLACER") {
                        
                        let url1 = URL(string: urlString!)
                        
                        audioPlayer = AVPlayer(url: url1!)
                        
                    }
                    
                    audioPlayer!.play()
                    reproducirItem.title = "Pausar"
                    
                    //allow the device play music when the phone is in silent mode
                    do {
                          try AVAudioSession.sharedInstance().setCategory(.playback)
                       } catch(let error) {
                           print(error.localizedDescription)
                       }
                }
                
                coritoRate = audioPlayer!.rate
            }
            
            else {
                
                reproducirItem.title = "No Audio"
            }
            
        }
    }
}


