//
//  AlbumVC.swift
//  EachOther
//
//  Created by daeun on 29/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AlbumVC: UIViewController {
    @IBOutlet weak var albumTableView: UITableView!
    
    var albumViewModel: AlbumViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumViewModel = AlbumViewModel()
        
        albumViewModel.albumModels?.asDriver().drive(albumTableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) {_, album, cell in
            cell.titleLabel.text = album.title
            cell.dateLabel.text = album.date
            cell.placeLabel.text = album.place
        }.disposed(by: disposeBag)
    }
}

class AlbumCell: UITableViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
}
