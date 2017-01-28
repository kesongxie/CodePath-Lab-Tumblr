//
//  PhotoDetailViewController.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let PhotoPreviewSegueIden = "PhotoPreview"

class PhotoDetailViewController: UIViewController {
    
    var post: NSDictionary?
    
    @IBOutlet weak var postImageView: UIImageView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(postImageTapped(_:)))
            self.postImageView.isUserInteractionEnabled = true
            self.postImageView.addGestureRecognizer(tap)
        }
    }

    @IBOutlet weak var avatorImageView: UIImageView!{
        didSet{
            self.avatorImageView.layer.cornerRadius = 6.0
            self.avatorImageView.clipsToBounds = true
            self.avatorImageView.contentMode = .scaleAspectFill
        }
    }
    
    
    @IBOutlet weak var blogNameLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post{
            if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]{
                guard let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String else{
                    return
                }
                guard let url = URL(string: imageUrlString) else{
                    return
                }
                
                self.postImageView.image = nil
                self.postImageView.setImageWith(url)
                
                
                if let blogName = post.value(forKeyPath: "blog_name") as? String{
                    self.blogNameLabel.text = blogName
                }

                
                if let summary = post.value(forKeyPath: "summary") as? String{
                    self.summaryLabel.text = summary
                }
                self.summaryLabel.frame.size.width = UIScreen.main.bounds.size.width - 20
                self.summaryLabel.sizeToFit()
                
                if let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"){
                    self.avatorImageView.setImageWith(url)
                }
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postImageTapped(_ gesture: UITapGestureRecognizer){
        self.performSegue(withIdentifier: PhotoPreviewSegueIden, sender: gesture.view)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier, iden == PhotoPreviewSegueIden{
            if let fullScreenVC = segue.destination as? FullScreenPhotoViewController{
                fullScreenVC.image = (sender as? UIImageView)?.image
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
