//
//  UserDTO.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation

// generic structure
struct UserResponse: Codable {
	let results: [UserDTO]
	let info: InfoDTO
}

// user DTO
struct UserDTO: Codable {
	let gender: String
	let name: NameDTO
	let location: LocationDTO
	let email: String
	let login: LoginDTO
	let dob: DateInfoDTO
	let registered: DateInfoDTO
	let phone: String
	let cell: String
	let id: IDDTO
	let picture: PictureDTO
	let nat: String
}

struct NameDTO: Codable {
	let title: String
	let first: String
	let last: String
}

struct LocationDTO: Codable {
	let street: StreetDTO
	let city: String
	let state: String
	let country: String
	let coordinates: CoordinatesDTO
	let timezone: TimezoneDTO
}

struct StreetDTO: Codable {
	let number: Int
	let name: String
}

struct CoordinatesDTO: Codable {
	let latitude: String
	let longitude: String
}

struct TimezoneDTO: Codable {
	let offset: String
	let description: String
}

struct LoginDTO: Codable {
	let uuid: String
	let username: String
	let password: String
	let salt: String
	let md5: String
	let sha1: String
	let sha256: String
}

struct DateInfoDTO: Codable {
	let date: String
	let age: Int
}

struct IDDTO: Codable {
	let name: String
	let value: String?
}

struct PictureDTO: Codable {
	let large: String
	let medium: String
	let thumbnail: String
}

struct InfoDTO: Codable {
	let seed: String
	let results: Int
	let page: Int
	let version: String
}
