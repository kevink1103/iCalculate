//
//  Equation.swift
//  iCalculate
//
//  Created by Kevin Kim on 6/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

// The codes here are very dirty
// I should cleanse them later on
class Equation {
    var array: [String] = []
    
    func add(_ element: String) -> Void {
        if element.count == 0 {
            return
        }
        
        // Restrict invalid input when adding
        if let last = array.last {
            if last.isNumber() {
                if element.isNumber() || (element[0] == "." && !last.contains(".")) {
                    array[array.count-1] += element
                    return
                }
                else if element[0] == Op.power.rawValue || element[0] == Op.percent.rawValue || element[0] == Op.pi.rawValue {
                    array.append(element)
                    return
                }
                else if element[0] == Op.root.rawValue {
                    return
                }
                else if element[0] == Op.open.rawValue {
                    return
                }
            }
            else {
                let lastOp = Op(rawValue: last[0])
                let currentOp = Op(rawValue: element[0])
                
                // Match open and close
                if currentOp == .close {
                    let openCount = array.filter { $0 == String(Op.open.rawValue) }.count
                    let closeCount = array.filter { $0 == String(Op.close.rawValue) }.count
                    if openCount <= closeCount {
                        return
                    }
                    if lastOp == .add || lastOp == .subtract || lastOp == .multiply || lastOp == .divide || lastOp == .power || lastOp == .root {
                        return
                    }
                }
                // No duplicate
                if lastOp != .open && lastOp != .close && lastOp == currentOp {
                    return
                }
                // No digit or sciOp allowed after pi and percent
                if (currentOp != .add && currentOp != .subtract && currentOp != .multiply && currentOp != .divide && currentOp != .close) && (lastOp == .pi || lastOp == .percent) {
                    return
                }
                if lastOp == .subtract && currentOp == .add {
                    return
                }
                if lastOp != .close && (currentOp == .percent || currentOp == .power) {
                    return
                }
            }
            array.append(element)
        }
        else {
            // First input
            if element.isNumber() {
                array.append(element)
            }
            else if element[0] != "." {
                let op: Op = Op(rawValue: element[0])!
                if op == .open || op == .root || op == .pi {
                    array.append(element)
                }
            }
        }
    }
    
    func clear() -> Void {
        array.removeAll()
    }
    
    func removeLast() -> Void {
        if let last = array.last {
            if last.isNumber() && last.count-1 > 0 {
                array[array.count-1] = String(last.dropLast())
                return
            }
        }
        array = array.dropLast()
    }
    
    func display() -> String {
        var str: String = ""
        for element in array {
            if element.isNumber() {
                str += element
            }
            else {
                let op: Op = Op(rawValue: element[0])!
                if op == .add || op == .subtract || op == .multiply || op == .divide {
                    str += " \(element) "
                }
                else {
                    str += element
                }
            }
        }
        str = str.dropLastSpace()
        return str
    }
    
    func calculate() -> String {
        let postfix: [String] = postfixEquation()
        let result: String = postfixCalculate(postfix)
        print(postfix)
        
        return result
    }
    
    func export() -> String {
        let eq = display()
        let result = calculate()
        
        if result.count > 0 {
            return "\(eq) = \(result)"
        }
        return result
    }
    
    func postfixEquation() -> [String] {
        
        var postfix: [String] = []
        var stack: [String] = []
        
        // Validate original equation
        if let last = array.last {
            if !last.isNumber() {
                let lastOp: Op = Op(rawValue: last[0])!
                if lastOp != .close && lastOp != .percent && lastOp != .pi {
                    return postfix
                }
            }
        }
        
        // Reorganize
        array.forEach { element in
            if element.isNumber() {
                postfix.append(element)
                
                if let pop = stack.popLast() {
                    if pop[0] == Op.power.rawValue || pop[0] == Op.root.rawValue {
                        postfix.append(pop)
                    }
                    else {
                        stack.append(pop)
                    }
                }
            }
            else {
                let op: Op = Op(rawValue: element[0])!
                if op == .close {
                    // Pop until the open
                    if var pop = stack.popLast() {
                        while pop[0] != Op.open.rawValue {
                            postfix.append(pop)
                            if stack.count > 0 {
                                pop = stack.popLast()!
                            }
                            else {
                                break
                            }
                        }
                        // Pop once more to check root
                        if let pop = stack.popLast() {
                            if pop[0] == Op.power.rawValue || pop[0] == Op.root.rawValue {
                                postfix.append(pop)
                            }
                            else {
                                stack.append(pop)
                            }
                        }
                    }
                }
                else {
                    if op == .add || op == .subtract {
                        if let pop = stack.popLast() {
                            let popOp: Op = Op(rawValue: pop[0])!
                            if popOp == .multiply || popOp == .divide {
                                // Priority
                                postfix.append(pop)
                            }
                            else if popOp == .subtract && op == .add {
                                postfix.append(pop)
                            }
                            else if popOp == op {
                                postfix.append(pop)
                            }
                            else {
                                // Recover
                                stack.append(pop)
                            }
                        }
                    }
                    else if op == .percent {
                        postfix.append("0.01")
                        postfix.append(String(Op.multiply.rawValue))
                    }
                    else if op == .pi {
                        let pi = String(Float.pi)
                        postfix.append(pi)
                        postfix.append(String(Op.multiply.rawValue))
                    }
                    
                    if op != .percent && op != .pi {
                        stack.append(element)
                    }
                }
            }
        }
        if stack.count > 0 {
            for _ in 0..<stack.count {
                if let pop = stack.popLast() {
                    if pop[0] != Op.root.rawValue {
                        postfix.append(pop)
                    }
                }
            }
        }
        return postfix
    }
    
    func postfixCalculate(_ eq: [String]) -> String {
        var stack: [String] = []
        var result: String = ""
        
        // Validate postfix equation
        if eq.contains(String(Op.open.rawValue)) || eq.count <= 1 {
            return ""
        }
        
        eq.forEach { element in
            if element.isNumber() {
                stack.append(element)
            }
            else {
                let op: Op = Op(rawValue: element[0])!
                if op == .add || op == .subtract || op == .multiply || op == .divide {
                    if stack.count >= 2 {
                        let operand1 = stack.popLast()!
                        let operand2 = stack.popLast()!
                        stack.append(stringArithmetic(operand1, operand2, op))
                    }
                }
                else if op == .power {
                    if stack.count >= 2 {
                        let operand2 = stack.popLast()!
                        let operand1 = stack.popLast()!
                        stack.append(stringPower(operand1, operand2))
                    }
                }
                else if op == .root {
                    if stack.count >= 1 {
                        let operand = stack.popLast()!
                        stack.append(stringRoot(operand))
                    }
                }
            }
        }
        
        if stack.count > 0 {
            result = stack.popLast()!
        }
        return result
    }
    
    func stringArithmetic(_ operand1: String, _ operand2: String, _ op: Op) -> String {
        var result: Float = 0.0
        
        switch op {
        case .add:
            result = Float(operand1)! + Float(operand2)!
        case .subtract:
            result = Float(operand2)! - Float(operand1)!
        case .multiply:
            result = Float(operand1)! * Float(operand2)!
        case .divide:
            result = Float(operand2)! / Float(operand1)!
        default:
            result = 0.0
        }
        
        return filterDecimals(String(result))
    }
    
    func stringRoot(_ operand: String) -> String {
        var result: Float = 0.0
        
        result = pow(Float(operand)!, (1/2))
        
        return filterDecimals(String(result))
    }
    
    func stringPower(_ operand1: String, _ operand2: String) -> String {
        var result: Float = 0.0
        
        result = pow(Float(operand1)!, Float(operand2)!)
        
        return filterDecimals(String(result))
    }
    
    func filterDecimals(_ str: String) -> String {
        // Filter out redundant .0
        if !str.isNumber() {
            return ""
        }
        
        var numeric: String = str
        let periodIndex: Int = numeric.search(".")
        let decimals: String = String(numeric[(periodIndex+1)...])
        if Int(decimals) == 0 {
            numeric = String(numeric[0..<periodIndex])
        }
        return numeric
    }
    
}

