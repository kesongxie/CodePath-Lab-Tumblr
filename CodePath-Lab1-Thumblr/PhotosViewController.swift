//
//  ViewController.swift
//  CodePath-Lab1-Thumblr
//
//  Created by Xie kesong on 1/28/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PhotoCell"
fileprivate let headerReuseIden = "HeaderCell"

fileprivate let ShowDetail = "ShowDetail"
fileprivate let sectionHeaderHeight: CGFloat = 80
class PhotosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var posts: [NSDictionary] = []{
        didSet{
            DispatchQueue.main.async {
                self.isFetchingInProcess = false
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var refreshControl = UIRefreshControl()
    
    var isFetchingInProcess = false;
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        self.activityIndicator.center = self.footerView.center
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(_:)), for: .valueChanged)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54 / 255.0, green: 70 / 255.0, blue: 93 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.tableView.refreshControl = self.refreshControl
        self.tableView.rowHeight = 240;
        self.fetchPost()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier, iden == ShowDetail{
            if let detailVC = segue.destination as? PhotoDetailViewController{
                guard let selectedCell = sender as? PhotoCellTableViewCell else{
                    return
                }
                guard let selectedIndexSection = self.tableView.indexPath(for: selectedCell)?.section else{
                    return
                }
                detailVC.post = self.posts[selectedIndexSection]
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func refreshDragged(_ refreshControl: UIRefreshControl){
        self.fetchPost()
    }
    
    func fetchPost(){
        let offset = self.posts.count
        guard let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset)") else{
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        self.isFetchingInProcess = true
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
                    
                    guard posts.count != 0 else{
                        self.footerView.isHidden = true
                        return
                    }
                    
                    self.posts.append(contentsOf: posts)
                }catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isFetchingInProcess{
            if(scrollView.contentOffset.y > scrollView.contentSize.height - self.view.frame.size.height){
                self.fetchPost()
            }
        }
    }

}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseIden) as! HeaderTableViewCell
        cell.post = self.posts[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PhotoCellTableViewCell
        cell.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.tableView.rowHeight)
        cell.post = self.posts[indexPath.section]
        cell.selectionStyle = .none
        return cell
        
    }
}

