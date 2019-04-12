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
    @IBOutlet weak var nameTextField: UITextField!
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
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: self.connectViewModel.name)
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
        
        connectViewModel.connectEnabled
            .bind(to: connectButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        connectViewModel.result.subscribe{
            if $0.error == nil {
                self.performSegue(withIdentifier: "goMain", sender: nil)
            } else {
                let alert = UIAlertController(title: "오류", message: "모두 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
