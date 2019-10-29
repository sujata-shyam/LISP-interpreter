import Foundation

extension String //Extension to down-cast
{
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
}

extension Double
{
    func roundTo(places:Int) -> Double // for runding off to required precision
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


//typealias Methods = ((inout [Double]) -> Any?)

//var operationsDictionary = [String:Methods]()
//var operationsDictionary = [String:(inout [Double]) -> Any?]()
//var operationsDictionary = [String:(arrOperands:inout [Double]) -> Any?]()

var operationsDictionary = [String:([Double]) -> Any?]()

operationsDictionary["+"] = {return ($0.reduce(0, {$0 + $1}))}
operationsDictionary["*"] = {return ($0.reduce(1, {$0 * $1}))}

operationsDictionary[">"] = {return ($0[0] > $0[1]) }
operationsDictionary["<"] = {return ($0[0] < $0[1]) }
operationsDictionary[">="] = {return ($0[0] >= $0[1]) }
operationsDictionary["<="] = {return ($0[0] <= $0[1]) }

operationsDictionary["="] = {return ($0[0] == $0[1]) }
operationsDictionary["==="] = {return ($0[0] == $0[1]) }
operationsDictionary["!=="] = {return ($0[0] != $0[1]) }

operationsDictionary["-"] = {(arrOperands: [Double]) -> Double? in
    var newOperands = arrOperands
    return newOperands.count > 1 ? newOperands.dropFirst().reduce(newOperands.removeFirst(), {$0 - $1} ) : newOperands[0] * -1 }

operationsDictionary["/"] = {(arrOperands: [Double]) -> Double in
    var newOperands = arrOperands
    return (newOperands.count == 1 ? 1.0/newOperands[0] : newOperands.dropFirst().reduce(newOperands.removeFirst(), {$0 / $1})).roundTo(places: 2)  }

operationsDictionary["sqrt"] = { return ($0[0].squareRoot().roundTo(places: 2)) }

operationsDictionary["abs"] = { return abs($0[0]) }

operationsDictionary["expt"] = { return pow($0[0], $0[1]) }

operationsDictionary["max"] = {return max($0[0], $0[1]) }

operationsDictionary["min"] = {return min($0[0], $0[1]) }

operationsDictionary["round"] = { return round($0[0]) }


/*
operationsDictionary["-"] = {
    return ($0.count > 1 ? $0.dropFirst().reduce($0.removeFirst(), {$0[0] - $0[1]} ) : $0[0] * -1) }

 operationsDictionary["+"] = {(arrOperands:inout [Double]) -> Double in
     return (arrOperands.reduce(0, {$0 + $1}))}

operationsDictionary["*"] = {(arrOperands:inout [Double]) -> Double in
    return (arrOperands.reduce(1, {$0 * $1}))}

operationsDictionary["-"] = {(arrOperands:inout [Double]) -> Double? in
    return arrOperands.count > 1 ? arrOperands.dropFirst().reduce(arrOperands.removeFirst(), {$0 - $1} ) : arrOperands[0] * -1 }

operationsDictionary["/"] = {(arrOperands:inout [Double]) -> Double in
    return arrOperands.count == 1 ? 1.0/arrOperands[0] : arrOperands.dropFirst().reduce(arrOperands.removeFirst(), {$0 / $1} )   }

operationsDictionary[">"] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] > arrOperands[1]  }

operationsDictionary["<"] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] < arrOperands[1]  }

operationsDictionary[">="] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] >= arrOperands[1]  }

operationsDictionary["<="] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] <= arrOperands[1]  }

operationsDictionary["="] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] == arrOperands[1]  }

operationsDictionary["==="] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] == arrOperands[1]  }

operationsDictionary["!=="] = {(arrOperands:inout [Double]) -> Any? in
    return arrOperands[0] != arrOperands[1]  }
*/
/*



operationsDictionary["sqrt"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 1)
    {
        let newOperands = arrOperands as! [Double]
        return newOperands[0].squareRoot().roundTo(places: 2)
    }
    print("Invalid")
    return nil
}

operationsDictionary["abs"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 1)
    {
        let newOperands = arrOperands as! [Double]
        return abs(newOperands[0])
    }
    print("Invalid")
    return nil
}

operationsDictionary["expt"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 2)
    {
        let newOperands = arrOperands as! [Double]
        return pow(newOperands[0], newOperands[1])
    }
    print("Invalid")
    return nil
}

operationsDictionary["max"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 2)
    {
        let newOperands = arrOperands as! [Double]
        return max(newOperands[0], newOperands[1])
    }
    print("Invalid")
    return nil
}

operationsDictionary["min"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 2)
    {
        let newOperands = arrOperands as! [Double]
        return min(newOperands[0], newOperands[1])
    }
    print("Invalid")
    return nil
}

operationsDictionary["round"] = {(arrOperands:[Any]) -> Double? in
    if(arrOperands.count == 1)
    {
        let newOperands = arrOperands as! [Double]
        return round(newOperands[0])
    }
    print("Invalid")
    return nil
}

operationsDictionary["print"] = {(arrOperands:[Any]) -> Double? in
    print(arrOperands)
    return nil
}

operationsDictionary["pi"] = {(Any)->Double in
    return Double.pi
}

 */

func numberParser(input: String) -> [Any?]?
{
    var inputArray = Array(input) //input string converted to Array
    var intCount = 0 //total count of integers
    var intArray = [String]() //Array where we append the integers
    
    var isDecimalDone = false       //decimal point has been found
    var isExponentDone = false      //the exponent has been found
    var isMinusDone = false         //the "-" symbol after e/E
    var isPlusDone = false          //the "+" symbol after e/E
    var totalCount = inputArray.count
    var index = 0
    
    if( ["0","1","2","3","4","5","6","7","8","9"].contains(inputArray[0]) || inputArray[0]=="-" )
    {
        while totalCount > 0
        {
            let val = inputArray[0]
            switch val
            {
            case "-":
                if(isMinusDone==false)
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after - symbol
                    {
                        if(index == 0 || isExponentDone)//if its a -ve no. or the - sign after e/E
                        {
                            intArray.append("-")
                            inputArray.remove(at: 0)
                            totalCount = totalCount - 1
                            index = index + 1
                            
                            if(isExponentDone)
                            {
                                isMinusDone = true
                            }
                        }
                        else
                        {
                            return nil
                        }
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "+":
                if(isPlusDone==false && isExponentDone)
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after - symbol
                    {
                        intArray.append("+")
                        inputArray.remove(at: 0)
                        
                        totalCount = totalCount - 1
                        isPlusDone = true
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "1","2","3","4","5","6","7","8","9":
                intCount += 1
                intArray.append(String(val))
                
                inputArray.remove(at: 0)
                totalCount = totalCount - 1
            case "0":
                if( (intCount > 0) || (inputArray.count == 1) || !(["0","1","2","3","4","5","6","7","8","9"].contains(inputArray[1])) ) //if 0 then check 0 is not the first element or only 0 or 0}}
                {
                    intCount += 1
                    intArray.append(String(val))
                    inputArray.remove(at: 0)
                    totalCount = totalCount - 1
                }
                else
                {
                    return nil
                }
            case ".":
                if(isDecimalDone == false && intCount > 0) //check if there are no decimal points before & there are integers before the decimal point
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after . "decimal point" symbol
                    {
                        intArray.append(".")
                        inputArray.remove(at: 0)
                        totalCount = totalCount - 1
                        isDecimalDone = true
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "e", "E":
                if(isExponentDone==false)
                {
                    intArray.append(String(val))
                    inputArray.remove(at: 0)
                    totalCount = totalCount - 1
                    isExponentDone = true
                }
            default:
                //                if((intArray.joined()).isInteger) //if input is an Integer
                //                {
                //                    return [Int(intArray.joined()), String(inputArray)]
                //                }
                //
                //                if((intArray.joined()).isFloat) //if input is a Float
                //                {
                //                    return [Float(intArray.joined()), String(inputArray)]
                //                }
                
                //else by default double
                return [Double(intArray.joined()), String(inputArray)]
            }
        }
    }
    else
    {
        return nil
    }
    
    //    if((intArray.joined()).isInteger) //if input is an Integer
    //    {
    //        return [Int(intArray.joined()), String(inputArray)]
    //    }
    //
    //    if((intArray.joined()).isFloat) //if input is a Float
    //    {
    //        return [Float(intArray.joined()), String(inputArray)]
    //    }
    
    //else by default Double
    return [Double(intArray.joined()), String(inputArray)]
}

func evaluater( _ input: String)->[Any]?
{
    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
    {
        var inputArray = input.split(separator: " ")//convert to array for easier operation
        //print(inputArray)
        
        //remove the initial "("
        inputArray[0].count > 1 ? String(inputArray[0].removeFirst()) : String(inputArray.remove(at: 0))
        
        //if () found
        if(inputArray[0] == ")"){return nil}
        
        var resultArray = [Double]()
        //var argArray = [Any]()
        var argArray = [Double]()
        
        var operation = ""
        
        for _ in 0..<inputArray.count
        {
            if(inputArray[0].first == "(")
            {
                let result = evaluater(inputArray.joined(separator: " ")) //recursive call for nested exp.
            
                inputArray = result![0] as! [String.SubSequence]
                resultArray.append(result![1] as! Double)
                
                //Final operation of results got for the inner ()
                if ( (operation != "") && (inputArray.count == 0) && (resultArray.count > 0))
                {
                    argArray = resultArray + argArray //moving the results as args for the final op.
                    break
                }
            }
            else if(operationsDictionary.keys.contains(String(inputArray[0])))
            {
                operation = String(inputArray[0])
                inputArray.remove(at: 0)
            }
            else if let result =  numberParser(input: String(inputArray[0]))
            {
                inputArray.remove(at: 0)
                //argArray.append(result[0] as Any)
                argArray.append(result[0] as! Double)
                let remString = result[1] as! String
                
                if(remString.contains(")"))// for ")"
                {
                    break
                }
            }
            else if (inputArray[0].contains(")"))// for non-numeric cases like ")(", ")(+", etc.
            {
                if(inputArray[0].hasPrefix(")"))
                {
                    inputArray[0].removeFirst() // remove ")"
                    break
                }
//                else if(inputArray[0].hasSuffix(")"))
//                {
//                    inputArray[0].removeLast() // remove ")"
//                    break
//                }
            }
        }
        return [inputArray, operationsDictionary[operation]!(argArray) as Any]
        //return [inputArray, operationsDictionary[operation]!(&argArray) as Any]
    }
    return nil
}


let res11 = evaluater("(+ (* 2 3 )( + 45 5))")
let res12 = evaluater("( * 2 3)")
let res13 = evaluater("( + 45 5)")
let res14 = evaluater("( * )")
let res141 = evaluater("( - 45 )")
let res145 = evaluater("( - 45 40)")
let res142 = evaluater("(/ 8 4 2)")
let res14_2 = evaluater("(/ 8)")
//let res143 = evaluater("(* pi 4 3)") //not working

let res15 = evaluater("(> 45 5)")
let res16 = evaluater("(<= 44 45)")
let res17 = evaluater("(   sqrt  49)   ")
let res18 = evaluater("(+ 10 (sqrt 100))")
let res19 = evaluater("(+ (+ 4 5) (- 16 4))")
let res20 = evaluater("(abs -10.5)")
let res21 = evaluater("(!== 45 45.0)")

