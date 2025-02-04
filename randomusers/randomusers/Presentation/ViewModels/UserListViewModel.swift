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
	@Published var searchText = ""

	private let userService: UserServiceProtocol
	private let cloudKitService: CloudKitServiceProtocol
	private var currentPage = 1
	private var isFetching = false
	private var emailSet: Set<String> = []
	private var allUsers: [UserModel] = []

	init(userService: UserServiceProtocol = UserService(),
		 cloudKitService: CloudKitServiceProtocol = CloudKitService()) {
		self.userService = userService
		self.cloudKitService = cloudKitService

		// Load removed users when initializing
		Task {
			await loadRemovedUsers()
			await fetchUsers() // Only fetch users after loading removed ones
		}
	}
	
	private func loadRemovedUsers() async {
		do {
			let removedUsers = try await cloudKitService.fetchRemovedUsers()
			for user in removedUsers {
				emailSet.insert(user.email)
			}
			print("✅ Loaded \(removedUsers.count) removed users")
		} catch {
			print("❌ Error loading removed users: \(error.localizedDescription)")
		}
	}

	var filteredUsers: [UserModel] {
		guard !searchText.isEmpty else { return allUsers }
		return allUsers.filter { user in
			user.name.localizedCaseInsensitiveContains(searchText) ||
			user.email.localizedCaseInsensitiveContains(searchText)
		}
	}
	
	func fetchUsers() async {
		guard !isFetching else { return }
		
		isLoading = allUsers.isEmpty
		isFetching = true
		error = nil
		
		do {
			let newUsers = try await userService.fetchUsers(page: currentPage)
			
			// Filter out previously removed users
			let uniqueNewUsers = newUsers.filter { user in
				!emailSet.contains(user.email)
			}
			
			allUsers.append(contentsOf: uniqueNewUsers)
			users = filteredUsers
			
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
	
	func updateSearchResults() {
		users = filteredUsers
	}
	
	func deleteUser(_ user: UserModel) {
		Task {
			do {
				try await cloudKitService.saveRemovedUser(user)
				if let index = allUsers.firstIndex(where: { $0.email == user.email }) {
					allUsers.remove(at: index)
					emailSet.insert(user.email)
					users = filteredUsers
				}
			} catch {
				self.error = error
			}
		}
	}
}
