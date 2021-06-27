//
//  PlantsViewController.swift
//  PlantitAll
//
//  Created by Radhika Gupta on 23/03/21.
//

import UIKit
import UserNotifications
class PlantsViewController: UIViewController {
    override func viewDidLoad() {
        registerLocal()
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
}
