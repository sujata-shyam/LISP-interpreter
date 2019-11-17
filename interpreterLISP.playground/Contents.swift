import Foundation


extension Double
{
    func roundTo(places:Int) -> Double // for rounding off to required precision
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String
{
    var isDouble: Bool { return Double(self) != nil }
    
    func removingLeadingSpaces() -> String
    {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}


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

//var globalEnvCons = [String:Double]()
var globalEnvCons = [String:Any]()

globalEnvCons["pi"] = { return Double.pi }()
globalEnvCons["#f"] = { return false }()
globalEnvCons["#t"] = { return true }()

/***************************/

let restrictedKW = ["begin", "define", "if", "cad", "cdr", "quote", "let"]

/***************************/

//func parse(_ input:String)->Any?
//{
//    //print("START: globalEnvCons:\(globalEnvCons)")
//
//    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
//    {
//        //TOKENIZE
//        var inputArray = input.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ").components(separatedBy: " ").filter{$0 != ""}//convert to array for easier operation
//
//
//        return readFromTokens(&inputArray)
//    }
//    return nil
//}

func parse(_ input:String)->Any?
{
    print("inputString at Start:\(input)")
    //print("START: globalEnvCons:\(globalEnvCons)")
    
    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
    {
        var inputString = input.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ")
        
        return readFromTokens(&inputString)
    }
    return nil
}



func readFromTokens(_ inputString: inout String)->Any?
{
    if(inputString.count != 0)
    {
        //print("inputString at start:\(inputString)")

        if inputString.hasPrefix(" ")
        {
            inputString = inputString.removingLeadingSpaces()
            //print("inputString after removing leading spaces:\(inputString)")
        }
        guard let spaceIndex = inputString.firstIndex(where: {$0 == " "}) else { return nil }

        let token = String(inputString.prefix(upTo: spaceIndex))
        print("token in readFromTokens:\(token)")
        
        inputString = String(inputString.suffix(from: spaceIndex))
        //print("inputString after removal of token:\(inputString)")
        
        if(token == "(")
        {
            var subArr = [Any]()
            
            while(!inputString.trimmingCharacters(in: .whitespaces).hasPrefix(")"))
            {
                subArr.append(readFromTokens(&inputString) as Any)
            }
            print("subArr after loop ends:\(subArr)")
            //arr.remove(at: 0) //remove ")"
            print("inputString:\(inputString)")
            
            inputString = String(inputString.removingLeadingSpaces().dropFirst())
            
            //inputString = String(inputString.dropFirst())   //remove ")"
            print("inputString after loop ends:\(inputString)")
            //return eval(subArr)
            return eval(&subArr)
        }
        else if(token == ")")
        {
            return nil
        }
        else
        {
            if token.isDouble
            {
                return Double(token)
            }
            else
            {
                if(token == "lambda")
                {
                    return lambdaParse(&inputString)
                }
                return token
            }
        }
    }
    return nil
}

//func readFromTokens(_ arr: inout [String])->Any?
//{
//    if(arr.count != 0)
//    {
//        let token = arr.remove(at: 0)
//        print("token in readFromTokens:\(token)")
//
//        if(token == "(")
//        {
//            var subArr = [Any]()
//            while(arr[0] != ")")
//            {
//                //print("Arr before readFromTokens:\(arr)")
//                subArr.append(readFromTokens(&arr) as Any)
//                //print("subArr before loop ends:\(subArr)")
//                //print("Arr after readFromTokens:\(arr)")
//            }
//            print("subArr after loop ends:\(subArr)")
//            arr.remove(at: 0) //remove ")"
//            return eval(subArr)
//        }
//        else if(token == ")")
//        {
//            return nil
//        }
//        else
//        {
//            if token.isDouble
//            {
//                return Double(token)
//            }
//            else
//            {
//                //                print("token:\(token)")
//                //                if(token == "define")
//                //                {
//                //                    print(arr)
//                //                    return defineParse(arr)
//                //                }
//                if(token == "lambda")
//                {
//                    //print("arr before lambdaParse:\(arr)")
//                    return lambdaParse(&arr)
//                }
//                return token
//            }
//        }
//    }
//    return nil
//}

//func eval(_ inputArr: [Any])->Any?
//func eval(_ arr: [Any])->Any?
func eval(_ arr: inout[Any])->Any?
{
    //print("eval: \(inputArr)")
    print("eval: \(arr)")

    //var arr = inputArr
    var operation = String()
    var arrArgs = [Double]()
    
    //for token in arr
    while arr.count > 0
    {
        let token = arr.remove(at: 0)
        print("token in eval:\(token)")
        
        if(token is String)
        {
            let key = token as! String
            
            if(key.hasPrefix("lambda"))
            {
                return(key)
            }
            
            if(key == "define")
            {
                return defineParse(arr)
            }
            
            if(key == "begin")
            {
                return arr.last
            }
            
            if(key == "if")
            {
                return ifParse(arr)
            }
            
            if(globalEnvFunc.keys.contains(key))
            {
                operation = key
                print("operation:\(operation)")
                continue
            }
            else if(globalEnvCons.keys.contains(key))
            {
                if let val = globalEnvCons[key] as? Double?
                {
                    print("Key as Double")
                    arrArgs.append(val!)
                    print("arrArgs:\(arrArgs)")
                    continue
                }
                else if var val = globalEnvCons[key] as? String?
                {
                    print(val as Any)

                    if((val?.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("lambda"))!)
                    {
                        print("Its LAMBDA evaluation")
                        
                        val  = String((val?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(6))!)//Remove "lambda" from the string
                        
                        print("val after removing lambda:\(val)")
                        
                        if((val?.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))!)
                        {
                            let tempIndex = val?.firstIndex(of:")")
                            
                            let paraString = val?.prefix(upTo: tempIndex!).trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(1)
                            
                            print("paraString:\(paraString)")
                            
                            val = String((val?.suffix(from: (val?.index(after: tempIndex!))!))!)
                            
                            print("val after paraString:\(val)")
                            
                            if let parameterArray = paraString?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                            {
                                print("parameterArray:\(parameterArray)")
                            
                                for i in 0..<parameterArray.count
                                {
                                    //globalEnvCons[parameterArray[i]] = arr[i+1]

                                    //globalEnvCons[parameterArray[i]] = arr.remove(at: i+1)
                                    globalEnvCons[parameterArray[i]] = arr.remove(at: i)
                                    print("arr after paramArray:\(arr)")
                                }
                                print("globalEnvCons:\(globalEnvCons)")
                            }
                        }
                    }
                    return(parse(val!))
                }
            }
        }
        else if(token is Double)
        {
            print("token is Double")
            arrArgs.append(token as! Double)
            continue
        }
    }
    if(!arrArgs.isEmpty && !operation.isEmpty)
    {
        print("calculation")
        return globalEnvFunc[operation]!(arrArgs)
    }
    return nil
}

func defineParse(_ arr: [Any])->Any?
{
    print("In defineParse: \(arr)")

    if(arr.count == 2)
    {
        if arr[1] is Double
        {
            globalEnvCons[arr[0] as! String] = arr[1] as? Double
            print(globalEnvCons)
        }
        else
        {
            globalEnvCons[arr[0] as! String] = arr[1] as? String
            print(globalEnvCons)
        }
        return arr[1]
    }
    print("Invalid Input")
    return nil
}

//func defineParse(_ arr: [Any])->Any?
//{
//    print("In defineParse: \(arr)")
//
//    if(arr.count == 3)
//    {
//        if arr[2] is Double
//        {
//            globalEnvCons[arr[1] as! String] = arr[2] as? Double
//            print(globalEnvCons)
//        }
//        else
//        {
//            globalEnvCons[arr[1] as! String] = arr[2] as? String
//            print(globalEnvCons)
//        }
//        return arr[2]
//    }
//    print("Invalid Input")
//    return nil
//}

//func ifParse(_ arr: [Any])->Any?
//{
//    print("In IFPARSE  arr: \(arr)")
//    if(arr.count >= 4)
//    {
//        if let testCase = arr[1] as? String, ["#f","null"].contains(testCase)
//        {
//            return arr[3]
//        }
//        if let testCase = arr[1] as? Bool, testCase == false
//        {
//            return arr[3]
//        }
//        else
//        {
//            return arr[2]
//        }
//    }
//    return nil
//}

func ifParse(_ arr: [Any])->Any?
{
    print("In IFPARSE  arr: \(arr)")
    if(arr.count >= 3)
    {
        if let testCase = arr[0] as? String, ["#f","null"].contains(testCase)
        {
            return arr[2]
        }
        if let testCase = arr[0] as? Bool, testCase == false
        {
            return arr[2]
        }
        else
        {
            return arr[1]
        }
    }
    return nil
}

func lambdaParse(_ inputString: inout String)->String?
{
    print("lambda parse inputString: \(inputString)")
    
    let openParenCount = inputString.filter({$0 == "("}).count
    //print("openParenCount: \(openParenCount)")
    
    let closeParenCount = inputString.filter({$0 == ")"}).count
    //print("closeParenCount: \(closeParenCount)")
    
    let parenDiff = closeParenCount - openParenCount
    //print("parenDiff:\(parenDiff)")
    var parenCounter = 0
    
    
    let reversedInput = String(inputString.reversed())
    //print("reversedInput:\(reversedInput)")
    
    for (index, char) in zip(reversedInput.indices, reversedInput)
    //for (index, char) in inputString.reversed().enumerated()
    {
        //print("char:\(char)")
        //print("index:\(index)")
        
        if(char == ")")
        {
            parenCounter += 1
            //print("parenCounter:\(parenCounter)")
        }
        if(parenCounter == parenDiff)
        {
            let exactIndex = reversedInput.index(after: index)
            
            let firstPart = String(reversedInput.prefix(upTo: exactIndex))
            let lastPart = String(reversedInput.suffix(from: exactIndex).reversed())

            print("firstPart:\(firstPart)")
            print("lastPart:\(lastPart)")
            
            inputString = firstPart
            //print("lambda"+lastPart)
            return("lambda"+lastPart)
        }
    }
    
    
    
    return nil
}

//func lambdaParse(_ arr: inout [String])->String?
//{
//    //print("lambda parse arr: \(arr)")
//
//    //removing the extra ")" in the end
//    let openParaCount = arr.filter({$0 == "("}).count
//    //print("openParaCount: \(openParaCount)")
//    let closeParaCount = arr.filter({$0 == ")"}).count
//    //print("closeParaCount: \(closeParaCount)")
//
//    //print(closeParaCount - openParaCount)
//
//    var counter = 0
//    if(closeParaCount > openParaCount)
//    {
//        for _ in 0..<closeParaCount - openParaCount
//        {
//            if(arr.last == ")")
//            {
//                arr.removeLast()
//                counter += 1
//            }
//        }
//
//        //Remove the foll. 5 lines
//        //        print("arr after removing ): \(arr)")
//        //        let openParaCount1 = arr.filter({$0 == "("}).count
//        //        print("openParaCount1: \(openParaCount1)")
//        //        let closeParaCount1 = arr.filter({$0 == ")"}).count
//        //        print("closeParaCount1: \(closeParaCount1)")
//    }
//    //print(arr.joined(separator: " "))
//
//    //Removing the initial (r)
//    if(arr.first == "(")
//    {
//        arr.remove(at: 0) //remove "("
//        if let tempIndex = arr.firstIndex(where: {$0 == ")"})
//        {
//            let tempPara = arr[0..<tempIndex].joined()
//            //let tempCon = tempPara.joined()
//            //print("tempPara:\(tempPara)")
//            //print(type(of: tempPara))
//
//            globalEnvCons[tempPara] = tempPara
//
//            arr.removeSubrange(0...tempIndex)
//            print("arr after removal: \(arr)")
//        }
//    }
//    let tempReturn = "lambda" + arr.joined(separator: " ")
//
//    //print("type of tempReturn:")
//    //print(type(of: tempReturn))
//    //let tempReturn:String = "lambda" + arr.joined(separator: " ")
//    //print("lambda" + arr.joined(separator: " "))
//
//    arr.removeAll()
//    for _ in 0...counter
//    {
//        arr.append(")")
//    }
//    return tempReturn
//}




//NOT WORKING

//parse("(define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))")
//parse("(fact 3)")

//WORKING

//let res12 = parse("( + (* 2 3)(+ 1 2) )")
//let res15 = parse("(> 45 5)")
//let res16 = parse("(<= 44 45)")
//let res17 = parse("(   sqrt  49)   ")
//let res18 = parse("(+ 10 (sqrt 100))")
//let res19 = parse("(+ (+ 4 5) (- 16 4))")
//let res20 = parse("(abs -10.5)")
//let res21 = parse("(!== 45 45.0)")
//let res143 = parse("(* pi 4 3)")
//let res1 = parse("(+ 1 2)")
//let res0 = parse("(define r 10)")
//let res01 = parse("(define plus +)")
//let res02 = parse("(define define +)")
//let res2 = parse("(begin (define r 10) (* pi (* r r)))")
//let res22 = parse("(if (> 10 20) (+ 1 1) (+ 3 3))")
//let res23 = parse("(+ (if (+ 1 1) 2 (+ 3 4)) 5)")
//let res24 = parse("(if (>= 3 7) 1 oops)")
//let res25 = parse("(if #t 1 0)")
//let res26 = parse("(begin (define x 12) (define y 1) (if (> x y) (+ (+ x y) (* x y)) (* x y)))")
//let res27 = parse("(begin (define x 1) (define x 12) (+ x x))")

//parse("(define circle-area (lambda (r) (* pi (* r r) ) ))")
//parse("(circle-area 10)")
//
//parse("(define circle-area (lambda (r) (* pi (* r r) ) ))")
//parse("(circle-area (* (+ 5 15) (- 14 10)))")
//
//parse("(define twice (lambda (x) (* 2 x)))")
//parse("(twice 15)")

