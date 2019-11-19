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

var globalEnvCons = [String:Any]()

globalEnvCons["pi"] = { return Double.pi }()
globalEnvCons["#f"] = { return false }()
globalEnvCons["#t"] = { return true }()


func parse(_ input:String)->Any?
{
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
        if inputString.hasPrefix(" ")
        {
            inputString = inputString.removingLeadingSpaces()
        }
        guard let spaceIndex = inputString.firstIndex(where: {$0 == " "}) else { return nil }

        let token = String(inputString.prefix(upTo: spaceIndex))
        
        inputString = String(inputString.suffix(from: spaceIndex))
        
        if(token == "(")
        {
            var subArr = [Any]()
            
            while(!inputString.trimmingCharacters(in: .whitespaces).hasPrefix(")"))
            {
                subArr.append(readFromTokens(&inputString) as Any)
            }
            inputString = String(inputString.removingLeadingSpaces().dropFirst())
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

func eval(_ arr: inout[Any])->Any?
{
    var operation = String()
    var arrArgs = [Double]()
    
    while arr.count > 0
    {
        let token = arr.remove(at: 0)
        
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
                continue
            }
            else if(globalEnvCons.keys.contains(key))
            {
                if let val = globalEnvCons[key] as? Double?
                {
                    arrArgs.append(val!)
                    continue
                }
                else if var val = globalEnvCons[key] as? String?
                {
                    if((val?.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("lambda"))!)
                    {
                        val  = String((val?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(6))!)//Remove "lambda" from the string
                        
                        if((val?.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("("))!)
                        {
                            let tempIndex = val?.firstIndex(of:")")
                            
                            let paraString = val?.prefix(upTo: tempIndex!).trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(1)
                            
                            val = String((val?.suffix(from: (val?.index(after: tempIndex!))!))!)
                            
                            if let parameterArray = paraString?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                            {
                                for i in 0..<parameterArray.count
                                {
                                    globalEnvCons[parameterArray[i]] = arr.remove(at: i)
                                }
                            }
                        }
                    }
                    return(parse(val!))
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
    if(arr.count == 2)
    {
        if arr[1] is Double
        {
            globalEnvCons[arr[0] as! String] = arr[1] as? Double
        }
        else
        {
            globalEnvCons[arr[0] as! String] = arr[1] as? String
        }
        return arr[1]
    }
    print("Invalid Input")
    return nil
}

func ifParse(_ arr: [Any])->Any?
{
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
    let parenDiff = inputString.filter({$0 == ")"}).count - inputString.filter({$0 == "("}).count
    var parenCounter = 0
    let reversedInput = String(inputString.reversed())
    
    for (index, char) in zip(reversedInput.indices, reversedInput)
    {
        if(char == ")")
        {
            parenCounter += 1
        }
        if(parenCounter == parenDiff)
        {
            let exactIndex = reversedInput.index(after: index)
            
            let firstPart = String(reversedInput.prefix(upTo: exactIndex))
            let lastPart = String(reversedInput.suffix(from: exactIndex).reversed())
            inputString = firstPart
            return("lambda"+lastPart)
        }
    }
    return nil
}

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
//
//parse("(define circle-area (lambda (r) (* pi (* r r) ) ))")
//parse("(circle-area 10)")

//parse("(define circle-area (lambda (r) (* pi (* r r) ) ))")
//parse("(circle-area (* (+ 5 15) (- 14 10)))")
//
//parse("(define twice (lambda (x) (* 2 x)))")
//parse("(twice 15)")

