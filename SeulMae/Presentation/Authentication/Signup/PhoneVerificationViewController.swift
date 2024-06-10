//
//  PhoneVerificationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

final class PhoneVerificationViewController: UIViewController {
    
    private var currentStepGuideLabel: UILabel!
    private var phoneNumberFieldGuideLabel: UILabel!
    private var phoneNumberTextField: UITextField!
    private var authCodeFieldGuideLabel: UILabel!
    private var authCodeTextField: UITextField!
    private var secondAuthCodeFieldGuideLabel: UILabel!
    private var sendAuthCodeButton: UIButton!
    private var nextStepButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
