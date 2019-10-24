import Foundation

//(+ 2 3)

//enum Operations:Character
//{
//    case add = "+"
//    case subtract = "-"
//    case multiply = "*"
//    case divide = "/"
//}

//let operators = ["+", "*", "-", "/", ">", "<"]

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


//typealias Methods = (([Double]) -> Double?) // To represent functions

typealias Methods = (([Double]) -> Any?) // To represent functions
var operationsDictionary = [String:Methods]()

//var operationsDictionary = [String:Any]()


operationsDictionary["+"] = {(arrOperands:[Double]) -> Double in
    return (arrOperands.reduce(0, {$0 + $1}))}

operationsDictionary["*"] = {(arrOperands:[Double]) -> Double in
    return (arrOperands.reduce(1, {$0 * $1}))}

operationsDictionary["-"] = {(arrOperands:[Double]) -> Double? in
        if(arrOperands.count == 0)
        {
            print("Invalid")
            return nil
        }
        if(arrOperands.count == 1)
        {
            return -arrOperands[0]
        }
    
        var initialVal = arrOperands[0]
    
        for i in 1..<arrOperands.count
        {
            initialVal = initialVal - arrOperands[i]
        }
        return initialVal
    }

operationsDictionary["/"] = {(arrOperands:[Double]) -> Double? in
        if(arrOperands.count == 0 || arrOperands[0] == 0)//cannot divide by 0
        {
            print("Invalid")
            return nil
        }
        if(arrOperands.count == 1)
        {
            return 1.0/Double(arrOperands[0])
        }

        var initialVal = Double(arrOperands[0])

        for i in 1..<arrOperands.count
        {
            initialVal = initialVal / Double(arrOperands[i])
        }
        return initialVal.roundTo(places: 2)
    }

operationsDictionary[">"] = {(arrOperands:[Double]) -> Bool? in
    if(arrOperands.count == 2)
    {
        return arrOperands[0] > arrOperands[1]
    }
    print("Invalid")
    return nil
}

operationsDictionary["<"] = {(arrOperands:[Double]) -> Bool? in
    if(arrOperands.count == 2)
    {
        return arrOperands[0] < arrOperands[1]
    }
    print("Invalid")
    return nil
}

operationsDictionary[">="] = {(arrOperands:[Double]) -> Bool? in
    if(arrOperands.count == 2)
    {
        return arrOperands[0] >= arrOperands[1]
    }
    print("Invalid")
    return nil
}

operationsDictionary["<="] = {(arrOperands:[Double]) -> Bool? in
    if(arrOperands.count == 2)
    {
        return arrOperands[0] <= arrOperands[1]
    }
    print("Invalid")
    return nil
}

operationsDictionary["sqrt"] = {(arrOperands:[Double]) -> Double? in
    if(arrOperands.count == 1)
    {
        return arrOperands[0].squareRoot().roundTo(places: 2)
    }
    print("Invalid")
    return nil
}


/* Not working
operationsDictionary["print"] = {()->Double in
    return Double.pi}

operationsDictionary["pi"] = {()->Double in
    return Double.pi}
*/


//let res1 = operationsDictionary["+"]!([1])
//let res2 = operationsDictionary["*"]!([])
//let res3 = operationsDictionary["-"]!([1])
//let res4 = operationsDictionary["/"]!([4,3,2])
//let res5 = operationsDictionary[">"]!([2,3])
//let res6 = operationsDictionary["<"]!([5,6,7])
//let res7 = operationsDictionary["sqrt"]!([4])

//func evaluate(operation:String, argArr:[Int])->Any?
//{
//    switch operation
//    {
//        case "+":
//            return argArr.reduce(0, { x, y in
//                x + y
//            })
//        case "*":
//            return argArr.reduce(1, { x, y in
//                x * y
//            })
//        case "-":
//            if(argArr.count == 0)
//            {
//                print("Invalid")
//                return 0
//            }
//
//            if(argArr.count == 1)
//            {
//                return -argArr[0]
//            }
//
//            var initialVal = argArr[0]
//
//            for i in 1..<argArr.count
//            {
//                initialVal = initialVal - argArr[i]
//            }
//            return initialVal
//        case "/":
//            if(argArr.count == 0)
//            {
//                print("Invalid")
//                return 0
//            }
//
//            if(argArr.count == 1)
//            {
//                return 1.0/Double(argArr[0])
//            }
//
//            var initialVal = Double(argArr[0])
//
//            for i in 1..<argArr.count
//            {
//                initialVal = initialVal / Double(argArr[i])
//            }
//            return initialVal
//
//        case ">": return argArr[0] > argArr[1]
//        case "<": return argArr[0] < argArr[1]
//        case ">=": return argArr[0] >= argArr[1]
//        case "<=": return argArr[0] <= argArr[1]
//        case "=": return argArr[0] == argArr[1]
//        case "pi": return 3.14
//        default:
//            print("Still Working")
//    }
//    return 0
//}

//func parseInput(input:String)->Any?
//{
//    var newInput =  input.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    if(newInput.hasPrefix("(")) //check for initial "(" else return nil
//    {
//        newInput = String(newInput.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines) //remove the initial "(" and then remove white spaces
//
//        let firstOperator  = String(newInput.removeFirst())//get the operator
//
//        if(!operators.contains(firstOperator)) //if the operator is not from the set of operators
//        {
//            return nil
//        }
//
//        var argArray = [Any]()
//
//        while(newInput.count>0)
//        {
//            if let resultarray = numberParser(input: newInput.trimmingCharacters(in: .whitespacesAndNewlines)) //checking if the arg is a number
//            {
//                argArray.append(resultarray[0] as Any)
//                newInput = resultarray[1] as! String
//            }
//            else //if arg. is not a number
//            {
//                break
//            }
//        }
//
//        //if(argArray.count == 0) // if the arguments are not numeric
//        //{
//        //    return nil
//        //}
//
//        //Return nil if closing ")" is not found after the arg. are extracted
//        if(!newInput.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix(")"))
//        {
//            return nil
//        }
//
//        return evaluate(operation: firstOperator, argArr: argArray as! [Int])
//
//    }
//    return nil
//}

func evaluater( _ input: String)->[Any]?
{
    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
    {
        var inputArray = input.split(separator: " ")//convert to array for easier operation
        
        //remove the initial "("
        inputArray[0].count > 1 ? String(inputArray[0].removeFirst()) : String(inputArray.remove(at: 0))
        
        //if () found
        if(inputArray[0] == ")"){return nil}
        
        var resultArray = [Double](), argArray = [Double]()
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
                argArray.append(result[0] as! Double)
                let remString = result[1] as! String
                if(remString.contains(")")) { break }// for ")"
            }
            else if (inputArray[0].contains(")"))// for non-numeric cases like ")(", ")(+", etc.
            {
                inputArray[0].removeFirst() // remove ")"
                break
            }
        }
        return [inputArray, operationsDictionary[operation]!(argArray) as Any]
    }
    return nil
}


let res11 = evaluater("(+ (* 2 3 )( + 45 5))")
let res12 = evaluater("(* 2 3)")
let res13 = evaluater("( + 45 5)")
let res14 = evaluater("( * )")
let res15 = evaluater("(> 45 5)")
let res16 = evaluater("(<= 44 45)")
let res17 = evaluater("(   sqrt  49)   ")
let res18 = evaluater("(+ 10 (sqrt 100))")
let res19 = evaluater("(+ (+ 4 5) (- 16 4))")


