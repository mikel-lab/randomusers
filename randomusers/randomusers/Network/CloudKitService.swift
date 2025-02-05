//
//  CloudKitService.swift
//  randomusers
//
//  Created by Mikel Cobian on 31/1/25.
//

import Foundation
import CloudKit

enum CloudKitError: Error {
    case saveFailed
    case recordNotFound
    case userNotFound
}

protocol CloudKitServiceProtocol {
    func saveRemovedUser(_ user: UserModel) async throws
	func fetchRemovedUsers() async throws -> [UserModel]
}

class CloudKitService: CloudKitServiceProtocol {
    // MARK: - Properties
    private let container: CKContainer
    private let database: CKDatabase
    @Published var errorMessage: String = ""
    
    // MARK: - Initialization
    init() {
        self.container = CKContainer.default()
        self.database = container.publicCloudDatabase
    }
    
    // MARK: - Public Methods
    func saveRemovedUser(_ user: UserModel) async throws {
        let plublicDatabase = CKContainer.default().publicCloudDatabase
        
        do {
            // get user record ID
            let userRecordID = try await CKContainer.default().userRecordID()
            let userReference = CKRecord.Reference(recordID: userRecordID, action: .none)
            let query = CKQuery(recordType: "RemovedRandomUser", predicate: NSPredicate(format: "client == %@", userRecordID))
            
            // check existing people
            let (results, _) = try await plublicDatabase.records(matching: query)
            
            // create new person
            let record = CKRecord(recordType: "RemovedRandomUser")
            record.setValue(user.email, forKey: "email")
            record.setValue(user.name, forKey: "name")
            record.setValue(user.surname, forKey: "surname")
            record.setValue(user.phone, forKey: "phone")
            record.setValue(user.picture, forKey: "picture")
            record.setValue(userReference, forKey: "client")
            
            // save
            _ = try await plublicDatabase.save(record)
            
            print("User successfully saved to CloudKit")
        } catch {
            print("Error saving to CloudKit: \(error.localizedDescription)")
            throw CloudKitError.saveFailed
        }
    }
	

	func fetchRemovedUsers() async throws -> [UserModel] {
		let publicDB = CKContainer.default().publicCloudDatabase
		let query = CKQuery(recordType: "RemovedRandomUser", predicate: NSPredicate(value: true))
		let (results, _) = try await publicDB.records(matching: query)
		
		var removedUsers: [UserModel] = []
		
		//
		for (_, result) in results {
			switch result {
			case .success(let record):
				if let user = UserModel(record: record) {
					removedUsers.append(user)
				} else {
					print("Error: Campos faltantes en el registro \(record.recordID)")
				}
			case .failure(let error):
				print("Error recuperando el registro: \(error.localizedDescription)")
			}
		}
		
		return removedUsers
	}
}
