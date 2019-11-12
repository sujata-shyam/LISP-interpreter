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

var globalEnvCons = [String:Double]()

globalEnvCons["pi"] = { return Double.pi }()

/***************************/

//indirect enum Exp
//{
//    case Symbol(String)
//    case Number(Double)
//    case Arr([Exp])
//
//    func getSymbolValue() -> String? {
//        switch self {
//        case .Symbol(let str):
//            return str
//        default:
//            return nil
//        }
//    }
//    func getNumberValue() -> Double? {
//        switch self {
//        case .Number(let num):
//            return num
//        default:
//            return nil
//        }
//    }
//    func getArray() -> [Exp]? {
//        switch self {
//        case .Arr(let arr):
//            return arr
//        default:
//            return nil
//        }
//    }
//}


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
            print(eval(subArr) as Any)
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
    print(arr)
    var operation = String()
    var arrArgs = [Double]()
    
    for token in arr
    {
        print("token:\(token)")
        if(token is String)
        {
            let key = token as! String
            if(globalEnvFunc.keys.contains(key))
            {
                operation = key
                print("operation:\(operation)")
                continue
            }
            else if(globalEnvCons.keys.contains(key))
            {
                if let val = globalEnvCons[key]
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
        print("arrArgs:\(arrArgs)")
        print("operation:\(operation)")
        return globalEnvFunc[operation]!(arrArgs)
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

//let res0 = parse("(define r 10)")
//let res1 = eval(parse("( + (* 2 3)(+ 1 2) )") as! [Any])
//let res1 = eval(parse("(+ 1 2)"))
let res12 = parse("( + (* 2 3)(+ 1 2) )")
//let res2 = parse("(begin (define r 10) (* pi (* r r)))")
//let res3 = parse("(* pi (* r r))")

//let res15 = parse("(> 45 5)")
//let res16 = parse("(<= 44 45)")
//let res17 = parse("(   sqrt  49)   ")
//let res18 = parse("(+ 10 (sqrt 100))")
//let res19 = parse("(+ (+ 4 5) (- 16 4))")
//let res20 = parse("(abs -10.5)")
//let res21 = parse("(!== 45 45.0)")
