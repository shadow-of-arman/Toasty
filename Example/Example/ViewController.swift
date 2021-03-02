//
//  ViewController.swift
//  Example
//
//  Created by Arman Zoghi on 3/2/21.
//

import UIKit
import HoveringPopUp

class ViewController: UIViewController {

    let popUpView = HoveringPopUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.popUpView)
        self.popUpView.backgroundColor = .red
        self.popUpView.preparePopUp(fullView: UIView(), title: "Question", width: nil, height: nil, font: nil, backgroundColor: nil, textColor: nil, shadowColor: nil, borderWidth: nil, borderColor: nil)
        // Do any additional setup after loading the view.
    }


}

