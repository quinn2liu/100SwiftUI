# Bookworm

Some Review:

So currently, we have `@State` which let's us refresh a view whenever the value is refreshed, and `@Bindable`, which lets us create a binding to mutable properties of an `@Observable` class object.

`@Observable` is given to a class so that whenever one of its properties is changed, any view using that class will be updated accordingly.

If, however, you want to update a value inside of that class from a different view, you can use `@Bindable`. `@Bindable` is given to a property (could be a class itself) to basically say: "this is not the original `@Observable` class, but rather a binding to it that we can write back to."

Effectivly, `@Bindable` let's us update an instance of an `@Observable` class from outside of the original view it's declared in.

### `@Binding`

`@Binding` is the same thing as `@Bindable`, but instead of binding a class across views, you're simply just binding a single value (Bindable = class, Binding = value).

Here's an example view where we want to pass in a pre-existing value to be the state of our special button:

    struct PushButton: View {
        let title: String
        @Binding var isOn: Bool

        var onColors = [Color.red, Color.yellow]
        var offColors = [Color(white: 0.6), Color(white: 0.4)]

        var body: some View {
            Button(title) {
                isOn.toggle()
            }
            .padding()
            .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
            .foregroundStyle(.white)
            .clipShape(.capsule)
            .shadow(radius: isOn ? 0 : 5)
        }
    }

Here, if the preview doesn't work, we can pass in a constant for the binding: `.constant()`

And then when we call this button, we must pass in a BINDING to it ($rememberMe)

    struct ContentView: View {
        @State private var rememberMe = false

        var body: some View {
            VStack {
                PushButton(title: "Remember Me", isOn: #rememberMe)
                Text(rememberMe ? "On" : "Off")
            }
        }
    }


### TextEditor

If you want to users to be able to edit a region, they can use a `TextEditor()`

Another option is `TextField()` but with a specified axis.

    TextField("enter your text", text: $text, axis: .vertical)

### SwiftData

An easy way to read and write data to the device's permanent storage.

The only difference here is to wrap the class with @Model instead of @Observable. Now SwiftData can save and load students.

    @Model
    class Student {
        var id: UUID
        var name: String

        init(id: UUID, name: String) {
            self.id = id
            self.name = name
        }
    }

Then, in your `App` file, you need to import SwiftData and add .modelContainer

    import SwiftData
    import SwiftUI

    @main
    struct BookwormApp: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .modelContainer(for: Student.self)
        }
    }

`Model Containers` are where Swift stores the data. However, the "live" version of data (like in RAM), is stored in a `Model Context`, which is automatically created via the model container.

Now to query for students, we can add `@Query` to students and get the environment's context. To insert, we just insert a student in to the modelContext. 

    struct ContentView: View {
        @Environment(\.modelContext) var modelContext
        @Query var students: [Student]

        var body: some view {
            NavigationStack {
                List(students) { student in 
                    Text(student.name)
                }
                Button("Add student") {
                    let student = Student(id: UUID(), name: "test name")
                    modelContext.insert(student)
                }
            }
        }
    }

### Whole Row Tapping

Let's say that you have a custom view, in our case `RatingView()`, that has multiple tappable elements. If this is inside of a form and you click the row, by default the entire row is tappable, meaning that all the buttons in `RatingView()` are tapped at once.

To get around this, specify in `RatingView()` that `.buttonStyle(.plain)`