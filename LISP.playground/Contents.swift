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
globalEnvCons["#f"] = { return false }()
globalEnvCons["#t"] = { return true }()

/***************************/

let restrictedKW = ["begin", "define", "if", "cad", "cdr", "quote", "let"]
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
            //print("token:\(token)")

            var subArr = [Any]()
            while(arr[0] != ")")
            {
                subArr.append(readFromTokens(&arr) as Any)
            }
            //print("subArr:\(subArr)")
            arr.remove(at: 0) //remove ")"
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
                
                /******** NEW CODE 14/11/2019 ************/
                
                print("token:\(token)")
                if(token == "lambda")
                {
                    print(arr)
                }
                
                /*****************************************/

                
                
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
                print(arr)
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
        return globalEnvFunc[operation]!(arrArgs)
    }
    
    return nil
}

func defineParse(_ arr: [Any])->Any?
{
    if(arr.count == 3 && !restrictedKW.contains(arr[1] as! String))
    {
        if arr[2] is Double
        {
            globalEnvCons[arr[1] as! String] = arr[2] as? Double
        }
        else
        {
            globalEnvCons[arr[1] as! String] = arr[2] as? String
        }
        return arr[2]
    }
    print("Invalid Input")
    return nil
}

func ifParse(_ arr: [Any])->Any?
{
    if(arr.count >= 4)
    {
        if let testCase = arr[1] as? String, ["#f","null"].contains(testCase)
        {
            return arr[3]
        }
        if let testCase = arr[1] as? Bool, testCase == false
        {
            return arr[3]
        }
        else
        {
            return arr[2]
        }
    }
    return nil
}

func lambdaParse(_ arr: [Any])->Any?
{
    if(arr.count >= 4)
    {
        
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

//TESTING
let res30 = parse("(lambda (x) (+ (* 2 x) (+ 2 x)))")
["(", "x", ")", "(", "+", "(", "*", "2", "x", ")", "(", "+", "2", "x", ")", ")", ")"]

//let res31 = parse("(define circle-area (lambda (r) (* pi (* r r) ) ))")
//  ["(", "r", ")", "(", "*", "pi", "(", "*", "r", "r", ")", ")", ")", ")"]

//let res31 = parse("(define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))")
//["(", "n", ")", "(", "if", "(", "<=", "n", "1", ")", "1", "(", "*", "n", "(", "fact", "(", "-", "n", "1", ")", ")", ")", ")", ")", ")"]

let res31 = parse("(define twice (lambda (x) (* 2 x)))")
//["(", "x", ")", "(", "*", "2", "x", ")", ")", ")"]

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
//let res25 = parse("(begin (define x 12) (define y 1) (if (> x y) (+ (+ x y) (* x y)) (* x y)))")
//let res25 = parse("(begin (define x 12) (define x 1) (+ x x))")


