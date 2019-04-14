//
//  HomeVC.swift
//  EachOther
//
//  Created by daeun on 08/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    @IBOutlet weak var parentTableView: UITableView!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    
    var homeViewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewModel = HomeViewModel()
        
        homeViewModel.parentModels
            .drive(parentTableView.rx.items(cellIdentifier: "parentCell")) { _, repository, cell in
                let parentCell = cell as? ParentCell
                parentCell?.parentName.text = repository.name
//                cell.imageView?.image = UIImage(contentsOfFile: repository.imageUrl)
            }
            .disposed(by: disposeBag)
        
        homeViewModel.childModels
            .drive(childTableView.rx.items(cellIdentifier: "childCell")) { _, repository, cell in
                let childCell = cell as? ChildCell
                childCell?.childName.text = repository.name
            }
            .disposed(by: disposeBag)
    }
}

class ParentCell: UITableViewCell {
    @IBOutlet weak var parentImage: UIImageView!
    @IBOutlet weak var parentName: UILabel!
}

class ChildCell: UITableViewCell {
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var childName: UILabel!
}
