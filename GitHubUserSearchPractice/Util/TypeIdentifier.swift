//
//  TypeIdentifier.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import UIKit

protocol TypeIdentifier {
    static var identifier: String { get }
}

extension TypeIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: TypeIdentifier{
}

extension UITableViewCell: TypeIdentifier {
}

extension UICollectionViewCell: TypeIdentifier{
}
