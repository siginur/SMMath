//
//  ExpressionElementEnum.swift
//  SMMath
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

internal enum ExpressionElement: CustomStringConvertible {
	case number(Double)
	case function(FunctionType)
	case `operator`(MathOperator)
	case unknown(String)
	
	var description: String {
		switch self {
		case .number(let val): return "\(val)"
		case .function(let `func`): return `func`.description
		case .operator(let op): return op.rawValue
		case .unknown(let unk): return unk
		}
	}
	
	mutating func replaceBy(_ element: ExpressionElement) {
		self = element
	}
}
