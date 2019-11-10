//
//  ContactsTableViewController.swift
//  KPPhonebook
//
//  Created by Klodiana Prenga on 10/11/2019.
//  Copyright © 2019 Klodiana Prenga. All rights reserved.
//

import UIKit
import ContactsManager

class ContactsTableViewController: UITableViewController {
    // MARK: - Immutable Properties

    private let contactManager = ContactManager.shared
    private let editContactSegueId = "edit_contact_controller_segue"
    private var selectedContact: Contact?

    // MARK: - Actions

    @IBAction func addContactAction(_ sender: Any) {
        selectedContact = nil
        performSegue(withIdentifier: editContactSegueId, sender: nil)
    }
}

// MARK: - Table view data source

extension ContactsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.allContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact_cell", for: indexPath)

        let contact = contactManager.allContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.type.rawValue

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let contact = contactManager.allContacts[indexPath.row]
            ContactManager.shared.delete(contact)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedContact = contactManager.allContacts[indexPath.row]
        performSegue(withIdentifier: editContactSegueId, sender: nil)
    }
}

// MARK: - Navigation

extension ContactsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditContactViewController {
            controller.contact = selectedContact
            controller.updateCallback = {
                self.tableView.reloadData()
            }
        }
    }
}
