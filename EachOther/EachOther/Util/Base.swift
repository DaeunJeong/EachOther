//
//  Base.swift
//  EachOther
//
//  Created by daeun on 20/03/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import UIKit

enum Color{
    
    case PRIMARY, GRAY
    
    func getColor() -> UIColor {
        switch self {
        case .PRIMARY:
            return UIColor(red: 81/255, green: 216/255, blue: 216/255, alpha: 1)
        case .GRAY:
            return UIColor(red: 188/255, green: 190/255, blue: 190/255, alpha: 1)
        }
    }
    
}
