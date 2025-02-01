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
	private var currentPage = 1
	private var isFetching = false
	
	init(userService: UserServiceProtocol = UserService()) {
		self.userService = userService
	}
	
	func fetchUsers() async {
		guard !isFetching else { return }
		
		isLoading = users.isEmpty
		isFetching = true
		error = nil
		
		do {
			let newUsers = try await userService.fetchUsers(page: currentPage)
			users.append(contentsOf: newUsers)
			currentPage += 1
		} catch {
			self.error = error
		}
		
		isLoading = false
		isFetching = false
	}
	
	func loadMoreIfNeeded(currentUser user: UserModel) async {
		let thresholdIndex = users.index(users.endIndex, offsetBy: -5)
		if let userIndex = users.firstIndex(where: { $0.email == user.email }), 
		   userIndex == thresholdIndex {
			await fetchUsers()
		}
	}
}
