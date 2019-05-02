//
//  AlbumModel.swift
//  EachOther
//
//  Created by daeun on 29/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AlbumModel {
    let data = Variable<Data>(Data())
    let date = Variable<String>("")
    let title = Variable<String>("")
    let place = Variable<String>("")
}
