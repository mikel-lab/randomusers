//
//  UserService.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation

enum UserServiceError: Error {
	case invalidURL
	case networkError(Error)
	case decodingError(Error)
}

protocol UserServiceProtocol {
	func fetchUsers(page: Int) async throws -> [UserModel]
}

class UserService: UserServiceProtocol {
	private let baseURL = "https://api.randomuser.me"
	private let resultsCount = 20
	
	func fetchUsers(page: Int) async throws -> [UserModel] {
		guard let url = URL(string: "\(baseURL)/?page=\(page)&results=\(resultsCount)") else {
			throw UserServiceError.invalidURL
		}
		
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			
			// Print response and data for debugging
			if let httpResponse = response as? HTTPURLResponse {
				print("Response status code: \(httpResponse.statusCode)")
			}
			print("Received data length: \(data.count) bytes")
			
			if let jsonString = String(data: data, encoding: .utf8) {
				print("Received JSON: \(jsonString)")
			}
			
			do {
				let response = try JSONDecoder().decode(UserResponse.self, from: data)
				return response.results.map(UserModel.init)
			} catch let error as DecodingError {
				print("Decoding error: \(error)")
				throw UserServiceError.decodingError(error)
			}
		} catch {
			print("Network error: \(error)")
			throw UserServiceError.networkError(error)
		}
	}
}
