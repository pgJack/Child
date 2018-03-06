//
//  Array+Extension.swift
//  Child
//
//  Created by Noah on 2018/3/2.
//  Copyright © 2018年 NH. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
