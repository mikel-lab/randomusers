//
//  UserListViewModel.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    @Published private(set) var users: [UserModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUsers() async {
        isLoading = true
        error = nil
        
        do {
            users = try await userService.fetchUsers()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
