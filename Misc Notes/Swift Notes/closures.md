# Closures

You can create a function and use it as if it were a type, this is called a closure.

    let driving = { (place: String) in
        print("I'm driving to \(place).")
    }

You can also call driving as a regular function (and get a return value).

    driving("London")

You can also pass in closures as a parameter to another function.

    let driving = {
        print("I'm driving in my car")
    }

    func travel(action: () -> Void) {
        print("I'm getting ready to go.")
        action()
        print("I arrived!")
    }

    travel(action: driving)

### Trailing Closure

If a closure is the last parameter to a function, you don't need to pass it as a parameter but rather you can put it inside of brackets trailing the funciton. See above for context

    travel() {
        print("I'm driving in my car")
    }

### Closures with parameters and returns

() -> Void means that the closure accepts no parameters. This can be updated like the following:  

    func travel(action: (String) -> Void) {
        print("I'm getting ready to go.")
        action("London")
        print("I arrived!")
    }

So, whenever travel is called with a closure inside of it, the closure must accept a string and will act upon that string.

    travel { (place: String) in
        print("I'm going to \(place) in my car")
    }

Output: 

    I'm getting ready to go.
    I'm going to London in my car
    I arrived!

You can also update "Void" to be a type, meaning that the closure that you pass into the function must also return a value.

    func travel(action: (String) -> String) {
        print("I'm getting ready to go.")
        let description = action("London")
        print(description)
        print("I arrived!")
    }

    travel { (place: String) -> String in
        return "I'm going to \(place) in my car"
    }

All of this can also be simplified to:

    travel { place in
        return "I'm going to \(place) in my car"
    }

If you want to pass multiple parameters, you can just add with a comma separation.

    func travel (action: (String, Int) -> String) {
        let description = action ("London", 60);
    }

    travel {
        "I'm going to \(place) at \(speed) miles per hour."
    }

### Returning Closures

You can also return closures from a function. Ex:

    func travel() -> (String) -> Void {
        return {
            print("I'm going to \($0)")
        }
    }

    let result = travel()
    result("London")

(result has the value of a function, so you can now call it as if it were one.)

### Capturing values in closures

If you function that accepts a closure creates values that are then used in the closure, then Swift will track that variable along with the closure.

    func travel() -> (String) -> Void {
        var counter = 1

        return {
            print("\(counter). I'm going to \($0)")
            counter += 1
        }
    }

    result("London")
    result("London")
    result("London")

