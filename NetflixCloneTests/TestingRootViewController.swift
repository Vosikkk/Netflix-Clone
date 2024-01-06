//
//  TestingRootViewController.swift
//  NetflixCloneTests
//
//  Created by Саша Восколович on 07.01.2024.
//

import UIKit


class TestingRootViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            print("TestingRootViewController - View Did Load")
            
            
        }
    
    override func loadView() {
        let label = UILabel()
        label.text = "Running unit tests..."
        label.textAlignment = .center
        label.textColor = .white
        view = label
    }
}
