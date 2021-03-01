//
//  PostViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

protocol PostViewModelP: class {

    //MARK: Outputs

    var didUpdateUser: ((User) -> Void)? {get set}
    var didUpdatePost: ((Post) -> Void)? {get set}
    var didUpdateComments: (([Comment]) -> Void)? {get set}
    
    var post: Post {get set}
    var comments: [Comment] {get}
    var user: User! {get}
    
    //MARK: Inputs
    
    func ready()
}

class PostViewModel: PostViewModelP {
    
    //MARK: - Outputs
    
    var didUpdateUser: ((User) -> Void)?
    var didUpdatePost: ((Post) -> Void)?
    var didUpdateComments: (([Comment]) -> Void)?
    
    var post: Post {
        didSet {
            didUpdatePost?(post)
        }
    }
    private(set) var comments = [Comment]() {
        didSet {
            didUpdateComments?(comments)
        }
    }
    private(set) var user: User! {
        didSet {
            didUpdateUser?(user)
        }
    }
    
    //MARK: - Inputs
    
    func ready() {
        loadUser()
        loadComments()
    }

    //MARK: - Private properties
    
    private let netService: NetworkingServiceP
    
    // MARK: - Init
    
    init(_ post: Post,
         _ netService: NetworkingServiceP) {
        self.post = post
        self.netService = netService
    }
    
    //MARK: - Private
    
    private func loadUser() {
        netService.loadUsers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")

            case .success(let users):
                print("INFO: \(users.count) users received from network")
                guard let user = users.first(where: {
                    $0.id == strongSelf.post.userId
                }) else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.user = user
                }
            }
        }
    }
    
    private func loadComments() {
        netService.loadComments { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let comments: [Comment]
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                return
            case .success(let receivedComments):
                comments = receivedComments
                break
            }
            let commentsForPost = comments.filter {
                $0.postId == strongSelf.post.id
            }
            print("INFO: found \(commentsForPost.count) comments for this post")

            DispatchQueue.main.async {
                strongSelf.comments = commentsForPost
            }
        }
    }
}

