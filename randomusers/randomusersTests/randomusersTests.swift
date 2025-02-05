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
	
	@Test func testDuplicateUserHandling() async throws {
			
			let mockService = MockUserService()
			let mockCloudKit = MockCloudKitService()
			let viewModel = UserListViewModel(userService: mockService, cloudKitService: mockCloudKit)
			
			let userDTO1 = UserDTO(
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
					large: "pic1.jpg",
					medium: "medium.jpg",
					thumbnail: "thumbnail.jpg"
				),
				nat: "US"
			)
			
			let userDTO2 = userDTO1
			
			let user1 = UserModel(dto: userDTO1)
			let user2 = UserModel(dto: userDTO2)
			
			// mock service that returns test users
			class TestUserService: UserServiceProtocol {
				let testUsers: [UserModel]
				init(testUsers: [UserModel]) {
					self.testUsers = testUsers
				}
				func fetchUsers(page: Int) async throws -> [UserModel] {
					return testUsers
				}
			}
			
			let testService = TestUserService(testUsers: [user1, user2])
			let testViewModel = UserListViewModel(userService: testService, cloudKitService: mockCloudKit)
			
			await testViewModel.fetchUsers()
			
			#expect(testViewModel.allUsers.count == 1)
			#expect(testViewModel.allUsers[0].email == "john@example.com")
		}
	
	@Test func testUserSearch() async throws {
		let mockService = MockUserService()
		let mockCloudKit = MockCloudKitService()
		let viewModel = UserListViewModel(userService: mockService, cloudKitService: mockCloudKit)

		let userDTO1 = UserDTO(
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
				large: "pic1.jpg",
				medium: "medium.jpg",
				thumbnail: "thumbnail.jpg"
			),
			nat: "US"
		)
			   
		let userDTO2 = UserDTO(
			gender: "female",
			name: NameDTO(title: "Ms", first: "Jane", last: "Smith"),
			location: LocationDTO(
				street: StreetDTO(number: 456, name: "Second St"),
				city: "City",
				state: "State",
				country: "Country",
				coordinates: CoordinatesDTO(latitude: "0", longitude: "0"),
				timezone: TimezoneDTO(offset: "+0", description: "GMT")
			),
			email: "jane@example.com",
			login: LoginDTO(
				uuid: "456",
				username: "janesmith",
				password: "pass",
				salt: "salt",
				md5: "md5",
				sha1: "sha1",
				sha256: "sha256"
			),
			dob: DateInfoDTO(date: "2000-01-01", age: 23),
			registered: DateInfoDTO(date: "2020-01-01", age: 3),
			phone: "987654321",
			cell: "123456789",
			id: IDDTO(name: "SSN", value: "987-65-4321"),
			picture: PictureDTO(
				large: "pic2.jpg",
				medium: "medium.jpg",
				thumbnail: "thumbnail.jpg"
			),
			nat: "US"
		)
		
		let user1 = UserModel(dto: userDTO1)
		let user2 = UserModel(dto: userDTO2)
		
		// test examples
		viewModel.allUsers = [user1, user2]
		viewModel.users = viewModel.allUsers
		
		// search by name
		viewModel.searchText = "John"
		await viewModel.updateSearchResults()
		
		#expect(viewModel.filteredUsers.count == 1)
		#expect(viewModel.filteredUsers[0].name == "John")
		
		// search by email
		viewModel.searchText = "jane@"
		await viewModel.updateSearchResults()
		
		#expect(viewModel.filteredUsers.count == 1)
		#expect(viewModel.filteredUsers[0].email == "jane@example.com")
		}
	
}

class MockUserService: UserServiceProtocol {
	func fetchUsers(page: Int) async throws -> [UserModel] { return [] }
}

class MockCloudKitService: CloudKitServiceProtocol {
	func saveRemovedUser(_ user: UserModel) async throws {}
	func fetchRemovedUsers() async throws -> [UserModel] { return [] }
}
