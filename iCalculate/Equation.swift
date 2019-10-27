//
//  Equation.swift
//  iCalculate
//
//  Created by Kevin Kim on 6/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

class Equation {
    var string: String = ""
    var array: [String] = []
    
    func updateString(_ element: String) -> Void {
        string = element
        updateArray()
    }
    
    func updateArray() -> Void {
        array = []
        for char in string {
            add(String(char))
        }
    }
    
    func add(_ element: String) -> Void {
        if element.count == 0 {
            return
        }
        
        // append number if last element is a number
        if let last = array.last {
            if last.isNumber() {
                if element.isNumber() || (element[0] == "." && !last.contains(".")) {
                    array[array.count-1] += element
                    return
                }
            }
        }
        array.append(element)
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
    
    func calculate() -> String {
        let postfix: [String] = postfixEquation()
        let result: String = postfixCalculate(postfix)
        print("POSTFIX:", postfix)
        
        return result
    }
    
    func postfixEquation() -> [String] {
        
        var postfix: [String] = []
        var stack: [String] = []
        
        print("ARRAY:", array)
        
        // Validate original array
        if let last = array.last {
            if !last.isNumber() {
                let lastOp: Op = Op(rawValue: last[0])!
                if lastOp != .close && lastOp != .percent && lastOp != .pi {
                    return []
                }
            }
        }
        
        // Reorganize
        for (index, element) in array.enumerated() {
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
                        if index > 0 {
                            let last: String = array[index-1]
                            if last.isNumber() {
                                postfix.append(String(Op.multiply.rawValue))
                            }
                        }
                    }
                    else if op == .power {
                        if postfix.last == nil {
                            return []
                        }
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
        
        if stack.count == 1 {
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
    
    func export() -> String {
        let eq = string
        let result = calculate()
        
        if result.count > 0 {
            return "\(eq) = \(result)"
        }
        return result
    }
    
}

