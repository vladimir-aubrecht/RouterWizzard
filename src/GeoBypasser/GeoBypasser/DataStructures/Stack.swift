struct Stack {
    private var myArray: [String] = []
    
    mutating func push(_ element: String) {
        myArray.append(element)
    }
    
    mutating func pop() -> String? {
        return myArray.popLast()
    }
    
    func peek() -> String {
        guard let topElement = myArray.last else {return "This stack is empty."}
        return topElement
    }
}
