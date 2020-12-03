//
//  Pagination.swift
//  Medtrail_Assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation

struct Pagination {
    var is_refreshing : Bool = true
    var item_in_page : Int    = 0
    var current_page : Int    = 0
    var total_page_count : Int = 1 {
        didSet {
             total_page_count  = (total_page_count == 0) ? 1 : total_page_count
        }
    }
    func has_more() -> Bool {
        if self.total_page_count > self.current_page{
            return true
        }else{
            return false
        }
    }
    mutating func resetPagination(){
        self.is_refreshing = true
        self.item_in_page = 0
        self.current_page = 0
        self.total_page_count = 1
    }
}
