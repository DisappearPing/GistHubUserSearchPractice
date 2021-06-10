//
//  SearchResultItemCollectionViewCell.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import UIKit
import SDWebImage

class SearchResultItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .lightGray
      
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.avatarView.layer.cornerRadius = 10
        self.avatarView.clipsToBounds = true
        
    }
        
    func setUp(withItemData data: SearchResultItem) {
        
        self.avatarView.sd_setImage(with: data.avatar)
        self.nameLabel.text = data.name
        
    }

}
