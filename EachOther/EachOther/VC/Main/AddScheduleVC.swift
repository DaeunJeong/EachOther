//
//  AddScheduleVC.swift
//  EachOther
//
//  Created by daeun on 15/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AddScheduleVC: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var commentTextField: UITextField!
    
    var addScheduleViewModel: AddScheduleViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScheduleViewModel = AddScheduleViewModel()
        let completeButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = completeButton
        
        let input = AddScheduleViewModel.Input(clickComplete: completeButton.rx.tap.asSignal(), comment: commentTextField.rx.text.orEmpty.asDriver(), date: datePicker.rx.date.asDriver())
        
        let output = addScheduleViewModel.transform(input: input)
        
        output.result.asObservable().subscribe { result in
            if let result = result.element {
                switch result {
                case .success: print("SUCCESS")
                case .fail: print("FAIL")
                case .none: print("NONE")
                }
            }
        }.disposed(by: disposeBag)
    }
}
