//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit


protocol PostListVCP: BaseViewControllerP {
    
    var onPostSelected: ((Post) -> Void)? { get set }
    
    var onLogout: (() -> Void)? { get set }
}

class PostListVC: UIViewController, PostListVCP {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PostListViewModelP!
    
    var netService: NetworkingServiceP!
    
    //MARK: - PostListVCP

    var onPostSelected: ((Post) -> Void)?
    
    var onLogout: (() -> Void)?

    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: PostCell.cellReuseId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutButtonPressed))
        navigationItem.rightBarButtonItem = logoutButton
        
        setupViewModel()
        viewModel.ready()
    }
    
    //MARK: - private
    
    private func setupViewModel() {
        viewModel.didUpdatePosts = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onPostSelected = { [weak self] post in
            self?.onPostSelected?(post)
        }
    }
    
    @objc private func logoutButtonPressed(){
        self.onLogout?()
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !viewModel.posts.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        cell.configure(with: viewModel.posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectPost(at: indexPath.row)
    }
}
