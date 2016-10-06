//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
//    var someDataStructure: [String] = [""]
    var nums : [String] = [""]
    var ops : [String] = []
    var ifDouble : Bool = false
    var nextNum : Bool = false
    var curr : String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
//        print("Update me like one of those PCs")
//        let offset2 = -(curr.characters.count - 1)
        if (content.characters.count > 7) {
            let index = content.index(curr.startIndex, offsetBy: 7)
            resultLabel.text = content.substring(to: index)
        } else {
            resultLabel.text = content
        }
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
//        return "0"
        let num1 = nums.popLast()
        let num2 = nums.popLast()
        let op = ops.popLast()
        let inta : Int = NSString(string: num1!).integerValue
        let intb : Int = NSString(string: num2!).integerValue
        if (op == "/" && ifDouble == false) {
            if intb % inta != 0 {
                ifDouble = true
            }
        }
        if (ifDouble) {
            let x = calculate(a: num1!, b: num2!, operation: op!)
            let res : String = String(x)
            nums.append(res)
            curr = res
            return res
        } else {
            let x = intCalculate(a: inta, b: intb, operation: op!)
            let res : String = String(x)
            nums.append(res)
            curr = res
            return res
        }
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        if operation == "*" {
            return a * b
        }
        if operation == "/" {
            return b / a
        }
        if operation == "+" {
            return a + b
        }
        if operation == "-" {
            return b - a
        }
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        let doublea : Double = NSString(string: a).doubleValue
        let doubleb : Double = NSString(string: b).doubleValue
        if operation == "*" {
            return doublea * doubleb
        }
        if operation == "/" {
            return doubleb / doublea
        }
        if operation == "+" {
            return doublea + doubleb
        }
        if operation == "-" {
            return doubleb - doublea
        }
        return 0.0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in!
        if (nextNum) {
            nums.append(sender.content)
            nextNum = false
        } else {
            if (nums[nums.count - 1] == "0") {
                nums[nums.count-1] = sender.content
            } else {
                nums[nums.count-1]+=(sender.content)
            }

        }
        curr = nums[nums.count-1]
        updateResultLabel(nums[nums.count-1])
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        print("The operator \(sender.content) was pressed")
        print("Current number of operators on stack is \(ops.count)")

        let others = ["C", "+/-", "%"]
        let x = sender.content
        
        if (others.contains(x)) {
            othersPressed(sender)
        }
        else if (sender.content == "=") {
            var res = curr
            while ops.count > 0 {
                res = calculate()
            }
            updateResultLabel(res)
        }
        else if (ops.count == 0) {
            ops.append(x)
        }
        else if (ops[ops.count-1] == "*" || ops[ops.count-1] == "/") {
            let res = calculate()
            nums.append(res)
            updateResultLabel(res)
            ops.append(x)
        }
        else {
            let res = calculate()
            curr = res
            updateResultLabel(res)
            ops.append(x)
        }
        nextNum = true
    }
    
    func othersPressed(_ sender: CustomButton) {
        if (sender.content == "C") {
            nums = [""]
            ops = []
            ifDouble = false
            nextNum = false
            updateResultLabel("0")
        } else if (sender.content == "+/-") {
            let offset = -(curr.characters.count - 1)
            let index1 = curr.index(curr.endIndex, offsetBy: offset)
            let sub = curr.substring(to: index1)
            if (sub != "-") {
                curr = "-" + curr
                nums[nums.count-1] = curr
                updateResultLabel(curr)
            } else {
                let offset2 = -(curr.characters.count - 1)
                let index2 = curr.index(curr.endIndex, offsetBy: offset2)
                curr = curr.substring(from: index2)
                nums[nums.count-1] = curr
                updateResultLabel(curr)
            }
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        print("buttom \(sender.content) is pressed")
        if (sender.content == ".") {
            ifDouble = true
            if (nextNum || nums.count == 1) {
                nums.append("0.")
            } else {
                nums[nums.count-1]+=(".")
            }
            nextNum = false
            curr = nums[nums.count-1]
            updateResultLabel(nums[nums.count-1])
        } else {
            if (!nextNum) {
                if (curr != "0") {
                    nums[nums.count-1]+=("0")
                    curr = nums[nums.count-1]
                    updateResultLabel(nums[nums.count-1])
                }
            } else {
                nums.append("0")
                curr = nums[nums.count-1]
                updateResultLabel(nums[nums.count-1])
                nextNum = true
            }
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

