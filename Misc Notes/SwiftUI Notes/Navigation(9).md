# Navigation

When using `NavigationLink()`, there are some issues that arise. Specifically, the issue is that it will load the destination view's data right when the app is opened.

This is find for small, static data, but dynamic data will cause a bunch of issues.

### `navigationDestination()`

It's best practice to separate the value of a `navigationLink()` from the eventual destination view. To do this, we can specify a `navigationDestination()`

    NavigationStack {
        List(0..<100) { i in
            NavigationLink("Select \(i)", value: i)
        }
        .navigationDestination(for: Int.self) { selection in
            Text("You selected \(selection)")
        }
    }

This means that for every time the list is asked to navigate to an Int value, display the view specified in the `navigationDestination()`

### Hashable

Haashing is nice because it basically let's us use `.navigationDestination()` with custom types. 

    struct Student: Hashable {
        var id = UUID()
        var name: String
        var age: Int
    }

    NavigationStack {
        List(0..<100) { i in
            NavigationLink("Select \(i)", value: i)
        }
        .navigationDestination(for: Student.self) { student in
            Text("You selected \(student.name)")
        }
    }

^^ this isn't right but I don't really want to fix it

### Programatic Navigation

What happens when we want to navigate to a new view programatically instead of when the user specifies?

You can use a two-way binding like so:

    struct ContentView: View {
        @State private var path = [Int]()

        var body: some View {
            NavigationStack(path: $path) {
                VStack {
                    Button("Show 32") {
                        path = [32]
                    }

                    Button("Show 64") {
                        path.append(64)
                    }
                }
                .navigationDestination(for: Int.self) { selection in
                    Text("You selected \(selection)")
                }
            }
        }
    }

This means that a view will be generated every time the path array is updated.

### `NavigationPath()`

If we want to navigate to different datatypes with NavigationStack, we need to use `NavigationPath()`

    @State private var path = NavigationPath()

    NavigationStack(path: $path) {
        List {
            ForEach(0..<5) { i in
                NavigationLink("Select Number: \(i)", value: i)
            }

            ForEach(0..<5) { i in
                NavigationLink("Select String: \(i)", value: String(i))
            }
        }
        .toolbar {
            Button("Push 556") {
                path.append(556)
            }

            Button("Push Hello") {
                path.append("Hello")
            }
        }
        .navigationDestination(for: Int.self) { selection in
            Text("You selected the number \(selection)")
        }
        .navigationDestination(for: String.self) { selection in
            Text("You selected the string \(selection)")
        }
    }

Here, the toolbar buttons append different types to the `navigationPath()`. Depending on which type is being pushed, the corresponding `navigationDestination()` is triggered.

### `@Binding`

Here's an example of a continuously-generating navigation path:

    struct DetailView: View {
        var number: Int

        var body: some View {
            NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
                .navigationTitle("Number: \(number)")
        }
    }

    struct ContentView: View {
        @State private var path = [Int]()

        var body: some View {
            NavigationStack(path: $path) {
                DetailView(number: 0)
                    .navigationDestination(for: Int.self) { i in
                        DetailView(number: i)
                    }
            }
        }
    }

Above, what's happening is that whenever DetailView is pressed, a `NavigationLink()` is pushed onto the path array as that's what the `navigationDestination()` is looking for.

`@Binding` let's us pass `@State`-tracked values betweeen different views. In our example above, this let's us clear the navigation path to reset the view. 

    struct DetailView: View {
        var number: Int
        @Binding var path: [Int]

        var body: some View {
            NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
                .navigationTitle("Number: \(number)")
                .toolbar {
                    Button("Home") {
                        path.removeAll()
                    }
                }
        }
    }

    struct ContentView: View {
        @State private var path = [Int]()

        var body: some View {
            NavigationStack(path: $path) {
                DetailView(number: 0, path: $path)
                    .navigationDestination(for: Int.self) { i in
                        DetailView(number: i, path: $path)
                    }
            }
        }
    }

If you instead used `NavigationPath()` instead of `path = [Int]()`, the changes are 

    @State private var path = NavigationPath()

and then in `DetailView`

    Button("Home") {
        path = NavigationPath()
    }

### Saving NavigationStack paths using Codable

If you want to save the path of your navigation stack, there are 2 ways to do it.

1. If you are storing it as an array of integers.

        @Observable
        class PathStore {
            var path: [Int] {
                didSet {
                    save()
                }
            }

            private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

            init() {
                if let data = try? Data(contentsOf: savePath) {
                    if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
                        path = decoded
                        return
                    }
                }

                // Still here? Start with an empty path.
                path = []
            }

            func save() {
                do {
                    let data = try JSONEncoder().encode(path)
                    try data.write(to: savePath)
                } catch {
                    print("Failed to save navigation data")
                }
            }
        }

    This basically means that whenever the path array is set, we save the path. The custom initializer tries to read the path Data from our document library, and then initializes an empty path if it can't find one.

2. NavigationPath

        @Observable
        class PathStore {
            var path: NavigationPath {
                didSet {
                    save()
                }
            }

            private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

            init() {
                if let data = try? Data(contentsOf: savePath) {
                    if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                        path = NavigationPath(decoded)
                        return
                    }
                }

                // Still here? Start with an empty path.
                path = NavigationPath()
            }

            func save() {

                guard let representation = path.codable else { return }

                do {
                    let data = try JSONEncoder().encode(path)
                    try data.write(to: savePath)
                } catch {
                    print("Failed to save navigation data")
                }
            }
        }

    Note here that we change the type of the path to be `NavigationPath()` and then when decoding, we try to specify the decoded type as `NavigationPath.CodableRepresentation.self`

    Lastly, you need to check whether the `NavigationPath` you are using is codable or not in the save method. `NavigationPath` doesn't conform to codable, so if any of the path items also doesn't conform to codable, it won't work. so note the `guard let representation = path.codable` line. 

### Customizing Navigation Bar

SwiftUI gives minimal customizations for navigation bars

`navigationBarTitleDisplayMode()` -> changes the type of the nav bar

`toolbarBackground()` -> changes the background

If you want to place buttons inside the navigation stack toolbar so that it isn't the default configuration, you can wrap buttons in `ToolbarItem()` along with `ToolbarItemGroup()`

If you want the user to be able to rename the navigation title, you can simply define `navigationBarTitleDisplayMode(.inline)`, and set `navigatoinTitle($title)`

