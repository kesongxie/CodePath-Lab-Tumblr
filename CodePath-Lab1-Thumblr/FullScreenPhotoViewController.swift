//
//  FullScreenPhotoViewController.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var imageView = UIImageView()
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        let drag = UIPanGestureRecognizer(target: self, action: #selector(imageDragging(_: )))
        self.imageView.addGestureRecognizer(drag)
        self.imageView.isUserInteractionEnabled = true
        
        if let image = image{
            self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
            self.scrollView.addSubview(self.imageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func imageDragging(_ gesture: UIPanGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
}

extension FullScreenPhotoViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
