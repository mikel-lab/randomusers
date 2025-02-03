//
//  UserListView.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import SwiftUI

struct UserListView: View {
	@StateObject private var viewModel = UserListViewModel()
	
	var body: some View {
		NavigationView {
			ZStack {
				if viewModel.isLoading {
					ProgressView()
						.scaleEffect(1.5)
				} else {
					VStack {
						// Add search bar
						TextField("Search by name or email", text: $viewModel.searchText)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding()
							.onChange(of: viewModel.searchText) { _ in
								viewModel.updateSearchResults()
							}
						
						ScrollView {
							LazyVStack(spacing: 16) {
								ForEach(viewModel.users, id: \.email) { user in
									UserRowView(user: user)
										.padding(.horizontal)
										.task {
											await viewModel.loadMoreIfNeeded(currentUser: user)
										}
									Divider()
								}
								
								if !viewModel.users.isEmpty {
									ProgressView()
										.padding()
								}
							}
						}
					}
				}
			}
			.navigationTitle("User List")
		}
		.task {
			await viewModel.fetchUsers()
		}
	}
}

#Preview {
	UserListView()
}
