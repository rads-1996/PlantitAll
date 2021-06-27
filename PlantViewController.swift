//
//  PlantViewController.swift
//  PlantitAll
//
//  Created by Radhika Gupta on 22/03/21.
//

import UIKit
import UserNotifications

class PlantViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UNUserNotificationCenterDelegate, UITextFieldDelegate, MyDataSendingDelegateProtocol {
    
    
    
    @IBOutlet weak var stepper: UIStepper!
    let picker1 = UIPickerView()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timers: UIDatePicker!
    
    @IBOutlet weak var setAlarm: UIButton!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var name: UITextField!
    var collectables : [Collectible] = []
    //var selectDay : [DaysChosen] = []
    var pickerController = UIImagePickerController()
    var doneSaving: (() -> ())?
    var indexEdit: Int?
    var hour: Int?
    var minute: Int?
    var chosenOne = Array<String>()
    var weekday: Int?
    var arr = Array<String>()
    var this: Int?
    var tempArray = [Int]()
    var temp = String()
    var chosenIndex = Array<Int>()
    var dayChosen = String()
    
    var savedNotificationDate: Date? {
            get {
                return UserDefaults.standard.object(forKey: "notificationDate") as? Date
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "notificationDate")
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self
      // createPickerView()
      // createToolbar()
     //   if let savedNotificationDate = savedNotificationDate {
            if let i = indexEdit{
                let timings = collectables[i]
                timers.date = timings.time!
            }
                   // timers.date = savedNotificationDate
            //    }
        
        editIndex()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(simpleAddNotification))
    }
    func createPickerView()
        {
            picker1.delegate = self
            picker1.delegate?.pickerView?(picker1, didSelectRow: 0, inComponent: 0)
            textField1.inputView = picker1
            picker1.backgroundColor = UIColor.yellow
            
        }
    func createToolbar()
        {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            toolbar.tintColor = UIColor.white
            toolbar.backgroundColor = UIColor.red
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PlantViewController.closePickerView))
            toolbar.setItems([doneButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            textField1.inputAccessoryView = toolbar
        }
    
    @objc func closePickerView()
        {
            view.endEditing(true)
        }
    
    func editIndex() {
        if let index = indexEdit{
         let plant = collectables[index]
             name.text = plant.title
             imageView.image = UIImage(data: plant.image!)
             textField1.text =  plant.day
           // timers.date = plant.time
           
         }
    }
    
    @objc func simpleAddNotification() {
        // Initialize User Notification Center Object
        
        let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
            content.title = "The plant is thirsty"
            content.body = "It needs water to grow and survive"
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default

        for z in chosenIndex{
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.weekday = z
            print(dateComponents.weekday!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
            center.add(request)
        }
        savedNotificationDate = timers.date
        // Save the changes made by user
        
        if let index = indexEdit {
            update(at: index, title: name.text, day: textField1.text, image: imageView.image, time: savedNotificationDate)
        }
        else {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
             
            let collectable = Collectible(context: context)
            
            collectable.title = name.text
            collectable.image = imageView.image?.jpegData(compressionQuality: 1.0)
            collectable.day  = textField1.text
            collectable.time = timers.date
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        navigationController?.popViewController(animated: true)
        }
        // To update any changes made by user to existing item
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
        }
    
    func sendDataToPlantViewController( myIndex: Array<Int>) {
        
        
        chosenIndex = myIndex
       
        if chosenIndex.count > 1 {
        for a in chosenIndex {
            switch a {
            
            case 0 :
                dayChosen = "Sun"
                
            case 1 :
                dayChosen = "Mon"
            
            case 2 :
                dayChosen = "Tue"
                
            case 3 :
                dayChosen = "Wed"
                
            case 4 :
                dayChosen = "Thur"
                
            case 5 :
                dayChosen = "Fri"
                
            case 6 :
                dayChosen = "Sat"

            default:
                dayChosen = "Nothing selected"
            }
            chosenOne.append(dayChosen)
        }
            self.textField1.text = chosenOne.joined(separator: ",")
        }
        
        else if chosenIndex.count == 1
        {
            switch chosenIndex.first {
                
                case 0 :
                    temp = "Sunday"
                    break
                    
                case 1 :
                    temp = "Monday"
                
                case 2 :
                    temp = "Tuesday"
                    
                case 3 :
                    temp = "Wednesday"
                    
                case 4 :
                    temp = "Thursday"
                    
                case 5 :
                    temp = "Friday"
                    
                case 6 :
                    temp = "Saturday"
                    
                default:
                    temp = "Nothing chosen"
                }
            self.textField1.text = temp
       }
        
        else if chosenIndex.count == 7
        {
            self.textField1.text = "Every Day"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sendDay" {
                let secondVC: DayViewController = segue.destination as! DayViewController
               // secondVC.indexEdit = self.indexEdit
                passDays()
                secondVC.temp = self.tempArray
                secondVC.delegate = self
            }
        
        }
    
  @objc  func passDays() {
        
        print(textField1.text!)
       // arr = (textField1.text!.components(separatedBy: ","))
        let arr = textField1.text!.split(separator: ",")
        print(arr)
        
        if arr.count > 1 {
        for i in arr {
            switch i {
            
            case "Sun":
                this = 0
                break
                
            case "Mon":
                this = 1
                
            case "Tue":
                this = 2
                
            case "Wed":
                this = 3
                
            case "Thur":
                this = 4
                
            case "Fri":
                this = 5
                
            case "Sat":
                this = 6
                
            default:
                this = 8
            }
            tempArray.append(this!)
          }
        }
        
        else if arr.count == 1 {
            for i in arr {
                switch i {
                
                case "Sunday":
                    this = 0
                    break
                    
                case "Monday":
                    this = 1
                    
                case "Tuesday":
                    this = 2
                    
                case "Wednesday":
                    this = 3
                    
                case "Thursday":
                    this = 4
                    
                case "Friday":
                    this = 5
                    
                case "Saturday":
                    this = 6
                    
                default:
                    this = 8
                }
            }
            tempArray.append(this!)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func timer(_ sender: UIDatePicker) {
        
        //let datePicker = UIDatePicker()
        timers.datePickerMode = .time
        let dates = timers.date
        let component = Calendar.current.dateComponents([.hour, .minute], from: dates)
        hour = component.hour!
        minute = component.minute!
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    
    
    
    @IBAction func organize(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
    present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: Any) {
        pickerController.sourceType = .camera
    present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let cancel = presentingViewController is UINavigationController
            
            if cancel {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("This is not inside a navigation controller.")
            }
        }
    
    func update(at index: Int, title: String?, day: String?, image: UIImage? = nil, time: Date?){
        //if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
             
           // let collectable = Collectible(context: context)
            collectables[index].title = title
            collectables[index].day = day
            collectables[index].time = time
            collectables[index].image = image?.jpegData(compressionQuality: 1.0)
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        navigationController?.popViewController(animated: true)
       
    }
    
}

