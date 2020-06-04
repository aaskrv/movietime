//
//  CollectionViewCell.swift
//  movietime
//
//  Created by Adilet on 6/3/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
