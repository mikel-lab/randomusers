//
//  UserRowView.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import SwiftUI

struct UserRowView: View {
	let user: UserModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 12) {
				AsyncImage(url: URL(string: user.picture)) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				} placeholder: {
					ProgressView()
				}
				.frame(width: 50, height: 50)
				.clipShape(Circle())
				
				VStack(alignment: .leading, spacing: 4) {
					Text(user.name)
						.font(.headline)
					Text(user.surname)
						.font(.subheadline)
				}
				
				Spacer() 
			}
			
			VStack(alignment: .leading, spacing: 4) {
				HStack(spacing: 4) {
					Text("Mail:")
						.fontWeight(.medium)
					Text(user.email)
				}
				.font(.subheadline)
				.foregroundColor(.secondary)
				
				HStack(spacing: 4) {
					Text("Phone:")
						.fontWeight(.medium)
					Text(user.phone)
				}
				.font(.subheadline)
				.foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity, alignment: .leading) 
	}
}
