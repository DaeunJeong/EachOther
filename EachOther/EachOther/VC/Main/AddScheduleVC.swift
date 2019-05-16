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
                case .success:
                    let alert = UIAlertController(title: "성공", message: "일정 등록이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(UIAlertAction) -> Void in _ = self.navigationController?.popToRootViewController(animated: true)}))
                self.present(alert, animated: true, completion: nil)
                case .fail:
                    let alert = UIAlertController(title: "오류", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                case .none: print("NONE")
                }
            }
        }.disposed(by: disposeBag)
    }
}
