# Swift Notes

### Ranges

- ... is inclusive operator

- ..< is a noninclusive operator

    let score = 85
    switch score {
    case 0..<50:
        print("You failed badly.")
    case 50...85:
        print("You did OK.")
    default:
        print("You did great!")
    }

^^ this prints "You did OK."

You can declare variables as a range

        let count = 1...10

### for loops

Takes the form of a foreach loop (can mimic traditional for loop using a range)

### repeat loops

Like a while loop, but the check condition occurs at the end of the loop

    var number = 1

    repeat {
            print(number)
            number += 1
    } while number <= 20

### Breaking out of multiple loops

if we have nested for loops and we want to break out of both while in th einner loop, we can name the outerloop and then specify that we want to break out of that one:

    outerLoop: for i in 1...10 {
        for j in 1...10 {
            let product = i * j
            if product == 50 {
                break outerLoop
            }
        }
    }

### Continue

If we want to skip an iteration of a loop, just add "continue" inside of the block.

### Functions

Declared using "func"

    func square(number: Int) -> Int {
        return number * number
    }

### String formulation

If you want to use a variable inside of a string, can be formatted like this:

    print("Hello, \(person)")

### Default parameters

You can assign a default value to a parameter if none is provited in the function call. (In this example 'nicely' is the parameter in question).

    func greet(_ person: String, nicely: Bool = true) {
        if nicely == true {
            print("Hello, \(person)!")
        } else {
            print("Oh no, it's \(person) again...")
        }
    }

### Variadic Functions

Can receive any number of parameters.

    func square(numbers: Int...) {
        for number in numbers {
            print("\(number) squared is \(number * number)")
        }
    }

### Throwing errors

If you have a function that can "throw" something, then you always need to put it in a do block.

    do {
        try checkPassword("password") 
        print("That password is good!")
    } catch {
        print("You can't use that password.")
    }

### inout parameters

Parameters are constants (can't be changed in a function) but if you want it to be changed, then use an inout.

    func doubleInPlace(number: inout Int) {
        number *= 2
    }
    var myNum = 10 
    doubleInPlace(number: &myNum)

