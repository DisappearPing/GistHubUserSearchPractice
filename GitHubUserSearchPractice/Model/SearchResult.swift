//
//  SearchResult.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import Foundation

struct SearchResultItem {
    let name: String
    let avatar: URL?
}

extension SearchResultItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatar = "avatar_url"
    }
}

struct SearchResultResponseObject {
    let totalCount: Int
    let items: [SearchResultItem]
}

extension SearchResultResponseObject: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
