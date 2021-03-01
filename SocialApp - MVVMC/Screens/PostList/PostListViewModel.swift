//
//  PostListViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

protocol PostListViewModelP: class {
    
    //MARK: Outputs
    
    var posts: [Post] {get}

    var didUpdatePosts: (() -> ())? {get set}
    
    var onPostSelected: ((Post) -> ())? {get set}
    
    //MARK: Inputs
    
    func ready()
    
    func didSelectPost(at index: Int)
}


class PostListViewModel: PostListViewModelP { 
    
    //MARK: - Outputs
    
    var didUpdatePosts: (() -> ())?
    
    var onPostSelected: ((Post) -> ())?
    
    private(set) var posts = [Post]() {
        didSet {
            didUpdatePosts?()
        }
    }
    
    //MARK: - Inputs
    
    func ready() {
        netService.loadPosts { [weak self] result in
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let posts):
                DispatchQueue.main.async { [weak self] in
                    self?.posts = posts
                }
            }
        }
        
        netService.loadPosts { [weak self] result in
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let posts):
                print("INFO: \(posts.count) posts received from network")
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.posts = posts
                    strongSelf.didUpdatePosts?()
                }
            }
        }
    }
    
    func didSelectPost(at index: Int) {
        onPostSelected?(posts[index])
    }
   
    //MARK: - Private properties
    
    private let netService: NetworkingServiceP
    
    // MARK: - Init
    
    init(_ netService: NetworkingServiceP) {
        self.netService = netService
    }
}

