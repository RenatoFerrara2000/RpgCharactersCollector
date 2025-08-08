//
//  Award.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 16/05/25.
//
import Foundation
import SwiftData
// swiftlint:disable all
/**
## Overview
 This model is used  to rappresent Awards that the user can gain by using the app.
 Mainly they are given when the user creat N number of Characters or Traits.
 
 ## Parameters
 - `id`: Unique identifier for the Award
 - `name`: Name of the Award
 - `description`: Small description of the Award
 - `color`:  Color assigned to the award image once completed
 - `criterion`: Needed to define if its Traits related or Characters Related
 - `value`:  Value to pass for an Award to be given. Example: a value of 50 related to a character criterion means having 50 or more characters
 - `image`: System Image used to rappresent the award
 
 - `allAwards`: Array of all the awards
 - `example`:  single example of an award


 */
 // swiftlint:enable all

struct Award: Decodable, Identifiable {
    var id: String { name }
    var name: String
    var description: String
    var color: String    
    var criterion: String
    var value: Int
    var image: String
    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    static let example = allAwards[0]
}
