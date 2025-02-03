//
//  UserDetailView.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: UserModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.picture)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(user.surname)
                        .font(.title2)
                }
                
                VStack(spacing: 16) {
                    DetailRowView(title: "Email", value: user.email)
                    DetailRowView(title: "Phone", value: user.phone)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
