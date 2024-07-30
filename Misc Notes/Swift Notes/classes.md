# Classes

The second way to create your own datatypes. The main difference, however, is inheritence, where classes can build on top of each other.

    class Dog {
        var name: String
        var breed: String

        init(name: String, breed: String) {
            self.name = name
            self.breed = breed
        }

        func makeNoise() {
            print("Woof!")
        }
    }

## Inheritence

    class Poodle: Dog {
        init(name: string) {
            super.init(name: name, breed: "Poodle)
        }
    }
- you always need to call super.init somewhere in a child class

### Override methods

If you want to override a method using a child class, you can add the override keyword

    class Poodle: Dog {
        override func makeNoise() {
            print("Yip!")
        }
    }

### Final classes.

If you don't want your class to be inheritable, just declare it as final

    final class Dog {

    }

## Copying Objects

When you copy a struct, the original and copy are different things. For classes, they point to the same object (changing one changes the other)

## Deinitializers

When a class is getting destroyed, you can add 

    deinit {
        # stuff
    }

Which will execute whenever an instance of a class is destroyed

## Mutability

Struct properties are immutable by default and can be mutated by adding the "mutable" keyword infront of methods. Class properties are immutable by default. 

If you want to make a property constant, you have to declare it as one (let).