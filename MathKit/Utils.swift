//
//  Utils.swift
//  MathKit
//
//  Created by Rachel Brindle on 10/23/14.
//  Copyright (c) 2014 Rachel Brindle. All rights reserved.
//

import Foundation

public func cont<T: Equatable>(arr: [T], obj: T) -> Bool {
    for itm in arr {
        if itm == obj {
            return true
        }
    }
    return false
}