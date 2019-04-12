//
//  File.swift
//  EachOther
//
//  Created by daeun on 03/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ConnectModel {
    let code = Variable<String>("")
    let name = Variable<String>("")
    let role = Variable<String>("PARENT")
    let birthday = Variable<Date>(Date())
}
