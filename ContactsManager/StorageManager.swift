//
//  StorageManager.swift
//  ContactBook
//
//  Created by Klodiana Prenga on 09/11/2019.
//  Copyright © 2019 Klodiana Prenga. All rights reserved.
//

import Foundation

// The purpose of this class is to manage the file & directory memory, by creating URLs, encoding, decoding and writing the data

internal class StorageManager: NSObject {
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    private var savePathDirectory: URL?

    override init() {
        super.init()

        savePathDirectory = createDirectoryIfNotExist()
    }
}

// MARK: - Class Implementation

extension StorageManager {
    func save(_ contact: Contact) {
        guard let urlPath = savePathDirectory else {
            print("Couldn't find path directory `Contacts` for saving.")
            return
        }

        do {
            let data = try encoder.encode(contact)
            try data.write(to: urlPath.appendingPathComponent(contact.id))
        } catch {}
    }

    func delete(_ contact: Contact) {
        guard let urlPath = savePathDirectory else {
            print("Couldn't find path directory `Contacts` for deleting.")
            return
        }

        do {
            try FileManager.default.removeItem(at: urlPath.appendingPathComponent(contact.id))
        } catch {}
    }

    func retrieveContact(fromPath: URL) -> Contact? {
        do {
            let data = try Data(contentsOf: fromPath)
            let contact = try decoder.decode(Contact.self, from: data)
            return contact
        } catch {
            print("Couldn't find path directory or the contact file.")
            return nil
        }
    }

    func retrieveAllContacts() -> [Contact] {
        guard let urlPath = savePathDirectory else {
            print("Couldn't find path directory `Contacts`.")
            return []
        }

        var allContacts: [Contact] = []

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: urlPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            fileURLs.forEach { contactPath in
                if let contact = self.retrieveContact(fromPath: contactPath) {
                    allContacts.append(contact)
                }
            }
        } catch {}

        return allContacts
    }

    func deleteAll() {
        guard let urlPath = savePathDirectory else {
            print("Couldn't find path directory `Contacts`.")
            return
        }

        do {
            try FileManager.default.removeItem(at: urlPath)
        } catch {
            print("Contacts directory couldn't be deleted")
        }
    }
}

// MARK: - Private

internal extension StorageManager {
    // Check for the file manager
    private func createDirectoryIfNotExist() -> URL {
        let fileDirectory = FileManager.SearchPathDirectory.documentDirectory
        guard let url = FileManager.default.urls(for: fileDirectory, in: .userDomainMask).first else {
            fatalError("Could not create URL for specified directory!")
        }

        // We can also use the default documents directory folder, but it is better to not pollute the docs folder
        // And also when we need to delete all of them, we can just delete the whole Contacts folder

        do {
            let contactsPath = url.appendingPathComponent("Contacts")
            try FileManager.default.createDirectory(atPath: contactsPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {}

        return url.appendingPathComponent("Contacts")
    }
}
