//
//  ViewController.swift
//  Gaia
//
//  Created by Shubhaangan Manoranjan on 2022-07-30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let svc = segue.destination as? SecondViewController
    }
}

