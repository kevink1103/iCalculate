//
//  StringExtension.swift
//  iCalculate
//
//  Created by Kevin Kim on 5/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character {
      return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(endIndex, offsetBy: -1)
      return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[startIndex ..< end]
    }
    
    func isNumber() -> Bool {
        let firstChar = self[0]
        if firstChar == "-" && self.count >= 2 {
            return String(self[1]).isNumber()
        }
        return firstChar.isNumber
    }
    
    func isEmpty() -> Bool {
        return self.count == 0
    }
    
    func search(_ char: Character) -> Int {
        if let index = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: index)
        }
        return 0
    }
    
    func dropLastSpace() -> String {
        if self.count-1 > 0 && self[self.count-1] == " " {
            return String(self.dropLast())
        }
        return self
    }
}

extension Substring {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  subscript (bounds: CountableRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ..< end]
  }
  subscript (bounds: CountableClosedRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ... end]
  }
  subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(endIndex, offsetBy: -1)
    return self[start ... end]
  }
  subscript (bounds: PartialRangeThrough<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ... end]
  }
  subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ..< end]
  }
}

