//
//  LoginVC.swift
//  SocialApp-MVVMC
//
//  Created by Oleksandr Bretsko on 2/27/21.
//

import UIKit

protocol LoginVCP: BaseViewControllerP {
    
    var onLogin: (() -> Void)? { get set }
}

class LoginVC: UIViewController, LoginVCP {
    
    var viewModel: LoginViewModelP!
     
    //MARK: - LoginVCP

    var onLogin: (() -> Void)?
    
    //MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        setupViewModel()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.loginButtonTapped()
    }
    
    //MARK: - private
    
    private func setupViewModel() {
        viewModel.onLoginAllowed = { [weak self] allowed in
            if allowed {
                self?.onLogin?()
            } else {
                // show invalid credentials
            }
        }
        
        viewModel.usernameChanged(username: "testUser")
        viewModel.passwordChanged(password: "testPassword")
    }
    
    //TODO: add 2 textFields
    //usernameChanged(username: String)
    //passwordChanged(password: String)
}
