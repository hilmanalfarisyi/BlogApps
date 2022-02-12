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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindView(post: Post) {
        titleLabel.text = post.title
        contentLabel.text = post.content
        updateAtLabel.text = post.updatedAt
        
        
    }
    
    
    
    
}
