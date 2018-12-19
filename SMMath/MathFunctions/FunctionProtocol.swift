//
//  FunctionProtocol.swift
//  SMMath
//
//  Created by Alexey Siginur on 20/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

protocol FunctionProtocol: CustomStringConvertible {
	
	var name: String {get}
	
	init?(parameters: [Expression<Double>])
	
	func calculate(data: [String: Calculable]) -> Double
	
}
