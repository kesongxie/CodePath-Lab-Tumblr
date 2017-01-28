//
//  HeaderTableViewCell.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    var post: NSDictionary?{
        didSet{
            self.avatorImageView.layer.cornerRadius = 6.0
            self.avatorImageView.clipsToBounds = true
            self.avatorImageView.contentMode = .scaleAspectFill
            if let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"){
                self.avatorImageView.setImageWith(url)
            }
            if let dateString = post!.value(forKeyPath: "date") as? String, let blogName =  post!.value(forKeyPath: "blog_name") as? String{
                blogNameLabel.text = blogName
                dateLabel.text = dateString
            }

        }
    }
    
    @IBOutlet weak var avatorImageView: UIImageView!
    
    @IBOutlet weak var blogNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
