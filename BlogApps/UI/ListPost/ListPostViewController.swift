//
//  ListPostViewController.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import UIKit
import SVProgressHUD
import RxSwift

class ListPostViewController: UIViewController {

    @IBOutlet private weak var listPostTableView: UITableView!
    
    var dispose  = DisposeBag()
    var networkModel = BlogPostDefaultNetworkModel()
    
    var listPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
//         SVProgressHUD.show()
        
        
        networkModel.retrieveListBlogPost().subscribe { [weak self] (listpost : [Post]) in
            print("DebugRequest retrieveListBlogPost \(listpost)")
            self?.listPost = listpost
            self?.reloadData()
            
        } onError: { (error: Error) in
            print("DebugRequest retrieveListBlogPost error \(error)")

        } onCompleted: {
            print("DebugRequest retrieveListBlogPost compled")
        } .disposed(by: dispose)

        networkModel.showBlogPost().subscribe { (post : Post) in
            print("DebugRequest showBlogPost \(post)")
        } onError: { (error: Error) in
            print("DebugRequest  showBlogPost error \(error)")
            print("DebugRequest showBlogPost error \(error.localizedDescription)")
            

        } onCompleted: {
            print("DebugRequest compled")
        } .disposed(by: dispose)
        
//        networkModel.createBlogPost(param: NewPostParam(title: "this is a title", content: "This is a content")).subscribe { (post : Post) in
//            print("DebugRequest createBlogPost \(post)")
//        } onError: { (error: Error) in
//            print("DebugRequest createBlogPost error \(error)")
//            
//            
//
//        } onCompleted: {
//            print("DebugRequest createBlogPost compled")
//        } .disposed(by: dispose)
        
        networkModel.deleteBlogPost(id: 521).subscribe { (post : Post) in
            print("DebugRequest deleteBlogPost \(post)")
        } onError: { (error: Error) in
            print("DebugRequest deleteBlogPost error \(error)")
            
            

        } onCompleted: {
            print("DebugRequest deleteBlogPost compled")
        } .disposed(by: dispose)

        
        networkModel.updateBlogPost(id: 685, param:  NewPostParam(title: "this is a title updated", content: "This is a content updated")).subscribe { (post : Post) in
            
            print("DebugRequest updateBlogPost \(post)")
            
        } onError: { (error: Error) in
            print("DebugRequest updateBlogPost error \(error)")
            
            

        } onCompleted: {
            print("DebugRequest updateBlogPost compled")
        } .disposed(by: dispose)
        
        
        let nib = UINib(nibName: "BlogPostTableViewCell", bundle: nil)
        
        listPostTableView.register(nib, forCellReuseIdentifier: "BlogPostTableViewCell")
        listPostTableView.delegate = self
        listPostTableView.dataSource = self
        
        addFloatingButton()
        
        
    }
    
    private func reloadData() {
        listPostTableView.reloadData()
    }
    
    func addFloatingButton(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 285, y: 485, width: 100, height: 100)
        btn.setTitle("Create Post", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 50
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
//        btn.addTarget(self,action: #selector(DestinationVC.buttonTapped), for: UIControlEvent.touchUpInside)
        view.addSubview(btn)
    }



}

extension ListPostViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("DebugTableView \(listPost.count)")
        return listPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogPostTableViewCell", for: indexPath) as! BlogPostTableViewCell

        cell.bindView(post: listPost[indexPath.row])
        
        
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}

extension ListPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DebugSelectedItem \(indexPath)")
    }
    
}

