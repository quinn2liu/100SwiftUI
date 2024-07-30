# iExpense

You can use @State with structs so that whenever a field inside of a struct is updated, then the view will update.

### Observable

However, if you want your views to update whenever a field inside your class updates, then you have to add `@Observable` before the class definition.

    @Observable 
    class User {
        var firstName = "Bilbo"
        var lastName = "Baggins"
    }

    struct ContentView: View {
        @State private var user = User()

        var body: some View {
            VStack {
                Text("Your name is \(user.firstName) \(user.lastName).")

                TextField("First name", text: $user.firstName)
                TextField("Last name", text: $user.lastName)
            }
        }
    }

"When working with structs, the @State property wrapper keeps a value alive and also watches it for changes. On the other hand, when working with classes, @State is just there for keeping object alive – all the watching for changes and updating the view is taken care of by @Observable."

### Sheets

Similar to alerts where you define the conditions for them to appear. They're like a view on top of another one.

    struct SecondView: View {
        var body: some View {
            Text("Second View")
        }
    }

    struct ContentView: View {
        @State private var showingSheet = false

        var body: some View {
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                // contents of the sheet
                SecondView()
            }
        }
    }

- Note that `@Observable` can be accessed across different SwiftUI views

### @Environment

`@Environment` let's us get tons of information about the user's shared environment. Here, it let's us just add a property to dismiss the view in the same way that it was presented.

    struct SecondView: View {
        @Environment(\.dismiss) var dismiss
        var body: some View {
            Button("Dismiss") {
                dismiss()
            }
        }
    }

    struct ContentView: View {
        @State private var showingSheet = false

        var body: some View {
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                // contents of the sheet
                SecondView()
            }
        }
    }

### onDelete()

`onDelete()` is most likely used to remove items from a list. 

    struct ContentView: View {
        @State private var numbers = [Int]()
        @State private var currentNumber = 1

        var body: some View {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                }

                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
        }
    }

Note, `onDelete()` only works on `forEach()` because only dynamic rows are deleteable. If we try to directly do the following, it wouldn't work

    List(numbers, id: \.self) {
        Text("Row \($0)")
    }

For `onDelete()` to work, we need a method that takes in an `indexSet` value, which tells us the position of an item to delete.

    struct ContentView: View {
        @State private var numbers = [Int]()
        @State private var currentNumber = 1

        var body: some View {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows) // this appears as a swiping delete.
                }

                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
        }

        func removeRows(at offsets: IndexSet) {
            numbers.remove(atOffsets: offsets)
        }

    }

If you want to have an edit button to be able to select multiple rows and delete them all at once. To do so, just put inside a navigation stack and add a special toolbar.

    struct ContentView: View {
        @State private var numbers = [Int]()
        @State private var currentNumber = 1

        var body: some View {
            NavigationStack {
                VStack {
                    List {
                        ForEach(numbers, id: \.self) {
                            Text("Row \($0)")
                        }
                        .onDelete(perform: removeRows) // this appears as a swiping delete.
                    }

                    Button("Add Number") {
                        numbers.append(currentNumber)
                        currentNumber += 1
                    }
                }
            }
            .toolbar {
                EditButton()
            }
            
        }

        func removeRows(at offsets: IndexSet) {
            numbers.remove(atOffsets: offsets)
        }

    }

### UserDefaults

If we want to save simple/small amount of user preferences, we can use `UserDefaults`. If we want to save tapCount, write to UserDefaults as well.

    struct ContentView: View {
        @State private var tapCount = UserDefaults.standard.Integer(forKey: "Tap")

        var body: some View {
            Button("Tap count: \(tapCount)") {
                tapCount += 1

                // "Tap" is the key with which we reference the variable.
                UserDefaults.standard.set(tapCount, forKey: "Tap")
            }
        }
    }

There are some issues with this though, for example default values when first launching the app can cause some confusion, and it takes some time for iOS to write data to permanent storage. One way to get around this for simple cases is `@AppStorage`, where we can declare a default value.

    struct ContentView: View {
        @AppStorage("tapCount") private var tapCount = 0

        var body: some View {
            Button("Tap count: \(tapCount)") {
                tapCount += 1
            }
        }
    }

`@AppStorage` handles the same functionality as UserDefaults, but doesn't work well if it's trying to do structs.

### @Codable

To store complex data like Swift types, we can use @Codable to archive custom types to UserDefaults and then unarchive it when it comes out of UserDefaults.

    struct User: Codable {
        let firstName: String
        let lastName: String
    }

Basically encodes your struct as JSON and then sends it back as JSON.

    struct ContentView: View {
        @State private var user = User(firstName: "Taylor", lastName: "Swift")

        var body: some View {
            Button("Save User") {
                let encoder = JSONEncoder()

                if let data = try? encoder.encode(user) {
                    UserDefaults.standard.set(data, forKey: "UserData")
                }
            }
        }
    }

So, we create a `JSONEncoder()` to be used to encode our data. 

`if let data = try? encoder.encode(user) { }` basically checks whether our user struct can be converted to JSON.

Then, if it can be encoded, we set the UserDefaults.

- Note: "data" is now of type "Data" -> `data: Data`

### Identifiable

Added as a protocol to a struct, but basically indicates to SwiftUI that the struct has some way to be uniquely identified. THE STRUCT HAS TO HAVE AN ID PROPERTY FOR THIS TO WORK.

    struct ExpenseItem: Identifiable {
        // i
        let id = UUID()
    }

This let's us then remove the `id:` from any foreach.

### Property Observer

In this example, we're using a custom initializer to load the `UserDefaults' stored data whenever the expenses() struct is initialzed/updated.

    struct ExpenseItem : Identifiable, Codable  {
        let id = UUID()
        let name: String
        let type: String
        let amount: Double
    }

    @Observable
    class Expenses {
        var items = [ExpenseItem]() {
            didSet {
                if let encoded = try? JSONEncoder().encode(items) {
                    UserDefaults.dtandard.set(encoded, forKey: "Items")
                }
            }
        }
    }

Here, `didSet` is attached to `items`, meaning that whenever `items` is modified, the `didSet` block will be triggered. 

