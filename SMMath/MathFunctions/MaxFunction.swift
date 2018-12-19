//
//  MaxFunction.swift
//  SMMath
//
//  Created by Alexey Siginur on 20/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

class MaxFunction: FunctionProtocol {
	
	let name: String = "max"
	
	let firstExpression: Expression<Double>
	let secondExpression: Expression<Double>

	required init?(parameters: [Expression<Double>]) {
		guard parameters.count == 2 else {
			return nil
		}
		firstExpression = parameters[0]
		secondExpression = parameters[1]
	}
	
	func calculate(data: [String : Calculable]) -> Double {
		let data = data.mapValues({ $0.calculableValue })
		let value1 = SMMath.calculate(formula: firstExpression.description, data: data)
		let value2 = SMMath.calculate(formula: secondExpression.description, data: data)
		return max(value1, value2)
	}
	
	var description: String {
		return "$" + name + "(...)"
	}
	
}
