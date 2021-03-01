//
//  HomeViewModel.swift
//  SocialApp-MVVMC
//
//  Created by Oleksandr Bretsko on 2/27/21.
//


import UIKit

protocol LoginViewModelP: class {
    
    //MARK: - Outputs

    var onLoginAllowed: ((Bool) -> ())? {get set}

    //MARK: - Inputs
    
    func usernameChanged(username: String)
    func passwordChanged(password: String)

    func loginButtonTapped()
}

class LoginViewModel: LoginViewModelP {

    //MARK: - Outputs

    var onLoginAllowed: ((Bool) -> ())?

    //MARK: - Inputs

    func usernameChanged(username: String) {
        self.username = username
    }
    
    func passwordChanged(password: String) {
        self.password = password
    }
    
    func loginButtonTapped() {
        let valid = validateCredentials()
        onLoginAllowed?(valid)
    }
    
    //MARK: - Private properties
    
    private var username: String?
    private var password: String?
    
    private let netService: NetworkingServiceP

    // MARK: - Init
    
    init(netService: NetworkingServiceP) {
        self.netService = netService
    }
    
    //MARK: - Private methods

    private func validateCredentials() -> Bool {
        username?.isEmpty == false &&
            password?.isEmpty == false
    }
}

