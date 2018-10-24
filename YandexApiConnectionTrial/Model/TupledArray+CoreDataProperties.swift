//
//  TupledArray+CoreDataProperties.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 10/19/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//
//

import Foundation
import CoreData


extension TupledArray {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TupledArray> {
        return NSFetchRequest<TupledArray>(entityName: "TupledArray")
    }

    @NSManaged public var enteredTextLanguage: String?
    @NSManaged public var enteredText: String?
    @NSManaged public var outputTextLanguage: String?
    @NSManaged public var outputText: String?

}
