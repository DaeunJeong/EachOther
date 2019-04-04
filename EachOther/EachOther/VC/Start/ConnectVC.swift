//
//  ConnectVC.swift
//  EachOther
//
//  Created by daeun on 19/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import DLRadioButton
import RxCocoa
import RxSwift

class ConnectVC: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var fatherButton: DLRadioButton!
    @IBOutlet weak var motherButton: DLRadioButton!
    @IBOutlet weak var childButton: DLRadioButton!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var connectButton: RoundButton!
    
    var connectViewModel: ConnectViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectViewModel = ConnectViewModel()
        
        codeTextField.rx.text
            .orEmpty
            .bind(to: self.connectViewModel.code)
            .disposed(by: disposeBag)
        
        fatherButton.rx.tap
            .bind(to: self.connectViewModel.father)
            .disposed(by: disposeBag)
        
        motherButton.rx.tap
            .bind(to: self.connectViewModel.mother)
            .disposed(by: disposeBag)
        
        childButton.rx.tap
            .bind(to: self.connectViewModel.child)
            .disposed(by: disposeBag)
        
        connectButton.rx.tap
            .bind(to: self.connectViewModel.connect)
            .disposed(by: disposeBag)
        
        birthdayDatePicker.rx.date
            .bind(to: self.connectViewModel.birthday)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
