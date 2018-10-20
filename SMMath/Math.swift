//
//  SMMath.swift
//  SMMath
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

import SMStack

extension Double: Calculable {
	public var calculableValue: Double { return self }
}

public class SMMath {
	
	public static func calculate<T: Calculable>(formula: String, data: [String: T]) -> Double {
		var expression = Expression(formula: formula, data: data)
		var index = 0
		var modifyInstructions = [ModifyInstruction]()
		
		while index < (expression.count - 1) {
			let subarray = Array(expression[index ..< min(index + 4, expression.count)])
			if subarray.count == 4,
				case ExpressionElement.operator(let op) = subarray[0], op != .closeBracket,
				case ExpressionElement.operator(let op2) = subarray[1], op2 == .minus,
				case ExpressionElement.number(_) = subarray[2],
				case ExpressionElement.operator(let op3) = subarray[3] {
				if op == .openBracket && op3 == .closeBracket {
					modifyInstructions.append(.negativeNumber(index + 2, index, index + 3))
				} else {
					modifyInstructions.append(.negativeNumber(index + 2, index + 1, index + 2))
				}
			}
			
			if subarray.count >= 2 {
				if case ExpressionElement.number(_) = subarray[0],
					case ExpressionElement.operator(let op) = subarray[1], op == .openBracket {
					modifyInstructions.append(.insertMultiply(index + 1))
				} else if case ExpressionElement.number(_) = subarray[1],
					case ExpressionElement.operator(let op) = subarray[0], op == .closeBracket {
					modifyInstructions.append(.insertMultiply(index + 1))
				} else if case ExpressionElement.operator(let op) = subarray[0], op == .closeBracket,
					case ExpressionElement.operator(let op2) = subarray[1], op2 == .openBracket {
					modifyInstructions.append(.insertMultiply(index + 1))
				}
			}
			
			index += 1
		}
		
		//		print("BEFORE:", elements.map({ $0.description }).joined(separator: " "))
		for instruction in modifyInstructions.reversed() {
			switch instruction {
			case .negativeNumber(let index, let start, let end):
				if case ExpressionElement.number(let number) = expression[index] {
					expression.replaceSubrange(start ... end, with: [ExpressionElement.number(-number)])
				}
			case .insertMultiply(let index):
				expression.insert(.operator(.multiply), at: index)
			}
		}
		//		print("AFTER: ", elements.map({ $0.description }).joined(separator: " "))
		var values = SMStack<Double>()
		var operators = SMStack<MathOperator>()
		for element in expression {
			switch element {
			case .number(let value):
				values.push(value)
			case .operator(.openBracket):
				operators.push(.openBracket)
				continue
			case .operator(.closeBracket):
				while operators.peak()!.value != .openBracket {
					values.push(operators.pop()!.evaluate(b: values.pop()!, a: values.pop()!))
				}
				operators.pop()
			case .operator(let op):
				while (!operators.isEmpty && op.priority <= operators.peak()!.value.priority) {
					if let popedOperator = operators.pop(), let b = values.pop(), let a = values.pop() {
						values.push(popedOperator.evaluate(b: b, a: a))
					} else {
						print()
					}
				}
				operators.push(op)
			case .function(let `func`):
				values.push(`func`.calcualte(data: data))
			case .unknown:
				values.push(0)
			}
		}
		
		return values.isEmpty ? 0 : values.pop()!
	}
	
	public static func calculate(formula: String) -> Double {
		return calculate(formula: formula, data: [String : Double]())
	}
	
}
