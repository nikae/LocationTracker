let crypt =
["AA",
"AA",
"AA"]
let solution: [[Character]] =
[["A","0"]]

//word1 + word2 = word3

func isCryptSolution(crypt: [String], solution: [[Character]]) -> Bool {
    var arr: [Int] = []

    for string in crypt {
         print("S0:-----------------------------")
        var t: String = ""
        for i in string {
            for b in solution {
                if b.contains(i) {
                    t.append(String(b[1]))
                    print("S1 \(t)")
                }
            }
        }

        if t.count > 1 && t.first == "0" {
            return false
        }

        if let intt = Int(t) {
            arr.append(intt)
            print("S2 \(arr)")
        }
    }

    return arr[0] + arr[1] == arr[2]
}

isCryptSolution(crypt: crypt, solution: solution)
