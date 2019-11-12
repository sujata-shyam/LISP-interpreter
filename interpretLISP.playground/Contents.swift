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

var globalEnvFunc = [String:([Double]) -> Any?]()

globalEnvFunc["+"] = {return ($0.reduce(0, {$0 + $1}))}
globalEnvFunc["*"] = {return ($0.reduce(1, {$0 * $1}))}

globalEnvFunc[">"] = {return ($0[0] > $0[1]) }
globalEnvFunc["<"] = {return ($0[0] < $0[1]) }
globalEnvFunc[">="] = {return ($0[0] >= $0[1]) }
globalEnvFunc["<="] = {return ($0[0] <= $0[1]) }

globalEnvFunc["="] = {return ($0[0] == $0[1]) }
globalEnvFunc["==="] = {return ($0[0] == $0[1]) }
globalEnvFunc["!=="] = {return ($0[0] != $0[1]) }

globalEnvFunc["-"] = {(arrOperands: [Double]) -> Double? in
    var newOperands = arrOperands
    return newOperands.count > 1 ? newOperands.dropFirst().reduce(newOperands.removeFirst(), {$0 - $1} ) : newOperands[0] * -1 }

globalEnvFunc["/"] = {(arrOperands: [Double]) -> Double in
    var newOperands = arrOperands
    return (newOperands.count == 1 ? 1.0/newOperands[0] : newOperands.dropFirst().reduce(newOperands.removeFirst(), {$0 / $1})).roundTo(places: 2)  }

globalEnvFunc["sqrt"] = { return ($0[0].squareRoot().roundTo(places: 2)) }

globalEnvFunc["abs"] = { return abs($0[0]) }

globalEnvFunc["expt"] = { return pow($0[0], $0[1]) }

globalEnvFunc["max"] = {return max($0[0], $0[1]) }

globalEnvFunc["min"] = {return min($0[0], $0[1]) }

globalEnvFunc["round"] = { return round($0[0]) }

globalEnvFunc["print"] = { return(print($0)) }


var globalEnvCons = [String:Double]()

globalEnvCons["pi"] = { return Double.pi }()


//operationsDictionary["-"] = {
//    return ($0.count > 1 ? $0.dropFirst().reduce($0.removeFirst(), {$0[0] - $0[1]} ) : $0[0] * -1) }
//
// operationsDictionary["+"] = {(arrOperands:inout [Double]) -> Double in
//     return (arrOperands.reduce(0, {$0 + $1}))}
//
//operationsDictionary["*"] = {(arrOperands:inout [Double]) -> Double in
//    return (arrOperands.reduce(1, {$0 * $1}))}
//
//operationsDictionary["-"] = {(arrOperands:inout [Double]) -> Double? in
//    return arrOperands.count > 1 ? arrOperands.dropFirst().reduce(arrOperands.removeFirst(), {$0 - $1} ) : arrOperands[0] * -1 }
//
//operationsDictionary["/"] = {(arrOperands:inout [Double]) -> Double in
//    return arrOperands.count == 1 ? 1.0/arrOperands[0] : arrOperands.dropFirst().reduce(arrOperands.removeFirst(), {$0 / $1} )   }
//
//operationsDictionary[">"] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] > arrOperands[1]  }
//
//operationsDictionary["<"] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] < arrOperands[1]  }
//
//operationsDictionary[">="] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] >= arrOperands[1]  }
//
//operationsDictionary["<="] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] <= arrOperands[1]  }
//
//operationsDictionary["="] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] == arrOperands[1]  }
//
//operationsDictionary["==="] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] == arrOperands[1]  }
//
//operationsDictionary["!=="] = {(arrOperands:inout [Double]) -> Any? in
//    return arrOperands[0] != arrOperands[1]  }
//
//operationsDictionary["print"] = {(arrOperands:[Any]) -> Double? in
//    print(arrOperands)
//    return nil
//}
//
//operationsDictionary["pi"] = {(Any)->Double in
//    return Double.pi
//}

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

func defineOp(_ inputArray:[String])->[String]
{
    var localInputArray = inputArray
    
    //Storing constants eg.: define r 10
    localInputArray.remove(at: 0) //remove define keyword
    globalEnvCons[localInputArray[0]] = Double(localInputArray[1])
    localInputArray.removeSubrange(0...1)//remove the key and value both

    if(localInputArray.count>0 && localInputArray[0] == ")")
    {
        localInputArray.remove(at: 0)
    }
    
    return localInputArray //return the remaining array
}


//func evaluater( _ input: String)->[Any]?
//{
//    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
//    {
//        var inputArray = input.split(separator: " ")//convert to array for easier operation
//        //print(inputArray)
//
//        //remove the initial "("
//        inputArray[0].count > 1 ? String(inputArray[0].removeFirst()) : String(inputArray.remove(at: 0))
//
//        //if () found
//        if(inputArray[0] == ")"){return nil}
//
//        var resultArray = [Double]()
//        //var argArray = [Any]()
//        var argArray = [Double]()
//
//        var operation = ""
//
//        for _ in 0..<inputArray.count
//        {
//            if(inputArray[0].first == "(")
//            {
//                let result = evaluater(inputArray.joined(separator: " ")) //recursive call for nested exp.
//
//                inputArray = result![0] as! [String.SubSequence]
//                resultArray.append(result![1] as! Double)
//
//                //Final operation of results got for the inner ()
//                if ( (operation != "") && (inputArray.count == 0) && (resultArray.count > 0))
//                {
//                    argArray = resultArray + argArray //moving the results as args for the final op.
//                    break
//                }
//            }
//            else if(operationsDictionary.keys.contains(String(inputArray[0])))
//            {
//                operation = String(inputArray[0])
//                inputArray.remove(at: 0)
//            }
//            else if let result =  numberParser(input: String(inputArray[0]))
//            {
//                inputArray.remove(at: 0)
//                //argArray.append(result[0] as Any)
//                argArray.append(result[0] as! Double)
//                let remString = result[1] as! String
//
//                if(remString.contains(")"))// for ")"
//                {
//                    break
//                }
//            }
//            else if (inputArray[0].contains(")"))// for non-numeric cases like ")(", ")(+", etc.
//            {
//
//                if(inputArray[0].hasPrefix(")"))
//                {
//                    inputArray[0].removeFirst() // remove ")"
//                    break
//                }
////                else if(inputArray[0].hasSuffix(")"))
////                {
////                    inputArray[0].removeLast() // remove ")"
////                    break
////                }
//            }
//        }
//        return [inputArray, operationsDictionary[operation]!(argArray) as Any]
//        //return [inputArray, operationsDictionary[operation]!(&argArray) as Any]
//    }
//    return nil
//}

let arrSpecialForm = ["define","if","lambda"]

func evaluater(_ input: String)->Any?
{
    print("EVALUATER CALLED")

    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
    {
        var inputArray = input.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ").components(separatedBy: " ").filter{$0 != ""}//convert to array for easier operation
        
        print("inputArray: \(inputArray)")
        
        inputArray.remove(at: 0) //remove the initial "("
        
        if(inputArray[0] == ")"){ return nil } //if () found
        
//        if(inputArray.last == ")") //remove the final ")" //RECHECK
//        {
//            inputArray.removeLast()
//        }
        //print(inputArray)
        
        while(inputArray.count > 0)
        {
            if(arrSpecialForm.contains(inputArray[0]))
            {
                inputArray = specialFormParser(inputArray)
            }
            else
            {
                let res = functionParser(inputArray)
                print("EVALUATER RETURN RESULT:\(res)")
                inputArray = res![0] as! [String]
            }
        }
    }
    return nil
}

func specialFormParser(_ inputArray:[String])->[String]
{
    print("specialFormParser CALLED")
    
    var localInputArray = inputArray
    
    print("localInputArray_special: \(localInputArray)")

    if(inputArray[0] == "define")
    {
        localInputArray = defineOp(inputArray)
    }
    if(inputArray[0] == "begin")
    {
        
    }
    if(inputArray[0] == "if")
    {
        
    }
    return localInputArray
}

func functionParser(_ inputArray:[String])->[Any]?
{
    print("FUNCTION PARSER CALLED")

    struct result{ static var arr = [Double]() }//to store results between function calls

    var localInputArray = inputArray //Making a local copy
    var argArray = [Double]()
    var operation = ""
    
    print("localInputArray: \(localInputArray)")
    
    //for _ in 0..<localInputArray.count
    while(localInputArray.count > 0)
    {
        if(localInputArray[0] == "(")
        {
            evaluater(localInputArray.joined(separator: " "))
            print("localInputArray123: \(localInputArray)")

            //let result = evaluater(localInputArray.joined(separator: " "))
            //print("result:\(result)")
            //localInputArray = result![0] as! [String]
            //resultArray.append(result![1] as! Double)
            //print("resultArray:\(resultArray)")
            //Final operation of results got for the inner ()
//            if ( (operation != "") && (localInputArray.count == 0) && (resultArray.count > 0))
//            {
//                argArray = resultArray + argArray //moving the results as args for the final op.
//                print("argArray:\(argArray)")
//                break
//            }
        }
        else if(globalEnvFunc.keys.contains(String(localInputArray[0])))
        {
            operation = String(localInputArray[0])
            print("operation: \(operation)")
            localInputArray.remove(at: 0)
        }
        else if(globalEnvCons.keys.contains(String(localInputArray[0])))
        {
            argArray.append(globalEnvCons[String(localInputArray[0])]!)
            localInputArray.remove(at: 0)
        }
        else if let resultNumber =  numberParser(input: String(localInputArray[0]))
        {
            localInputArray.remove(at: 0)
            argArray.append(resultNumber[0] as! Double)
        }
        else if (localInputArray[0] == ")")//
        {
            localInputArray.remove(at: 0)
            
            print("operation:\(operation)")
            if ( (operation != "") && (localInputArray.count == 0) && (result.arr.count > 0))
            {
                argArray = result.arr + argArray //moving the results as args for the final op.
                print("argArray:\(argArray)")
                break
            }
            
            break
        }
    }
    

    //resultArray.append(globalEnvFunc[operation]!(argArray) as! Double)
    //print("resultArray:\(resultArray)")
    
    result.arr.append(globalEnvFunc[operation]!(argArray) as Any as! Double)
    print("result.arr:\(result.arr)")
    print("localInputArray: \(localInputArray)")
    return [localInputArray, globalEnvFunc[operation]!(argArray) as Any]
    
    //return [inputArray, globalEnvFunc[operation]!(&argArray) as Any]
    //return nil
}

//func evaluateExp( _ input: String)->[Any]?
//{
//    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
//    {
//        var inputArray = input.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ").components(separatedBy: " ").filter{$0 != ""}//convert to array for easier operation
//
//        print(inputArray)
//
//        inputArray.remove(at: 0) //remove the initial "("
//
//        if(inputArray[0] == ")"){ return nil } //if () found
//
//        if(inputArray.last == ")") //remove the final ")" //RECHECK
//        {
//            inputArray.removeLast()
//        }
//        print(inputArray)
//        var resultArray = [Double]()
//        var argArray = [Double]()
//        var operation = ""
//
//        for _ in 0..<inputArray.count
//        {
//            //break
//            if(inputArray[0] == "(")
//            {
//                let result = evaluateExp(inputArray.joined(separator: " ")) //recursive call for nested exp.
//
//                //print("result:\(result)")
//                //inputArray = result![0] as! [String.SubSequence]
//                inputArray = result![0] as! [String]
//
//                resultArray.append(result![1] as! Double)
//                //print("resultArray: \(resultArray)")
//                //print("inputArray.count: \(inputArray.count)")
//                //Final operation of results got for the inner ()
//                if ( (operation != "") && (inputArray.count == 0) && (resultArray.count > 0))
//                {
//                    argArray = resultArray + argArray //moving the results as args for the final op.
//                    //print("argArray:\(argArray)")
//                    break
//                }
//            }
//            else if(inputArray[0] == "define")
//            {
//                inputArray.remove(at: 0)
//                defineOp(inputArray)
//            }
//            else if(globalEnvFunc.keys.contains(String(inputArray[0])))
//            {
//                operation = String(inputArray[0])
//                inputArray.remove(at: 0)
//            }
//            else if(globalEnvCons.keys.contains(String(inputArray[0])))
//            {
//                argArray.append(globalEnvCons[String(inputArray[0])]!)
//                inputArray.remove(at: 0)
//            }
//            else if let result =  numberParser(input: String(inputArray[0]))
//            {
//                inputArray.remove(at: 0)
//                argArray.append(result[0] as! Double)
//            }
//            else if (inputArray[0] == ")")//
//            {
//                inputArray.remove(at: 0)
//                break
//            }
//        }
//        return [inputArray, globalEnvFunc[operation]!(argArray) as Any]
//        //return [inputArray, globalEnvFunc[operation]!(&argArray) as Any]
//
//    }
//    return nil
//}

//TEST-CASES


//let res12 = evaluater("(* 2 3 )")

let res11 = evaluater("(+ (* 2 3 )( + 45 5))")//NOT WORKING

//let res511 = evaluater("(define r 10)(* r r)")
//let res411 = evaluater("(if (> 3 2) (- 3 2) (+ 3 2))") //PENDING
//let res111 = evaluater("(print(+ (* 2 3 )( + 45 5)))") //NOT WORKING
//let res143 = evaluater("(* pi 4 3)")
//let res12 = evaluater("( * 2 3)")
//let res13 = evaluater("( + 45 5)")
//let res14 = evaluater("( * )")
//let res141 = evaluater("( - 45 )")
//let res145 = evaluater("( - 45 40)")
//let res142 = evaluater("(/ 8 4 2)")
//let res14_2 = evaluater("(/ 8)")
//let res144 = evaluater("(print 4)")

//let res15 = evaluater("(> 45 5)")
//let res16 = evaluater("(<= 44 45)")
//let res17 = evaluater("(   sqrt  49)   ")
//let res18 = evaluater("(+ 10 (sqrt 100))")
//let res19 = evaluater("(+ (+ 4 5) (- 16 4))")
//let res20 = evaluater("(abs -10.5)")
//let res21 = evaluater("(!== 45 45.0)")

//let res1441 = evaluateExp("(print HELLO)")// not working
