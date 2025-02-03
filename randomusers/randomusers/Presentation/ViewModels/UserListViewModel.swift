//
//  UserListViewModel.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject {
	@Published var users: [UserModel] = []
	@Published var isLoading = false
	@Published var error: Error?
	
	private let userService: UserServiceProtocol
	private var currentPage = 1
	private var isFetching = false
	private var emailSet: Set<String> = [] // Track unique emails
	
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
			
			// Filter out duplicate users based on email
			let uniqueNewUsers = newUsers.filter { user in
				!emailSet.contains(user.email)
			}
			
			// Update email set and users array
			uniqueNewUsers.forEach { user in
				emailSet.insert(user.email)
			}
			users.append(contentsOf: uniqueNewUsers)
			
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
