//
//  UserModel.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation

struct UserModel {
	let name: String
	let surname: String
	let email: String
	let picture: String 
	let phone: String
	
	init(dto: UserDTO) {
		self.name = dto.name.first
		self.surname = dto.name.last
		self.email = dto.email
		self.picture = dto.picture.large
		self.phone = dto.phone
	}
}
