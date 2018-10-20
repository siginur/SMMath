//
//  MathOperatorEnum.swift
//  SMMath
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

internal enum MathOperator: String, CaseIterable {
	case plus			= "+"
	case minus			= "-"
	case devide			= "/"
	case multiply		= "*"
	case percent		= "%"
	case openBracket	= "("
	case closeBracket	= ")"
	
	func evaluate(b: Double, a: Double) -> Double {
		switch self {
		case .plus:			return a + b
		case .minus:		return a - b
		case .devide:		return b == 0 ? 0 : a / b
		case .multiply:		return a * b
		case .percent:		return a / 100.0 * b
		case .openBracket:	return 0
		case .closeBracket: return 0
		}
	}
	
	var priority: Int {
		switch self {
		case .plus, .minus:
			return 0
		case .devide, .multiply:
			return 1
		case .percent:
			return 2
		case .openBracket, .closeBracket:
			return -1
		}
	}
}
