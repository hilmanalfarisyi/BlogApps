//
//  BlogPostTableViewCell.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 12/02/22.
//

import UIKit

class BlogPostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var updateAtLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onDeleteButtonTapped: ((Post) -> Void)?
    var onEditButtonTapped: ((Post) -> Void)?
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindView(post: Post) {
        self.post = post
        titleLabel.text = post.title
        contentLabel.text = post.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy • HH:mm"
        updateAtLabel.text = dateFormatter.string(from: post.updatedAt.toDate() ?? Date())
        
        
        
    }
    
    
    @IBAction func onDeleteButtonTapped(_ sender: Any) {
        onDeleteButtonTapped?(post!)
    }
    
    
    @IBAction func onEditButtonClicked(_ sender: Any) {
        onEditButtonTapped?(post!)
    }
    
    
    
}
