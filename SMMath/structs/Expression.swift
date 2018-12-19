//
//  Expression.swift
//  SMMath
//
//  Created by Alexey Siginur on 19/10/2018.
//  Copyright © 2018 merkova. All rights reserved.
//

internal struct Expression<T: Calculable>: Sequence, CustomStringConvertible {
	
	private(set) var elements: [ExpressionElement]
	
	var count: Int {
		return elements.count
	}
	
	var description: String {
		return elements.map({ $0.description }).joined(separator: " ")
	}
	
	init(elements: [ExpressionElement]) {
		self.elements = elements
	}
	
	init(formula: String, data: [String: T] = [:]) {
		let components = Expression.splitFormula(formula)
		let withoutFunctions = Expression.buildElementsWithoutFunctions(components: components, data: data)
		elements = withoutFunctions
//		elements = Expression.buildFunctions(withoutFunctions: withoutFunctions)
//
//		elements = []
//		var counter = 0
//		var functionName: String? = nil
//		var parameters = [Expression<Double>]()
//		var parameterElements = [ExpressionElement]()
//		for element in withoutFunctions {
//			if let funcName = functionName {
//				// Parse function parameters
//				if case .unknown(let unk) = element, unk == ",", counter == 1 {
//					// new parameter
//					parameters.append(Expression<Double>(elements: parameterElements))
//					parameterElements = []
//				} else if case .operator(.openBracket) = element {
//					if counter > 0 {
//						parameterElements.append(element)
//					}
//					counter += 1
//				} else if case .operator(.closeBracket) = element {
//					counter -= 1
//					if counter > 0 {
//						parameterElements.append(element)
//					} else {
//						if parameterElements.count > 0 {
//							parameters.append(Expression<Double>(elements: parameterElements))
//							parameterElements = []
//						}
//						if let `func` = FunctionType(name: funcName, parameters: parameters) {
//							elements.append(.function(`func`))
//						} else {
//							elements.append(.number(0))
//						}
//						functionName = nil
//					}
//				} else {
//					parameterElements.append(element)
//				}
//			} else {
//				// Search for function
//				if case .unknown(let unk) = element, unk.starts(with: "$") {
//					functionName = unk
//					parameters = []
//					parameterElements = []
//				} else {
//					elements.append(element)
//				}
//			}
//		}
	}
	
	subscript(index: Int) -> ExpressionElement {
		get {
			return elements[index]
		}
		set {
			elements[index] = newValue
		}
	}
	
	subscript(subrange: CountableRange<Int>) -> ArraySlice<ExpressionElement> {
		return elements[subrange]
	}
	
	mutating func replaceSubrange(_ subrange: CountableClosedRange<Int>, with: [ExpressionElement]) {
		elements.replaceSubrange(subrange, with: with)
	}
	
	mutating func insert(_ newElement: ExpressionElement, at: Int) {
		elements.insert(newElement, at: at)
	}
	
	mutating func updateUnknownElements(_ handler: (ExpressionElement) -> ExpressionElement) {
		var updated = [ExpressionElement]()
		for element in elements {
			switch element {
			case .unknown:
				updated.append(handler(element))
			case .function(var `func`):
				`func`.updateUnknownElements(handler)
				updated.append(.function(`func`))
			default:
				updated.append(element)
			}
		}
		elements = updated
	}
	
	// Sequence protocol
	public typealias Iterator = IndexingIterator<[ExpressionElement]>
	
	public func makeIterator() -> Iterator {
		return elements.makeIterator()
	}
}

internal extension Expression {
	
	internal static func splitFormula(_ formula: String) -> [String] {
		var formula = "(" + formula.replacingOccurrences(of: " ", with: "") + ")"
		for mathOperator in MathOperator.allCases {
			let character = mathOperator.rawValue
			formula = formula.components(separatedBy: CharacterSet(charactersIn: "\(character)")).joined(separator: " \(character) ")
		}
		formula = formula.components(separatedBy: CharacterSet(charactersIn: ",")).joined(separator: " , ") // for function parameters
		let trimmed = formula.trimmingCharacters(in: CharacterSet(charactersIn: " "))
		let splitted = trimmed.split(separator: " ")
		return splitted.map { String($0) }
	}
	
	private static func buildElementsWithoutFunctions(components: [String], data: [String: T]) -> [ExpressionElement] {
		return components.map({ strElement -> ExpressionElement in
			if let value = Double(strElement) {
				// Number
				return ExpressionElement.number(value)
			} else if let op = MathOperator(rawValue: strElement) {
				// Operation
				return ExpressionElement.operator(op)
			} else if let value = data[strElement]?.calculableValue {
				// Variable
				return ExpressionElement.number(value)
			}
			else if strElement.starts(with: "$") {
//				guard let function = availableFunctions.first(where: { "$" + $0.name == strElement }) else {
//					return ExpressionElement.unknown(strElement)
//				}
				let params = [Expression<Double>(formula: "3"), Expression<Double>(formula: "1")]
				return ExpressionElement.functionClass(MaxFunction(parameters: params)!)
			}
			return ExpressionElement.unknown(strElement)
		})
	}
	
	private static func buildFunctions(withoutFunctions src: [ExpressionElement]) -> [ExpressionElement] {
//		let availableFunctions = [FunctionProtocol]()
		let elements = [ExpressionElement]()
//		var function: FunctionProtocol!
//		for (index, element) in src.enumerated() {
//			if case .unknown(let funcName) = element, unk.starts(with: "$") {
//				function = availableFunctions.first(where: { "$" + $0.name == funcName })
//				continue
//			}
//		}
		return elements
	}
	
}
