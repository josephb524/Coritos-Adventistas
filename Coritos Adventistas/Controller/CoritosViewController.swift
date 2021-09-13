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
    
    var data = NetworkService()
    
    let defaults = UserDefaults.standard
    
    func loadCorito() {
        
        if indexCorito > 5 && indexCorito < 11 {
            
            data.performRequest(i: (indexCorito - 1))
        }
        
        else if indexCorito > 10 && indexCorito < 13 {
            
            data.performRequest(i: (indexCorito - 2))
        }
        
        else if indexCorito > 12 && indexCorito < 14 {
            
            data.performRequest(i: (indexCorito - 3))
        }
        
        else if indexCorito > 13 && indexCorito < 17 {
            
            data.performRequest(i: (indexCorito - 4))
        }
        
        else if indexCorito > 16 && indexCorito < 30 {
            
            data.performRequest(i: (indexCorito - 5))
        }
        
        else if indexCorito > 29 && indexCorito < 31 {
            
            data.performRequest(i: (indexCorito - 6))
        }
        
        else if indexCorito > 30 && indexCorito < 36 {
            
            data.performRequest(i: (indexCorito - 7))
        }
        //problem might start here
        else if indexCorito > 35 && indexCorito < 38 {
            
            data.performRequest(i: (indexCorito - 8))
        }
        
        else if indexCorito > 37 && indexCorito < 39 {
            
            data.performRequest(i: (indexCorito - 9))
        }
        
        else if indexCorito > 38 && indexCorito < 53 {
            
            data.performRequest(i: (indexCorito - 10))
        }
        
        else if indexCorito > 52 && indexCorito < 62 {
            
            data.performRequest(i: (indexCorito - 11))
        }
        
        else if indexCorito > 61 && indexCorito < 64 {
            
            data.performRequest(i: (indexCorito - 12))
        }
        
        else if indexCorito > 63 && indexCorito < 70 {
            
            data.performRequest(i: (indexCorito - 13))
        }
        
        else if indexCorito > 69 && indexCorito < 72 {
            
            data.performRequest(i: (indexCorito - 14))
        }
        
        else if indexCorito > 71 && indexCorito < 75 {
            
            data.performRequest(i: (indexCorito - 15))
        }
        
        else if indexCorito > 74 {
            
            data.performRequest(i: (indexCorito - 16))
        }
        
        else {
            
            data.performRequest(i: indexCorito)
        }
        
        
        
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
        
        overrideUserInterfaceStyle = .light
        
        loadCorito()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if defaults.bool(forKey: "DarkMode") !=  true{
            
            overrideUserInterfaceStyle = .dark
            tabBar.overrideUserInterfaceStyle = .dark
            navigationController!.overrideUserInterfaceStyle = .dark
        }
        
        else {
            
            overrideUserInterfaceStyle = .light
            tabBar.overrideUserInterfaceStyle = .light
            navigationController!.overrideUserInterfaceStyle = .light
        }
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
                //urlString = coritosDisplay[indexCorito].coritoUrl
                print(data.trackName)
                
                urlString = "https://discoveryprovider.audius7.prod-us-west-2.staked.cloud/v1/tracks/\(data.trackName)/stream?app_name=CoritoAdventistas"
                
                guard let url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                else {return}
                
                audioPlayer = AVPlayer(url: url)
                audioPlayer!.automaticallyWaitsToMinimizeStalling = false
                
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
        
        else if(item.tag == 4) {
            
            if (defaults.bool(forKey: "DarkMode") == false) {
             
                overrideUserInterfaceStyle = .light
                tabBar.overrideUserInterfaceStyle = .light
                tabBar.barTintColor = UIColor.white
                navigationController!.overrideUserInterfaceStyle = .light
                
                defaults.removeObject(forKey: "DarkMode")
                defaults.set(true, forKey: "DarkMode")
            }
            
            else {
                
                overrideUserInterfaceStyle = .dark
                tabBar.overrideUserInterfaceStyle = .dark
                tabBar.barTintColor = UIColor.black
                navigationController!.overrideUserInterfaceStyle = .dark
                
                defaults.removeObject(forKey: "DarkMode")
                defaults.set(false, forKey: "DarkMode")
            }
        }
    }
}


