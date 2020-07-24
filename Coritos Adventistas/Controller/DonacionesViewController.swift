//
//  DonacionesViewController.swift
//  Coritos Adventistas
//
//  Created by Jose Pimentel on 6/4/20.
//  Copyright © 2020 Jose Pimentel. All rights reserved.
//

import UIKit

class DonacionesViewController: UIViewController {

    @IBOutlet weak var donacionesText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayText()
    }

    func displayText() {
        
        donacionesText.isUserInteractionEnabled = true
        donacionesText.isSelectable = true
        donacionesText.isEditable = false
        donacionesText.dataDetectorTypes = UIDataDetectorTypes.link
        
        donacionesText.text = "DONAR \n\nCrear una aplicacion mobile conlleva mucho tiempo y esfuerzo. La creacion de esta aplicacion fuen con el proposito de hacer estos coritos libre de costo y de anuncions(ads) para toda persona que tenga acceso a un dispositivo iOS sea un iPhone o un iPad. Repito esta aplicacion es completamente gratis pero si desea hacer una donacion para ayudarnos a crear mas aplicacion como esta aqui le dejamos los enlaces en los cuales puede hacer su contribuciones. Muchas gracias! \n\nPAYPAL: www.paypal.me/josephb401 \n\nVENMO: www.venmo.com/Jose-Pimentel-17\n\nCASH APP: www.cash.app/$JosePumentel"
    }
}
