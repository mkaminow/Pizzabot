//
//  Pizzabot.swift
//  Pizzabot
//
//

import Foundation


//MARK: - Data Types
public struct Point {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func distanceFrom(currentPosition: Point)->Int {
        let numHorizontalMoves = self.x - currentPosition.x
        let numVerticalMoves = self.y - currentPosition.y
        return abs(numHorizontalMoves) + abs(numVerticalMoves)
    }
}

public struct GridSize {
    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

//MARK: - Error Strings

let errorStringNoInput = "PizzaBot needs more info"
let errorStringNoGrid = "Pizzabot's delivery range must be declared before delivery coordinates"
let errorStringOutsideOfBounds = "Outside of Pizzabot's delivery range"
let errorStringBadData = "Data in incorrect format"


//MARK: - Pizzabot
class Pizzabot {

    func deliverPizza(input: String)->String {
        guard input.contains(",") else {
            return errorStringNoInput
        }

        let elements = input.replacingOccurrences(of: " ", with: "").components(separatedBy: CharacterSet.init(charactersIn: "\"([{"))
        let gridSize = parseGridSize(elements: elements)
        let coordinates = parseCoordinates(elements: elements)
        let validCoordinates = validateCoordinates(gridSize: gridSize, coordinates: coordinates)
        if validCoordinates.count <= 8 {
            return calculateAllRoutes(coordinates: validCoordinates, currentPosition: Point(x: 0, y: 0), route: "")
        } else {
            return calculateNNRoute(coordinates: validCoordinates, currentPosition: Point(x: 0, y: 0), route: "")
        }
    }

    private func parseGridSize(elements: [String])->GridSize? {
        let gridElement = elements[0].components(separatedBy: CharacterSet.init(charactersIn: "xX"))
        if gridElement.count == 2 {
            if let width = Int(gridElement[0].numbersOnly), let height = Int(gridElement[1].numbersOnly) {
                return GridSize(width: width, height: height)
            } else {
                print(errorStringBadData)
            }
        } else {
            print(errorStringBadData)
        }
        return nil
    }

    private func stringToPoint(coordinateString: String)->Point? {
        let array = coordinateString.components(separatedBy: ",").filter{$0 != ""}
        if array.count == 2 {
            if let xValue = Int(array[0].numbersOnly), let yValue = Int(array[1].numbersOnly) {
                return Point(x: xValue, y: yValue)
            }
        }
        return nil
    }

    private func parseCoordinates(elements: [String])->[Point] {
        let justCoordinates = elements.filter { $0 != elements[0] }

        let setOfCoordinates = justCoordinates.map{
            stringToPoint(coordinateString: $0)
        }
        return setOfCoordinates.flatMap{$0}
    }

    private func validateCoordinates(gridSize: GridSize?, coordinates: [Point])->[Point] {
        if let gridSize = gridSize {
            return coordinates.filter{$0.x<gridSize.height && $0.y<gridSize.width && $0.x >= 0 && $0.y >= 0}
        } else {
            return coordinates.filter{$0.x > 0 && $0.y > 0}
        }
    }

    private func concatRoute(numHorizontalMoves: Int, numVerticalMoves:Int, route: String)->String {
        let horizontalMoves = String(repeating: (numHorizontalMoves > 0 ? "E" : "W"), count: abs(numHorizontalMoves))
        let verticalMoves = String(repeating: (numVerticalMoves > 0 ? "N" : "S"), count: abs(numVerticalMoves))
        return route + horizontalMoves + verticalMoves + "D"
    }

    private func calculateDefaultRoute(coordinates: [Point], currentPosition: Point, route: String)->String {
        let coordinate = coordinates[0]
        
        let numHorizontalMoves: Int = coordinate.x - currentPosition.x
        let numVerticalMoves: Int = coordinate.y - currentPosition.y

        let newPositionX = currentPosition.x + numHorizontalMoves
        let newPositionY = currentPosition.y + numVerticalMoves

        let newRoute = concatRoute(numHorizontalMoves: numHorizontalMoves, numVerticalMoves: numVerticalMoves, route: route)

        let remainingCoordinates = Array(coordinates.dropFirst())

        if remainingCoordinates.count > 0 {
            return calculateDefaultRoute(coordinates: remainingCoordinates, currentPosition: Point(x: newPositionX, y: newPositionY), route: newRoute)
        }
        
        return newRoute
    }

    private func calculateNNRoute(coordinates: [Point], currentPosition: Point, route: String)->String {
        let sortedCoordinates = sortArrayByDistance(array: coordinates, currentPosition: currentPosition)

        let coordinate = sortedCoordinates[0]

        let numHorizontalMoves: Int = coordinate.x - currentPosition.x
        let numVerticalMoves: Int = coordinate.y - currentPosition.y

        let newPositionX = currentPosition.x + numHorizontalMoves
        let newPositionY = currentPosition.y + numVerticalMoves
        
        let newRoute = concatRoute(numHorizontalMoves: numHorizontalMoves, numVerticalMoves: numVerticalMoves, route: route)

        let remainingCoordinates = Array(sortedCoordinates.dropFirst())
        if remainingCoordinates.count > 0 {
            return calculateNNRoute(coordinates: remainingCoordinates, currentPosition: Point(x: newPositionX, y: newPositionY), route: newRoute)
        }
            return newRoute
    }

    private func calculateAllRoutes(coordinates: [Point], currentPosition: Point, route: String)->String {
        var routes: [String] = []
        for coordinate in coordinates {

            let numHorizontalMoves: Int = coordinate.x - currentPosition.x
            let numVerticalMoves: Int = coordinate.y - currentPosition.y

            let newPositionX = currentPosition.x + numHorizontalMoves
            let newPositionY = currentPosition.y + numVerticalMoves

            let newRoute = concatRoute(numHorizontalMoves: numHorizontalMoves, numVerticalMoves: numVerticalMoves, route: route)

            var newCoordinates = coordinates
            if let i = newCoordinates.index(of: coordinate) {
                newCoordinates.remove(at: i)
                routes.append(calculateAllRoutes(coordinates: newCoordinates, currentPosition: Point(x: newPositionX, y: newPositionY), route: newRoute))
            }

            if newCoordinates.count <= 0 {
                return newRoute
            }
        }

        // get shortest of routes
        if let shortestRoute = routes.min(by: {$1.count > $0.count}) {
            return shortestRoute
        } else {
            return("")
        }
    }


    private func sortArrayByDistance(array: [Point], currentPosition: Point) -> [Point] {
        return array.sorted{$0.distanceFrom(currentPosition: currentPosition) > $1.distanceFrom(currentPosition: currentPosition)}
    }
}

//MARK: - Extensions
extension String {
    var numbersOnly: String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
    }
}


extension Point: Equatable {
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
