//
//  ViewControllerExt.swift
//  ECContactsTable
//
//  Created by Ryerson Student on 2018-07-03.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("tableView: didSelectRowAt called" )
        
        let contactData = contactList[indexPath.section][indexPath.row]
        let displayAlert = DisplayAlert()
        displayAlert.showAlertContact(title: "Contact tapped", message: "You tapped "+contactData.name, viewController: self)
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section != proposedDestinationIndexPath.section ? sourceIndexPath : proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print ("tableView: moveRowAt called" )
        
        let contactData = contactList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        contactList[destinationIndexPath.section].insert(contactData, at: destinationIndexPath.row)
        print( "\(contactData.name) \(sourceIndexPath.section):\(sourceIndexPath.row) -> \(destinationIndexPath.section):\(destinationIndexPath.row)" )
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print ("tableView: editActionsForRowAt called", isEditing )
        
        if isEditing {
            let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
            let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle) { [weak self](action, indexPath) in
                self?.contactList[indexPath.section].remove(at: indexPath.row)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.tableView.endUpdates()
            }
            deleteAction.backgroundColor = .red
            
            if indexPath.section == 0{
                let backTitle = NSLocalizedString("Back To", comment: "BackTo action")
                let backAction = UITableViewRowAction(style: .normal, title: backTitle) { [weak self](action, indexPath) in
                    let contactData    = self?.contactList[indexPath.section].remove(at: indexPath.row)
                    let contactDataIdx = contactData!.startingLettertoIdx()+1
                    self?.contactList[contactDataIdx].insert(contactData!, at: 0)
                    
                    let targetIndexPath = IndexPath(row: 0, section: contactDataIdx)
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.tableView.insertRows(at: [targetIndexPath], with: .automatic)
                    self?.tableView.endUpdates()
                }
                backAction.backgroundColor = .green
                return [deleteAction, backAction]
            }
            else{
                let favoriteTitle = NSLocalizedString("Favorite", comment: "Favorite action")
                let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteTitle) { [weak self](action, indexPath) in
                    let contactData = self?.contactList[indexPath.section].remove(at: indexPath.row)
                    self?.contactList[0].insert(contactData!, at: 0)
                    
                    let targetIndexPath = IndexPath(row: 0, section: 0)
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.tableView.insertRows(at: [targetIndexPath], with: .automatic)
                    self?.tableView.endUpdates()
                }
                favoriteAction.backgroundColor = .green

                return [deleteAction, favoriteAction]
            }
        }
        else{
            return []
        }
    }
    
/*
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print ("tableView: trailingSwipeActionsConfigurationForRowAt called", isEditing )

        if isEditing{
            let deleteHandler: UIContextualActionHandler = {
                [weak self] action, view, callback in
                
                self?.contactList[indexPath.section].remove(at: indexPath.row)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.tableView.endUpdates()
                
                callback(true)
            }
            let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
            let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: deleteTitle, handler:deleteHandler )
            deleteAction.backgroundColor = .red
            
            let config:UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
            return config
        }
        else{
            let config:UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [])
            return config
        }
    }
 */
}


extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return letterIdx.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Favorites" : ( contactList[section].count > 0 ? letterIdx[section] : nil )
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letterIdx
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        let contactData = contactList[indexPath.section][indexPath.row]
        contactCell.nameLabel.attributedText = contactData.attributedText(ofSize: contactCell.nameLabel.font.pointSize)
        contactData.fetchImageIfNeeded()
        contactCell.contactImage.image = contactData.contactImage
        
        return contactCell
    }
}

extension ViewController: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print( "UITableViewDataSourcePrefetching::tableView called" )
        for indexPath in indexPaths {
            let contactData = contactList[indexPath.section][indexPath.row]
            contactData.fetchImageIfNeeded()
        }
    }
}
