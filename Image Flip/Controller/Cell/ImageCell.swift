//
//  ImageCell.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageCellDelegate : AnyObject {
    func moveIntoDetail(data: DataModel.DataMemes)
}

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate : ImageCellDelegate? = nil
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    var dataModel : DataModel.DataMemes? = nil

    func setData(data: DataModel.DataMemes){
        self.dataModel = data
        let thumb = URL(string: data.url ?? "")
        print(thumb)
        self.cell_image.kf.setImage(with: thumb)

        let konten = UITapGestureRecognizer(target: self, action:  #selector (self.moveDetail(_:)))
        self.cell_content.addGestureRecognizer(konten)

    }
    
    @objc func moveDetail(_ sender:UITapGestureRecognizer){
        self.delegate?.moveIntoDetail(data: self.dataModel!)
    }

}
