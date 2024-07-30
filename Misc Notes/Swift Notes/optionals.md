# Optionals

In case you don't kwon the value of something, you can declare a type as optional (it could have a value or it could not)

    var age: Int? = nil

If we want to "unwrap" an optional to access its value, you can unwrap it.

Using if let:

    var name: String? = nil

    if let unwrapped = name {
        print (\(unwrapped.count))
    } else {
        print ("missing value")
    }

Using guard let:

    func greet(_ name: String?) {
        guard let unwrapped = name else {
            print("You didn't provide a name!")
            return
        }

        print("Hello, \(unwrapped)!")
    }

- ^^ MAIN DIFFERENCE is that you can still use the unrwapped value of the optional if you use guard.

## Force Unrwapping

If you want to use a value that is an optional that you KNOW isn't nil, you can force unrwap it using !

    let str = "5"
    let num = Int(str)!

- (if str isn't a number, this would crash, but assuming str is always a string representation of an Int you'll be okay)

## Implicitely Unwrapped Optionals

Optionals but you don't need to excplicitely unrwap them and can treat them as if they were never optional.

    let age: Int! = nil

If age is nil, your code will crash lol.

This is useful because a variable could be initialized as nil, but will be assigned a value before its used, so it'd be repetitive to write if let all the time.

## nil Coalescing

nil Coalescing is basically returning a default value instead of nil if nil is ever returned from something.

    func username(for id: Int) -> String? {
        if id == 1 {
            return "Taylor Swift"
        } else {
            return nil
        }
    }

    let user = username(for: 15) ?? "Anonymous"

## Optional Chaining

When executing a chain of code, you can check individual steps to see if they return nil to preemptively stop the operation. For example:

    let names = ["John", "Paul", "George", "Ringo"]

    let beatle = names.first?.uppercased()

If names is empty, then first() returns nil and the rest of the code chain isn't executed. If first returns a string, then the string will be uppercased.


## Optional Try

If you don't want to use do, try, and catch to handle errors, you can use try? to handle the error (using try?, errors are returned as nil).

    if let result = try? checkPassword("password") {
        print("Result was \(result)")
    } else {
        print("D'oh.")
    }

You can also force a function using try!

## Failable Initializer

    let str = "5"
    let num = Int(str)

In this example, num could fail if str isn't actuall a number. In your own structs you can account for something like this by adding a failable initializer:

    struct Person {
        var id: String

        init?(id: String) {
            if id.count == 9 {
                self.id = id
            } else {
                return nil
            }
        }
    }