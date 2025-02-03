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
            // Get user record ID
            let userRecordID = try await CKContainer.default().userRecordID()
            let userReference = CKRecord.Reference(recordID: userRecordID, action: .none)
            let query = CKQuery(recordType: "RemovedRandomUser", predicate: NSPredicate(format: "client == %@", userRecordID))
            
            // Check for existing records
            let (results, _) = try await plublicDatabase.records(matching: query)
            
            // Create new record
            let record = CKRecord(recordType: "RemovedRandomUser")
            record.setValue(user.email, forKey: "email")
            record.setValue(user.name, forKey: "name")
            record.setValue(user.surname, forKey: "surname")
            record.setValue(user.phone, forKey: "phone")
            record.setValue(user.picture, forKey: "picture")
            record.setValue(userReference, forKey: "client")
            
            // Save record
            _ = try await plublicDatabase.save(record)
            
            print("User successfully saved to CloudKit")
        } catch {
            print("Error saving to CloudKit: \(error.localizedDescription)")
            throw CloudKitError.saveFailed
        }
    }
}
