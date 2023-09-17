//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/04.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    @NSManaged var body: String?
    @NSManaged var date: Date
    @NSManaged var title: String
    @NSManaged var weatherId: String?
    @NSManaged var weatherIconId: String?
}

extension DiaryEntity: Identifiable {
    @NSManaged var id: UUID
}

extension DiaryEntity: EntityProtocol {
    var entityName: String {
        return "DiaryEntity"
    }
}
