//
//  randomusersTests.swift
//  randomusersTests
//
//  Created by Mikel Cobian on 31/1/25.
//

import Testing
@testable import randomusers
import CloudKit

@MainActor
struct randomusersTests {

	@Test func testInitFromDTO() async throws {

		let dto = UserDTO(
			gender: "male",
			name: NameDTO(title: "Mr", first: "John", last: "Doe"),
			location: LocationDTO(
				street: StreetDTO(number: 123, name: "Main St"),
				city: "City",
				state: "State",
				country: "Country",
				coordinates: CoordinatesDTO(latitude: "0", longitude: "0"),
				timezone: TimezoneDTO(offset: "+0", description: "GMT")
			),
			email: "john@example.com",
			login: LoginDTO(
				uuid: "123",
				username: "johndoe",
				password: "pass",
				salt: "salt",
				md5: "md5",
				sha1: "sha1",
				sha256: "sha256"
			),
			dob: DateInfoDTO(date: "2000-01-01", age: 23),
			registered: DateInfoDTO(date: "2020-01-01", age: 3),
			phone: "123456789",
			cell: "987654321",
			id: IDDTO(name: "SSN", value: "123-45-6789"),
			picture: PictureDTO(
				large: "large.jpg",
				medium: "medium.jpg",
				thumbnail: "thumbnail.jpg"
			),
			nat: "US"
		)
		
		let model = UserModel(dto: dto)
		
		#expect(model.name == "John")
		#expect(model.surname == "Doe")
		#expect(model.email == "john@example.com")
		#expect(model.phone == "123456789")
		#expect(model.picture == "large.jpg")
	}
	
	@Test func testInitFromCloudKitRecord() async throws {

		let record = CKRecord(recordType: "RemovedRandomUser")
		record.setValue("john@example.com", forKey: "email")
		record.setValue("John", forKey: "name")
		record.setValue("Doe", forKey: "surname")
		record.setValue("123456789", forKey: "phone")
		record.setValue("large.jpg", forKey: "picture")
		
		let model = UserModel(record: record)
		
		#expect(model?.name == "John")
		#expect(model?.surname == "Doe")
		#expect(model?.email == "john@example.com")
		#expect(model?.phone == "123456789")
		#expect(model?.picture == "large.jpg")
	}
}
