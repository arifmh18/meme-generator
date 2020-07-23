//
//  ViewController.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var main_list: UICollectionView!
    var swipeRefresh : UIRefreshControl!

    var data = [DataModel.DataMemes]()
    var cellMargin = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.callData()
        swipeRefresh = UIRefreshControl()
        swipeRefresh.attributedTitle = NSAttributedString(string: "Tarik untuk Refresh")
        swipeRefresh.addTarget(self, action: #selector(callData), for: UIControl.Event.valueChanged)
        self.main_list.addSubview(swipeRefresh)

    }
    
    @objc func callData(){
        let callNet = MoyaProvider<DataNetwork>()
        callNet.request(.getMeme) { (result) in
            switch result {
            case .success(let respon):
                self.swipeRefresh.endRefreshing()
                do {
                    let response = try respon.filterSuccessfulStatusAndRedirectCodes()
                    let data = try response.map(DataModel.self)
                    
                    self.data = data.data?.memes ?? []
                    
                    self.main_list.dataSource = self
                    self.main_list.delegate = self

                } catch {
                    Utils().showAlert(controller: self, message: "Ada Masalah Jaringan", seconds: 1)
                }
            case .failure(_):
                self.swipeRefresh.endRefreshing()
                Utils().showAlert(controller: self, message: "Silahkan Cek Koneksi Anda", seconds: 2)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gridLayout()
        
        DispatchQueue.main.async {
            self.main_list.reloadData()
        }
    }
    
    func gridLayout(){
        let layout = self.main_list.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat(self.cellMargin)
        layout.minimumLineSpacing = CGFloat(self.cellMargin)
    }

}

extension ViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageCellDelegate {
    func moveIntoDetail(data: DataModel.DataMemes) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailController") as! DetailControllerController
        vc.data = data
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        cell.setData(data: data)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width / 3) - 15
        return CGSize(width: width, height: width)
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
