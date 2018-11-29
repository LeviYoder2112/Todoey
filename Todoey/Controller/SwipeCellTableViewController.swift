//
//  SwipeCellTableViewController.swift
//  Todoey
//
//  Created by Levi Yoder on 11/29/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import Foundation
import SwipeCellKit

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell: UITableViewCell?
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in

            
            self.updateModel(at: indexPath)
            

            
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.delegate = self
        
        return cell
    }
    
    
    func updateModel(at indexPath: IndexPath){
        
        
    }
}
