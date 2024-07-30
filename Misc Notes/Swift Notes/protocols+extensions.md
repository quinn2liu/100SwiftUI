# Protocols

Basically an interface with some special features. Describes what proprties and methods something has to have. 

    protocol Identifiable {
        var id: String { get set }
    }

Can't create instances of the protocol, but you can declare structs, classes, and enums to conform to it.

    struct User: Identifiable {
        var id: String
    }

this can also be useful to write general functions without specific structs or classes in mind

    func displayID(thing: Identifiable) {
        print("My ID is \(thing.id)")
    }

## Protocol Inheritence

While classes can only inherit 1 other class/protocol, protocols themselves can inherit from multiple other protocols.

    protocol Employee: Payable, NeedsTraining, HasVacation { 
        # stuff
    }

# Extensions

Allows you to add methods to existing types

BUT you can't have stored values and have to use computed properties.

    extension Int {
        func squared() -> Int {
            return self * self
        }

        var isEven: Bool {
            return self % 2 == 0
        }
    }

You can add extensions to protocols as well so that all of that protocol's descendents get that change.

    extension Collection {
        func summarize() {
            print("There are \(count) of us:")

            for name in self {
                print(name)
            }
        }
    }

Note that protocols only declare functions and don't write code for them. A common practice then is to write default versions of the declared function for all instances of the protocol when it makes sense.

    protocol Identifiable {
        var id: String { get set }
        func identify()
    }

    extension Identifiable {
        func identify() {
            print("My ID is \(id).")
        }
    }