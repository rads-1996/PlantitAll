//
//  PlantTableViewController.swift
//  PlantitAll
//
//  Created by Radhika Gupta on 22/03/21.
//

import UIKit

class PlantTableViewController: UITableViewController {
    
    var collectables : [Collectible] = []
    var indexEdit: Int?
    override func viewWillAppear(_ animated: Bool) {
        getCollectibles()
    }
    func getCollectibles() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            if let collectables = try? context.fetch(Collectible.fetchRequest()){
            
                if let theCollectables = collectables as? [Collectible]{
                    
                    self.collectables = theCollectables
                    tableView.reloadData()
                }
                }
            }
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectables.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let  collectable = collectables[indexPath.row]
        
        cell.textLabel?.text = collectable.title
        if let data = collectable.image {
        cell.imageView?.image =  UIImage(data: data)        }
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let deletion = collectables[indexPath.row]
                context.delete(deletion)
               (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                getCollectibles()
}
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier == "toMain" {
                 let popup = segue.destination as! PlantViewController
                popup.indexEdit = self.indexEdit
                popup.collectables = collectables
                popup.doneSaving = { [weak self] in
                     self?.tableView.reloadData()
                 }
                indexEdit = nil
             }
         }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit"){
            (contextualAction, view, actionPerformed: (Bool)->()) in
            self.indexEdit = indexPath.row
            self.performSegue(withIdentifier: "toMain", sender: nil)
            actionPerformed(true)
        }
        edit.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return UISwipeActionsConfiguration(actions: [edit])
    }
   
}
