//
//  HomeModel.swift
//  EachOther
//
//  Created by daeun on 08/04/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxSwift

class HomeModel {
    let familyName = Variable<String>("")
    let parentModels = Variable<[HomeFamilyMemberModel]>([])
    let childModels = Variable<[HomeFamilyMemberModel]>([])
    let image = Variable<UIImage>(UIImage())
}

struct HomeFamilyMemberModel {
    let name: String
    let imageUrl: URL = URL(fileURLWithPath: "")
}
