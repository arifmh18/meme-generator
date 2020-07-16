//
//  DetailControllerController.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import UIKit

class DetailControllerController: UIViewController {

    @IBOutlet weak var detail_title: UILabel!
    @IBOutlet weak var detail_image: UIImageView!
    @IBOutlet weak var detail_textInputan: UITextField!
    @IBOutlet weak var detail_addLogo: UIButton!
    @IBOutlet weak var detail_addText: UIButton!
    @IBOutlet weak var detail_simpan: UIButton!
    
    var data : DataModel.DataMemes? = nil
    var dataImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Detail Gambar"
        
        self.detail_title.text = self.data?.name ?? ""
        
        let thumb = URL(string: self.data?.url ?? "")
        self.detail_image.kf.setImage(with: thumb)
        self.detail_textInputan.isHidden = true
        self.detail_simpan.isHidden = true
        
        self.detail_addLogo.addTarget(self, action: #selector(addLogo), for: .touchUpInside)
        self.detail_addText.addTarget(self, action: #selector(addText), for: .touchUpInside)
        self.detail_simpan.addTarget(self, action: #selector(simpan), for: .touchUpInside)
    }
    
    @objc func addLogo(){
        ImagePicker().pickImage(self) { (image) in
            self.dataImage = image
            self.detail_image.image = image
        }
    }
    
    @objc func addText(){
        self.detail_textInputan.isHidden = false
        self.detail_simpan.isHidden = false
    }
    
    @objc func simpan(){
        let judul = self.detail_textInputan.text ?? ""
        
        if judul.isEmpty {
            Utils().showAlert(controller: self, message: "Judul Harap Diisi Dulu ya", seconds: 1)
            return
        }
        if self.dataImage == nil {
            Utils().showAlert(controller: self, message: "Gambar Dipilih Dulu yah", seconds: 1)
            return
        }
        
        let simpan = self.saveImage(image: self.dataImage!, title: judul)
        
        if simpan {
            Utils().showAlert(controller: self, message: "Selamat Gambar Anda Sudah Tersimpan di HP Anda", seconds: 1)
        } else {
            Utils().showAlert(controller: self, message: "Maaf Gagal Menyimpan Gambar", seconds: 1)
        }
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
