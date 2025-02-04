//
//  randomusersApp.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import SwiftUI

@main
struct randomusersApp: App {
	var body: some Scene {
		WindowGroup {
			TabView {
				UserListView()
					.tabItem {
						Label("Users", systemImage: "person.3")
					}
				
				RemovedUsersView()
					.tabItem {
						Label("Removed", systemImage: "trash")
					}
			}
		}
	}
}
