//
//  Contact.swift
//  ContactBook
//
//  Created by Klodiana Prenga on 09/11/2019.
//  Copyright © 2019 Klodiana Prenga. All rights reserved.
//

import Foundation

// By conforming to Codable protocol, we ensure that this object type is available to be saved in multiple formats: NSUserDefaults, as Data, etc.

// We make this enum as string so we can use it easily with codable
public enum Type: String, Codable {
    case Work, Cellphone, Home
}

// We create the model as a class to have a reference type on it, because if we use a struct, we have a value type and need to update all similar instances
public struct Contact: Codable {
    public let id: String

    public var firstName: String
    public var lastName: String
    public var phoneNumber: String
    public var type: Type

    public var fullName: String {
        return firstName + " " + lastName
    }

    // We create this id to be the name of the file saved in storage
    // This is how we will identify the file of each contact
    // Whenever a user edits a contact, we can update the contact that corresponds to this unique id

    // We need to create a public initializer because the default initializer of a struct is internal and not available outside of the framework
    public init(firstName: String, lastName: String, phoneNumber: String, type: Type) {
        // Set contact id to a very safe unique identifier
        // Since the task specifies that we can have multiple contacts with the same data, then we can generate this id randomly
        // If we had to have only a single contact for a specific name, then we can make the id as the firstName + lastName
        self.id = UUID().uuidString + String(Date().timeIntervalSince1970 * 1000)
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.type = type
    }
}
