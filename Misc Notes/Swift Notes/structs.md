# Structs

One of 2 ways to declare your own types. Defined as such:

    struct Sport {
        var name: String
        var isOlympicSport: Bool

        var olympicStatus: String {
            if isOlympicSport {
                return "\(name) is an Olympic sport"
            } else {
                return "\(name) is not an Olympic sport"
            }
        }
    }

- name is a stored property 

- olympicStatus is a computed property, letting us return different values based on the value of others

### Property observers

If you want a block of code to execute whenever a property changes, we can use a property observer. One example is "didSet"

    struct Progress {
        var task: String
        var amount: Int {
            didSet {
                print("\(task) is now \(amount)% complete")
            }
        }
    }

- The print statement will execute whenever amount is changed.

### Mustating Methods

By default, functions in structs won't let you chaneg the values of proprties. If you want a struct function to be able to change that struct's value, make the function mutating.

    struct Person {
        var name: String

        mutating func makeAnonymous() {
            name = "Anonymous"
        }
    }

### Struct Initializers

Basically a constructor for a struct.

    struct User {
        var name: String

        init(name: String) {
            self.name = name
        }
    }

- notice the "self" keyword, meaning that you're referencing the struct's value


### Lazy Properties

To optimize performance, you can create lazy properties, which are only created when first accessed.

    struct Person {
        var name: String
        lazy var familyTree = FamilyTree()

        init(name: String) {
            self.name = name
        }
    }

    person.familyTree

- person.familyTree is only created when it's called

### Static Properties/Methods

If we want certain properties to be shared between different instances of a struct, then we can use the static keyword.

    struct Student {
        static var classSize = 0
        var name: String

        init(name: String) {
            self.name = name
            Student.classSize += 1
        }
    }

    print(Student.classSize)

- since classSize is static and belonging to the whole Student struct, we need to reference it using Student instead of the specific instance.

