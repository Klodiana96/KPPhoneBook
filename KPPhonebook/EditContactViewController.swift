//
//  EditContactViewController.swift
//  KPPhonebook
//
//  Created by Klodiana Prenga on 10/11/2019.
//  Copyright © 2019 Klodiana Prenga. All rights reserved.
//

import Foundation
import UIKit
import ContactsManager

class EditContactViewController: UIViewController {
    // MARK: - UI Properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    // We can improve the UX by creating a UIPicker as an input source for this textfield instead of adding manually the text
    @IBOutlet weak var typeTextField: UITextField!

    // MARK: - Object Properties
    var contact: Contact?
    /// We created this callback to notify the presenter controller that the updating/creation finished so the presenter can reload its UI
    var updateCallback: (() -> Void)?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Setups
    private func setupViews() {
        guard let contact = contact else {
            return
        }

        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        phoneTextField.text = contact.phoneNumber
        typeTextField.text = contact.type.rawValue
    }

    // MARK: - Actions

    @IBAction func saveButtonAction(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phone = phoneTextField.text,
            let typeString = typeTextField.text,
            let type = Type(rawValue: typeString) else {
                print("Please fill correctly all the empty fields!")
                return
        }

        // If the user has passed a contact in this class, it means that he wants to update the contact
        if var contact = contact {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.phoneNumber = phone
            contact.type = type
            ContactManager.shared.update(contact)
        } else {
            // If no contact was passed during the initialization, means that the user wants to create a new contact
            let contact = Contact(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phone,
                type: type
            )
            ContactManager.shared.create(contact)
        }

        dismiss(animated: true, completion: nil)
        updateCallback?()
    }
}
