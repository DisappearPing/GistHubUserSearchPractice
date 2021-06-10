//
//  ViewController.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import UIKit

class SearchGitHubUserVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var searchResultItems = [SearchResultItem]() {
        didSet {
            self.searchResultCollectionView.reloadData()
        }
    }
    var searchKeyWord = "" {
        didSet {
            self.fetchSearchUserResult()
        }
    }
    
    var page = 1
    var totalCount = 0
    var loading = false
    var ErrorloadEnded = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchResultCollectionView.register(UINib(nibName: SearchResultItemCollectionViewCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: SearchResultItemCollectionViewCell.identifier)
        searchResultCollectionView.register(UINib(nibName: EndLoadingCollectionViewCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: EndLoadingCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - Custom Method

extension SearchGitHubUserVC {
    
    func fetchSearchUserResult() {
        
        loading = true
        
        MyApiService.shared.getUserListWithUserName(self.searchKeyWord, page: self.page) { searchResultResponse in
            
            self.loading = false
            
            switch searchResultResponse {
            
            case .success(let searchResultResponseObject):
                
                self.searchResultItems.append(contentsOf: searchResultResponseObject.items)
                
                self.totalCount = searchResultResponseObject.totalCount
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                var localErrorString = ""
                
                switch error {
                case .httpResponseError(statusCode: let statusCode, reason: let reasonString, description: let description):
                    
                    localErrorString = "\(statusCode) \(String(describing: reasonString ?? "")) \(String(describing: description ?? ""))"
                    
                    
                default:
                    
                    localErrorString = error.localizedDescription
                }
                
                self.showAlert(withMessage: localErrorString)
                self.ErrorloadEnded = true
                self.searchResultCollectionView.reloadData()
                
            }
            
        }
        
    }
    
    func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
        })
       
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - Delegate

extension SearchGitHubUserVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
   
    // MARK: - Collectionview
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchKeyWord == "" ? 0 : searchResultItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row >= searchResultItems.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EndLoadingCollectionViewCell.identifier, for: indexPath) as! EndLoadingCollectionViewCell
            
            cell.setIsLoading(self.loading)
            
            if searchResultItems.count < self.totalCount && loading == false && ErrorloadEnded == false {
            
                self.page += 1
                self.fetchSearchUserResult()
                
            }
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultItemCollectionViewCell.identifier, for: indexPath) as! SearchResultItemCollectionViewCell
        
        let item = searchResultItems[indexPath.row]
        
        cell.setUp(withItemData: item)
        
        return cell
    }
    
    // MARK: - SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let searchKeyWord = searchBar.text, searchKeyWord.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0 {
            
            self.page = 1
            self.totalCount = 0
            self.searchResultItems = []
            self.ErrorloadEnded = false
            self.searchKeyWord = searchKeyWord
            
        }
        
    }
    
}

