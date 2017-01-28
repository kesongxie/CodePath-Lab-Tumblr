//
//  ViewController.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PhotoCell"

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var posts: [NSDictionary]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 240;
        guard let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV") else{
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dict = json as? NSDictionary else{
                        print("unable to perfrom jason serialization")
                        return
                    }
                    guard let response = dict["response"] as? NSDictionary else{
                        return
                    }
                    
                    guard let posts = response["posts"] as? [NSDictionary] else{
                        return
                    }
                    
                    self.posts = posts
                }catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PhotoCellTableViewCell
        cell.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.tableView.rowHeight)
        cell.post = self.posts![indexPath.row]
        return cell
        
    }
}

