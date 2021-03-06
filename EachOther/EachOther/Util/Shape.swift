//
//  Shape.swift
//  EachOther
//
//  Created by daeun on 20/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.cornerRadius = frame.height / 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
    }
}

class DynamicTableView: UITableView {
    var height: CGFloat = 0
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: height)
    }
}
