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
        self.popUpView.backgroundColor = .red
        self.popUpView.preparePopUp(fullView: UIView(), title: "Question", font: nil, backgroundColor: nil, textColor: nil, shadowColor: nil, borderWidth: nil, borderColor: nil)
        self.popUpView.popFrom(direction: .top, width: nil, height: nil)
        // Do any additional setup after loading the view.
    }


}

