//
//  ContactManager.swift
//  ContactBook
//
//  Created by Klodiana Prenga on 09/11/2019.
//  Copyright © 2019 Klodiana Prenga. All rights reserved.
//

import Foundation

// For sorting we use enums to have a clear understanding when we read the code that how we should sort

public enum SortType {
    case ascending, descending
}

public enum SortCriteria {
    case firstName, lastName
}

// The purpose of this class is to make a simple interface for the user and provide all the necessary APIs for working with all the contacts

public class ContactManager: NSObject {

    // MARK: - Public objects

    public static let shared = ContactManager()
    public private(set) var allContacts: [Contact] = []

    // MARK: - Private objects

    private let storageManager = StorageManager()  
    private var sortType: SortType = .ascending
    private var sortCriteria: SortCriteria = .firstName

    // MARK: - Class Lifecycle

    public override init() {
        super.init()

        allContacts = storageManager.retrieveAllContacts()
        sortContacts()
    }
}

// MARK: - Public Implementation

extension ContactManager {

    /// This method will sort `allContacts` array and also save the sorting criterias to be used in the future from the create/update/delete methods.
    /// - Parameter type: the type to sort the array
    /// - Parameter criteria: the criterias to sort the array
    public func sort(type: SortType, criteria: SortCriteria) {
        sortType = type
        sortCriteria = criteria
        sortContacts()
    }

    /// This method will save the given contact in the storage and insert it in the `allContacts` array
    /// - Parameter contact: The Contact object that should be stored
    public func create(_ contact: Contact) {
        // First save the contact in the file storage
        storageManager.save(contact)
        // Then insert the contact in the sorted array
        insertContactInSortedArray(contact: contact)
    }


    /// This method will delete a given contact from the storage and also remove it from the `allContacts` array
    /// - Parameter contact: The Contact object to be deleted
    public func delete(_ contact: Contact) {
        // First delete the contact from the file storage
        storageManager.delete(contact)
        // Then also update the sorted array by removing all instances of that contact
        allContacts.removeAll { $0.id == contact.id }
    }


    /// This method will update the given contact with the new data. The contact to be updated is identified by the `id` property of the contact which is a readonly property. This method will also update the contact position inside `allContacts` array.
    /// - Parameter contact: The Contact that will update itself in the storage
    public func update(_ contact: Contact) {
        // First update the contact in the file storage (since the contact has the same filename, updating and creating a new contact is the same)
        storageManager.save(contact)

        // First remove the old contact from the array
        allContacts.removeAll { $0.id == contact.id }

        // Then insert the contact in the sorted array
        insertContactInSortedArray(contact: contact)

    }


    /// This method will delete all contacts from the storage and from the local `allContacts` array.
    public func deleteAll() {
        // First delete all contacts from file storage
        storageManager.deleteAll()
        // Then remove all contacts from the sorted array as well
        allContacts.removeAll()
    }
}


// MARK: - Private

extension ContactManager {
    private func sortContacts() {
        allContacts = allContacts.sorted { (first, second) -> Bool in
            return filteringLogic(first: first, second: second)
        }
    }

    // In order to avoid duplicated code, we can extract the filtering logig

    /// This method is used for defining sorting logic of the array. Because this logic is how sorting is done, we can also use this code to iterate within the array to find the indexes of objects.
    /// - Parameter first: the first contact to be compared: $0
    /// - Parameter second: the second contact to be compared: $1
    private func filteringLogic(first: Contact, second: Contact) -> Bool {
        switch sortType {
        case .ascending:
            switch sortCriteria {
            case .firstName:
                return first.firstName.lowercased() < second.firstName.lowercased()
            case .lastName:
                return first.lastName.lowercased() < second.lastName.lowercased()
            }
        case .descending:
            switch sortCriteria {
            case .firstName:
                return first.firstName.lowercased() > second.firstName.lowercased()
            case .lastName:
                return first.lastName.lowercased() > second.lastName.lowercased()
            }
        }
    }

    private func insertContactInSortedArray(contact: Contact) {
        // First we find at what index the contact should be added by checking with the sort filters
        let savedContactIndex = allContacts.firstIndex { savedContact -> Bool in
            return filteringLogic(first: contact, second: savedContact)
        }
        // Then we check the validity of the index
        if let index = savedContactIndex {
            allContacts.insert(contact, at: index)
        } else {
            allContacts.append(contact)
        }

        // Above is the long method
        // The simple method could be:
        // allContacts.append(contact)
        // sortContacts()
        // But this is not eficient when we have a large amount of contacts because sorting is a very costly process
    }
}
