//
//  ListItem.swift
//  project1
//
//  Created by Eugene Posikyra on 19.06.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation
import RealmSwift


class ListItem: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var text = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var content = ""
    @objc dynamic var link = ""
    
    override static func primaryKey() -> String? {
        return "id"
}
}
