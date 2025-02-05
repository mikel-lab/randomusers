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
						TextField("Search by name or email", text: $viewModel.searchText)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding()
							.onChange(of: viewModel.searchText) { _ in
								viewModel.updateSearchResults()
							}
						
						ScrollView {
							LazyVStack(spacing: 16) {
								ForEach(viewModel.users, id: \.email) { user in
									ZStack {
										NavigationLink(destination: UserDetailView(user: user)) {
											UserRowView(user: user) {
												viewModel.deleteUser(user)
											}
											.padding(.horizontal)
										}
										.buttonStyle(PlainButtonStyle())
										.task {
											await viewModel.loadMoreIfNeeded(currentUser: user)
										}
									}
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
