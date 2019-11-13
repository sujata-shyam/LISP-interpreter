import Foundation


extension Double
{
    func roundTo(places:Int) -> Double // for runding off to required precision
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String //Extension to down-cast
{
    var isInteger: Bool { return Int(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
}

/***************************/

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

/***************************/



func parse(_ input:String)->Any?
{
    if (input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))
    {
        //TOKENIZE
        var inputArray = input.replacingOccurrences(of: "(", with: " ( ").replacingOccurrences(of: ")", with: " ) ").components(separatedBy: " ").filter{$0 != ""}//convert to array for easier operation
        
        return readFromTokens(&inputArray)
    }
    return nil
}

//func readFromTokens(_ arr: inout [String])->Any?
//{
//    if(arr.count != 0)
//    {
//        let token = arr.remove(at: 0)
//
//        if(token == "(")
//        {
//            var subArr = [Any]()
//            while(arr[0] != ")")
//            {
//                subArr.append(readFromTokens(&arr) as Any)
//            }
//            arr.remove(at: 0) //remove ")"
//            return subArr
//        }
//        else if(token == ")")
//        {
//            return nil
//        }
//        else
//        {
//            if token.isInteger
//            {
//                return Int(token)
//            }
//            else if token.isDouble
//            {
//                return Double(token)
//            }
//            else
//            {
//                return token
//            }
//        }
//    }
//    return nil
//}

func readFromTokens(_ arr: inout [String])->Any?
{
    if(arr.count != 0)
    {
        let token = arr.remove(at: 0)
        
        if(token == "(")
        {
            var subArr = [Any]()
            while(arr[0] != ")")
            {
                subArr.append(readFromTokens(&arr) as Any)
            }
            arr.remove(at: 0) //remove ")"
        
            //print(subArr)
            //return subArr
            //print("eval:")
            //print(eval(subArr) as Any)
            return eval(subArr)
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
                return token
            }
        }
    }
    return nil
}

func eval(_ arr: [Any])->Any?
{
    print("eval: \(arr)")
    var operation = String()
    var arrArgs = [Double]()
    
    
    //for (index, token) in arr.enumerated()
    for token in arr
    {
        //print("token:\(token)")
        if(token is String)
        {
            let key = token as! String
            
            if(key == "define")
            {
                return defineParse(arr)
//                if(arr.count == 3)
//                {
//                    let newGlobalVar = arr[index+1] as! String
//                    print("newGlobalVar: \(newGlobalVar)")
//                    //let typeOfValue = type(of: arr[index+2])
//                    //let value = arr[index+2] as? typeOfValue
//
//                    if arr[index+2] is Double
//                    {
//                        globalEnvCons[newGlobalVar] = arr[index+2] as? Double
//                    }
//                    else
//                    {
//                        globalEnvCons[newGlobalVar] = arr[index+2] as? String
//                    }
//                    return arr[index+2]
//                }
            }
            
            if(key == "begin")
            {
                return arr.last
            }
            
            if(key == "if")
            {
                if(arr[1] == true)
                {
                    return
                }
            }
            
            if(globalEnvFunc.keys.contains(key))
            {
                operation = key
                //print("operation:\(operation)")
                continue
            }
            else if(globalEnvCons.keys.contains(key))
            {
                if let val = globalEnvCons[key] as! Double?
                {
                    arrArgs.append(val)
                    continue
                }
            }
        }
        else if(token is Double)
        {
            arrArgs.append(token as! Double)
            continue
        }
    }
    if(!arrArgs.isEmpty && !operation.isEmpty)
    {
//        print("arrArgs:\(arrArgs)")
//        print("operation:\(operation)")
        return globalEnvFunc[operation]!(arrArgs)
    }
    
    return nil
}

func defineParse(_ arr: [Any])->Any?
{
    if(arr.count == 3)
    {
        for _ in 0...3
        {
            let newGlobalVar = arr[1] as! String
            print("newGlobalVar: \(newGlobalVar)")
            
            if arr[2] is Double
            {
                globalEnvCons[newGlobalVar] = arr[2] as? Double
            }
            else
            {
                globalEnvCons[newGlobalVar] = arr[2] as? String
            }
            return arr[2]
        }
    }
    return nil
}

//func eval(_ exp:Any?) -> Any?
//{
//    if(exp is String)
//    {
//
//    }
//    else if(exp is Double || exp is Int)
//    {
//        return exp
//    }
//    else if()
//    {
//
//    }
//
//    return nil
//}

let res22 = parse("(if (> 10 20) (+ 1 1) (+ 3 3))")



//let res3 = parse("(define add4 (let ((x 4))(lambda (y) (+ x y))))")

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
//let res2 = parse("(begin (define r 10) (* pi (* r r)))")
