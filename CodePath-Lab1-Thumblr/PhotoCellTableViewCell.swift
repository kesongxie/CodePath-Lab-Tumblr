//
//  PhotoCellTableViewCell.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoCellTableViewCell: UITableViewCell {

    var post: NSDictionary?{
        didSet{
            if let photos = post!.value(forKeyPath: "photos") as? [NSDictionary]{
                guard let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String else{
                        return
                }
                guard let url = URL(string: imageUrlString) else{
                    return
                }
                self.postImageView.image = nil
                self.postImageView.setImageWith(url)
            }
        }
    }
    
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
