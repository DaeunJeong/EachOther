//
//  MyPageVC.swift
//  EachOther
//
//  Created by daeun on 16/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyPageVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var completeButton: RoundButton!
    @IBOutlet weak var logoutButton: RoundButton!
    
    let disposeBag = DisposeBag()
    var myPageViewModel: MyPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageViewModel = MyPageViewModel()
        
        let input = MyPageViewModel.Input(inputName: nameTextField.rx.text.orEmpty.asDriver(), inputBirthday: birthdayDatePicker.rx.date.asDriver(), clickComplete: completeButton.rx.tap.asSignal(), clickLogout: logoutButton.rx.tap.asSignal())
        
        let output = myPageViewModel.transform(input: input)
        
        output.name.drive(nameTextField.rx.text).disposed(by: disposeBag)
        
        output.birthday.drive(birthdayDatePicker.rx.date).disposed(by: disposeBag)
        
        output.doLogout.asObservable().subscribe { [weak self] bool in
            guard let strongSelf = self else {return}
            if let bool = bool.element {
                if bool {
                    strongSelf.performSegue(withIdentifier: "goStart", sender: nil)
                }
            }
        }.disposed(by: disposeBag)
        
        output.result.asObservable().subscribe { [weak self] result in
            guard let strongSelf = self else {return}
            if let result = result.element {
                if result {
                    let alert = UIAlertController(title: "성공", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "오류", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }.disposed(by: disposeBag)
    }
}
