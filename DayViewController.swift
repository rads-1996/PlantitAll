//
//  DayViewController.swift
//  PlantitAll
//
//  Created by Radhika Gupta on 03/05/21.
//

import UIKit

import Foundation

struct Item : Encodable, Decodable {
    var name : String = ""
    var done : Bool = false
}

class CustomCell : UITableViewCell{
    
    
    @IBOutlet weak var myText: UILabel!
    
}

protocol MyDataSendingDelegateProtocol {
    func sendDataToPlantViewController( myIndex: Array<Int>)
}

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: MyDataSendingDelegateProtocol? = nil
  
    var itemsArr : [Item] = [Item(name: "Sunday", done: false), Item(name: "Monday", done: false), Item(name: "Tuesday", done: false), Item(name: "Wednesday", done: false), Item(name: "Thursday", done: false), Item(name: "Friday", done: false), Item(name: "Saturday", done: false)]
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Days.plist")
    var text = UILabel()
    var img : Int?
    var chosen = [0, 1, 2, 3, 4, 5, 6]
    var indexs = [Int]()
    var temp  = [Int]()
    var someTrue = true
    var dayChosen = String()
    var days = Array<String>()
    var indexEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        loadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:CustomCell = self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        let item = itemsArr[indexPath.row]
       // cell.accessoryType = item.done ? .checkmark : .none
        if item.done{
            cell.accessoryType = .checkmark
            
        }
        else {
            cell.accessoryType = .none
        }
        cell.myText?.text = item.name
        //print(cell)
        print(item)
        return cell
        
       /* let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
                let item = itemsArray[indexPath.row]
                cell.accessoryType = item.done ? .checkmark : .none
                cell.textLabel?.text = item.name
        return cell*/
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemsArr.count
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .none{
               
              /*   img = indexPath.row
                 img! += 1
                if indexs.contains(img!) {
                }
                else{
                 indexs.append(img!)
                }
               //  print(indexs) */
            }
            else if cell.accessoryType == .checkmark {
                
            //    img = indexPath.row
            //    img! += 1
                
             /*   if indexs .isEmpty {
                    temp.append(img!)
                }
                else if indexs.contains(img!){
                    indexs.remove(at: img!)
                }
                print(indexs)*/
               // print(temp)
                
            }
        }
        itemsArr[indexPath.row].done = !itemsArr[indexPath.row].done

        
    /* when state is changed - save it to plist file */
        
               saveDate()

}
    
    func saveDate() {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(itemsArr)
                try data.write(to: dataFilePath!)
            } catch {
                print(error.localizedDescription)
            }
            self.tableView.reloadData()
        }


        /* load data from plist file */
        func loadData() {

            for i in temp {
                itemsArr[i].done = true
            }
            
           /* if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                do {
                    itemsArr = try decoder.decode([Item].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }*/
        }
    
    
    
    @IBAction func chooseDays(_ sender: Any) {
      
        for i in chosen {
            
            if itemsArr[i].done == true {
                indexs.append(i)
            }
         /*   else if itemsArr[i].done == false{
                indexs.remove(at: i)
            }*/
        }
        
        print("the index is")
        print(indexs)
       // let dataToBeSent  = self.days
        let indexToBeSent = self.indexs
        self.delegate?.sendDataToPlantViewController( myIndex: indexToBeSent)
        dismiss(animated: true, completion: nil)
      navigationController?.popViewController(animated: true)
      
    }
}
