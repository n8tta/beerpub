//
//  Beer.swift
//  HW_32_Pub_Realm
//
//  Created by Natallia Valadzko on 10.04.21.
//

import Foundation
import RealmSwift

class Pub: Object {
    @objc dynamic var date = ""
    let beers = List<Beer>()
    @objc dynamic var fullProceeds = 0.0
}

class Beer: Object {
    @objc dynamic var date = ""
    @objc dynamic var brand = ""
    @objc dynamic var price = 0.0
    @objc dynamic var available = 0
    @objc dynamic var currentStock = 0
    @objc dynamic var morningStock = 0
    @objc dynamic var proceeds = 0.0
}

