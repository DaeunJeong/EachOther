//
//  ChatModel.swift
//  EachOther
//
//  Created by daeun on 09/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatModel: Mappable {

    public var messages: Dictionary<String,Message> = [:]
    
    required init?(map: Map) {    }
    
    func mapping(map: Map) {
        messages <- map["message"]
    }
    
    public class Message: Mappable {
        
        public var message: String?
        public var name: String?
        public var timeStamp: Int?
        
        public required init?(map: Map) {        }
        
        public func mapping(map: Map) {
            message <- map["message"]
            name <- map["name"]
            timeStamp <- map["timeStamp"]
        }
    }
}
