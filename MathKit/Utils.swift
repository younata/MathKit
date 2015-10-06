import Foundation

public func cont<T: Equatable>(arr: [T], obj: T) -> Bool {
    for itm in arr {
        if itm == obj {
            return true
        }
    }
    return false
}