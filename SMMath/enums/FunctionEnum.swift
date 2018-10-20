//
//  FunctionEnum.swift
//  SMMath
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

internal enum FunctionType: CustomStringConvertible {
	case max(Expression<Double>, Expression<Double>)
	case min(Expression<Double>, Expression<Double>)
	
	init?(name: String, parameters: [Expression<Double>]) {
		var name = name
		if name.starts(with: "$") {
			name = String(name[name.index(after: name.startIndex)...])
		}
		switch name.lowercased() {
		case "max" where parameters.count == 2:
			self = .max(parameters[0], parameters[1])
		case "min" where parameters.count == 2:
			self = .min(parameters[0], parameters[1])
		default:
			return nil
		}
	}
	
	public var description: String {
		switch self {
		case .max(let value1, let value2): return "$max(\(value1), \(value2))"
		case .min(let value1, let value2): return "$min(\(value1), \(value2))"
		}
	}
	
	func calcualte(data: [String: Calculable]) -> Double {
		let data = data.mapValues({ $0.calculableValue })
		switch self {
		case .max(let exp1, let exp2):
			let value1 = SMMath.calculate(formula: exp1.description, data: data)
			let value2 = SMMath.calculate(formula: exp2.description, data: data)
			return value1 > value2 ? value1 : value2
		case .min(let exp1, let exp2):
			let value1 = SMMath.calculate(formula: exp1.description, data: data)
			let value2 = SMMath.calculate(formula: exp2.description, data: data)
			return value1 < value2 ? value1 : value2
		}
	}
	
	mutating func updateUnknownElements(_ handler: (ExpressionElement) -> ExpressionElement) {
		switch self {
		case var .max(exp1, exp2):
			exp1.updateUnknownElements(handler)
			exp2.updateUnknownElements(handler)
			self = .max(exp1, exp2)
		case var .min(exp1, exp2):
			exp1.updateUnknownElements(handler)
			exp2.updateUnknownElements(handler)
			self = .min(exp1, exp2)
		}
	}
}
