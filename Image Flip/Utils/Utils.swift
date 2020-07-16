//
//  Utils.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    func showAlert(controller: UIViewController, message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 10
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}
