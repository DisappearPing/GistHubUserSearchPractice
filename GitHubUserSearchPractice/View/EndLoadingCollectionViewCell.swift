//
//  EndLoadingCollectionViewCell.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import UIKit

class EndLoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIsLoading(_ isLoading: Bool) {
        
        isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        
    }

}
