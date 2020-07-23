//
//  DetailControllerController.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import UIKit

class DetailControllerController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var detail_image: UIImageView!
    @IBOutlet weak var detail_imageAdd: UIImageView!
    @IBOutlet weak var detail_imageLabel: UILabel!
    
    @IBOutlet weak var detail_textField: UITextField!
    @IBOutlet weak var detail_addImage: UIView!
    @IBOutlet weak var detail_addLabel: UIView!
    @IBOutlet weak var detail_save: UIView!
    
    @IBOutlet weak var detail_canvas: UIView!
    var data : DataModel.DataMemes? = nil
    var dataImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Detail Gambar"
        self.detail_imageAdd.isHidden = true
        self.detail_imageLabel.isHidden = true
        self.detail_textField.isHidden = true
        self.detail_textField.delegate = self
        
        let thumb = URL(string: self.data?.url ?? "")
        self.detail_image.kf.setImage(with: thumb)
        
        let imageAddGes = UITapGestureRecognizer(target: self, action: #selector(addLogo))
        let labelAddGes = UITapGestureRecognizer(target: self, action: #selector(showLabel))
        let labelAddEdit = UITapGestureRecognizer(target: self, action: #selector(labelEdit))
        let saveImageGesture = UITapGestureRecognizer(target: self, action: #selector(createImage))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scaleImage(recognizer:)))
        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(onClickPinch(recognizer:)))
        
        let pan2Gesture = UIPanGestureRecognizer(target: self, action: #selector(scaleImage2(recognizer:)))
        let pin2Gesture = UIPinchGestureRecognizer(target: self, action: #selector(onClickPinch2(recognizer:)))
        
        self.detail_imageAdd.addGestureRecognizer(panGesture)
        self.detail_imageAdd.addGestureRecognizer(pinGesture)
        self.detail_imageLabel.addGestureRecognizer(pan2Gesture)
        self.detail_imageLabel.addGestureRecognizer(pin2Gesture)
        self.detail_imageLabel.addGestureRecognizer(labelAddEdit)
        self.detail_addImage.addGestureRecognizer(imageAddGes)
        self.detail_addLabel.addGestureRecognizer(labelAddGes)
        self.detail_save.addGestureRecognizer(saveImageGesture)
    }
    
    @objc func labelEdit(){
        self.detail_imageLabel.isHidden = true
        self.detail_textField.isHidden = false
        self.detail_textField.text = self.detail_imageLabel.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.detail_textField.isHidden = true
        self.detail_imageLabel.isHidden = false
        self.detail_imageLabel.text = self.detail_textField.text ?? ""
        return true
    }
    
    @objc func createImage(){
        let image = UIView.asImage(self.detail_canvas)
        
        UIImageWriteToSavedPhotosAlbum(image(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func scaleImage(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func onClickPinch(recognizer: UIPinchGestureRecognizer){
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }

    @objc func scaleImage2(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func onClickPinch2(recognizer: UIPinchGestureRecognizer){
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Tersimpan!", message: "Gambar Anda Sudah Tersimpan", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func addLogo(){
        ImagePicker().pickImage(self) { (image) in
            self.dataImage = image
            self.detail_imageAdd.image = image
            self.detail_imageAdd.isHidden = false
        }
    }
    
    @objc func showLabel(){
        self.detail_imageLabel.isHidden = false
    }
    
    func saveImage(image: UIImage, title: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(title).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
