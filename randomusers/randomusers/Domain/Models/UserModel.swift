//
//  UserModel.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation
import CloudKit

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
	
	init?(record: CKRecord) {
		guard let name = record["name"] as? String,
			  let surname = record["surname"] as? String,
			  let email = record["email"] as? String,
			  let picture = record["picture"] as? String,
			  let phone = record["phone"] as? String else {
			return nil
		}
		
		self.name = name
		self.surname = surname
		self.email = email
		self.picture = picture
		self.phone = phone
	}
}
