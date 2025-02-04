//
//  RemovedUsersView.swift
//  randomusers
//
//  Created by Mikel Cobian on 4/2/25.
//

import SwiftUI

struct RemovedUsersView: View {
	@StateObject private var viewModel = UserListViewModel()
	
	var body: some View {
		NavigationView {
			ZStack {
				if viewModel.isLoading {
					ProgressView()
						.scaleEffect(1.5)
				} else {
					ScrollView {
						LazyVStack(spacing: 16) {
							ForEach(viewModel.removedUsers, id: \.email) { user in
								RemovedUserRowView(user: user)
									.padding(.horizontal)
							}
						}
					}
				}
			}
			.navigationTitle("Removed Users")
		}
		.task {
			await viewModel.fetchRemovedUsers()
		}
	}
}
