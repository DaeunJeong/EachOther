//
//  CertifyVC.swift
//  EachOther
//
//  Created by daeun on 19/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CertifyVC: UIViewController {

    var certifyViewModel: CertifyViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeCopyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certifyViewModel = CertifyViewModel()
        
        certifyViewModel.code
            .bind(to: codeLabel.rx.text)
            .disposed(by: disposeBag)
        
        codeCopyButton.rx.tap
            .bind(to: certifyViewModel.copyCode)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
