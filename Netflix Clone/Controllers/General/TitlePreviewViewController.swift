//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 02.10.2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let webView: WKWebView = WKWebView()
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
}
