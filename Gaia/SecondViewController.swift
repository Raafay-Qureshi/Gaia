//
//  SecondViewController.swift
//  Gaia
//
//  Created by Shubhaangan Manoranjan on 2022-07-30.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var helloTitle: UILabel!
    
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getLoginInfo(un: String) {
        username = un
        
        DispatchQueue.main.async {
            self.helloTitle.text = "Hello \(self.username)"
        }
    }
    
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "scanSegue", sender: self)
    }
    @IBAction func pointsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "pointViewSegue", sender: self)
    }
    
}
