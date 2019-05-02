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
        
        albumViewModel.albumModels.asDriver().drive(albumTableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) {[weak self] _, album, cell in
            guard let strongSelf = self else {return}
            
            album.title.asObservable()
                .bind(to: cell.titleLabel.rx.text)
                .disposed(by: strongSelf.disposeBag)
            
            album.date.asObservable()
                .bind(to: cell.dateLabel.rx.text)
                .disposed(by: strongSelf.disposeBag)
            
            album.place.asObservable()
                .bind(to: cell.placeLabel.rx.text)
                .disposed(by: strongSelf.disposeBag)
            
            album.data.asObservable().subscribe { data in
                cell.albumImage.image = UIImage(data: data.element ?? Data())
                }.disposed(by: strongSelf.disposeBag)
        }.disposed(by: disposeBag)
    }
}

class AlbumCell: UITableViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
}
