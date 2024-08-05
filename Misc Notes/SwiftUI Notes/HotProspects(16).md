# Hot Prospects

### Selecting Items in a List

Simple List:

    struct ContentView: View {

        @State private var selection: String?

        let users = ["Tohru", "Yuki", "Kyo", "Momiji"]

        var body: some view {
            List(users, id: \.self) { user in
                Text(user)
            }
        }
    }

To update the state whenever a row is tapped, we can change our list as so:

    List(users, id: \.self, seection: $selection) { user in
        Text(user)
    }

If we want to display, we can simply do 

    struct ContentView: View {

        @State private var selection: String?

        let users = ["Tohru", "Yuki", "Kyo", "Momiji"]

        var body: some view {
            List(users, id: \.self) { user in
                Text(user)
            }
            if let selection {
                Text("You selected \(selection)")
            }
        }
    }

If you want to select multiple rows, change selection to `@State private var selection = Set<String>()`. To view do something like 

    if selection.isEmpty == false {
        Text("You selected \selection.formatted()")
    }

- ^^ `formatted()` is called on the set to display them all as a string.

To enable multi-select mode, you can add an `EditButton()`. All you have to do is put it somewhere in the layout (most likely a `.toolbar()`)

### Creating Tabs with `TabView` and `tabItem()`

    struct ContentView: View {

        var body: some view {
            TabView {
                Text("Tab 1")
                Text("Tab 2")
            }
        }
    }

Here, your tabs aren't visible at all so you just have to guess. In this case, add `tabItem()` to a view to add some styling to the actual tab.

    TabView {
        Text("Tab 1")
            .tabItem {
                Label("One", systemImage: "star")
            }

        Text("Tab 2")
            .tabItem {
                Label("Two", systemImage: "circle")
            }
    }

So while users can control which tab they are on by tapping, you can programatically do this as well from 4 steps.

1. Create an `@State` property to track the tab that is currently showing.
2. Modify that property to a new value whenever we want to jump to a different tab.
3. Pass that as a binding into the `TabView`, so it will be tracked automatically.
4. Tell SwiftUI which tab should be shown for each value of that property.

So what does this look like?

    struct ContentView: View {
        
        
        @State private var selectedTab = "One" // step 1

        var body: some view {
            
            TabView(selection: $selectedTab) { // step 3

                Button("Show Tab 2") { // step 2
                    selectedTab = "Two"
                }
                .tabItem {
                    Label("One", systemImage: "star")
                }
                .tag("One") // step 4

                Text("Tab 2")
                    .tabItem {
                        Label("Two", systemImage: "circle")
                    }
                    .tag("Two")
            }
            
        }
    }

So note the code that says `selectedTab = "Two"`. With `TabView`, we simply define a `.tag()` to our views and that's what identifier for the selected tab.

So for the `Button` view, adding `.tag("One")` means that the Button's associated tab is `.tabItem { Label("One") }`. 

### The Result Type

Just like how optionals can either hold a value or nil, a Result either holds a value or an error.

Here's example of code that downloads an array of data from a server.

    struct ContentView: View {
        @State private var output = ""

        var body: some View {
            Text(output)
                .task {
                    await fetchReadings()
                }
        }

        func fetchReadings() async {
            do {
                let url = URL(string: "https://hws.dev/readings.json")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let readings = try JSONDecoder().decode([Double].self, from: data)
                output = "Found \(readings.count) readings"
            } catch {
                print("Download error")
            }
        }
    }

So what if we want to stash the work somewhere and do something else as it runs? Or read in the future? Or cancel it? We can use the `Task` API.

    func fetchReadings() async {
        let fetchTask = Task {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
    }

The return type of a `Task` is result, which can be fetched as so:

    let result = await fetchTask.result

To handle the errors from results, we can do this:

    do {
        output = try result.get()
    } catch {
        output = "Error: \(error.localizedDescription)"
    }

or

    switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = "Error: \(error.localizedDescription)"
    }

### Image Interpolation

When a SwiftUI `Image` stretches the contents to be larger than the original size? Image interpolation then blends pixels so it doesn't look stretched.

However, this causes an issue with precise pixels. If you want to turn this off, just do `.interpolation(.none)`

### Creating Context Menus

So when a user taps a button or nav link, SwiftUI triggers the default action. But what if you want something to occur with a press and hold? To do this, you can define a `.contextMenu()` modifier.

### Custom Row Options

Normally, the functionality for swiping on a row in a list is to delete an item. If you want to add custom functionality, you can use the `swipeActions()` modifier.

The code below displays a button on either side of a row in a list. The default is swiping right to left.

    List {
        Text("Taylor Swift")
            .swipeActions {
                Button("Delete", systemImage: "minus.circle", role: .destructive) {
                    print("Deleting")
                }
            }
            .swipeActions(edge: .leading) {
                Button("Pin", systemImage: "pin") {
                    print("Pinning")
                }
                .tint(.orange)
            }
    }

### Sending Local Notifications

First, you need to request permission for notifications, only then can you schedule them.

    VStack {
        Button("Request Permission") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error {
                    print(error.localizedDescription)
                }
            }
        }

        Button("Schedule Notification") {
            let content = UNMutableNotificationContent()
            content.title = "Feed the cat"
            content.subtitle = "It looks hungry"
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }

There are 3 main parts of a notification. 

1. Content: What is shown, can be a title, subtitle, audio, etc.
2. Trigger: Determines when notificaiton is shown
3. Request: combines content + trigger, but adds unique identifier so you can edit or remove specific alerts.

NOTE: THIS IS USEFUL FOR ASKING FOR CAMERA ACCESS

### Adding Swift package dependencies in Xcode

Swift Package Manager is Xcode's built in dependency manager. Google this if you need.

### `@Model` Review

Reminder that if you declare a class as `@Model` (which is used with SwiftData), then you can use the same instance of it across multiple views, similar to `@Observable`.

Then in your app file, you need to initialize a `modelContainer()` for your class so that all the views can use it.

### QR Code Scanning

QR codes come from `import CoreImage.CIFilterBuiltins`

Need to use disable image interpolation

    func generateQRCode(from string: String) -> UIImage
    {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

To scan, just use HackingWithSwift's QR code scanner; `github.com/twostraws/CodeScanner`
