//
//  main.swift
//  Main
//
//

import Foundation


let pizzabot = Pizzabot()

if CommandLine.argc < 2 {
    print(errorStringNoInput)
} else {
    let input = CommandLine.arguments[1]
    let output = pizzabot.deliverPizza(input: input)
}
