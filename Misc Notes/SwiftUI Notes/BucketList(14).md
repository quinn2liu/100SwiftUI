# BucketList

### @Comparable for Custom Types

We expect Swift to be able to sort things like arrays out of the box.

When you declare a custom type, however, this ends up not working. This is because you need to extend the @Comparable protocol to work with whatever custom types since it's not extended by default.

    struct User: Identifiable {
        let id = UUID()
        var firstName: String
        var lastName: String
    }

There are two ways to do this:

1. Given two arbitrary values, define the parameters for one value to come befor the other (not ideal)

- `$0` comes before `$1` when `.sorted { $0.lastname < $1.lastname }` 

- ^^ this isn't good because you have to copy it all the time

2. Make the type conform to compareable. To do this, you need to add a `static` method called `<` that takes in two `User` and returns true if the frist should be sorted by the second.

        struct User: Identifiable, Comparable {
            let id = UUID()
            var firstName: String
            var lastName: String

            static func <(lhs: User, rhs: User) -> Bool {
                lhs.lastName < rhs.lastName
            }
        }

^^ lhs goes before rhs when `lhs.lastName` is < `rhs.lastname`

### Writing Data to a File

Before, we wrote small data to `UserDefaults` which is great fro user settings or JSON. We also used `SwiftData`, which is great for modeling and persisting data to be stored locally on the device.

A middle ground for both of those is just writing to a file directly.

iOS apps are sandboxed, meaning that they are ran in their own container and have a hard-to-guess directory name. Instead we use a special URL to get to our directory, `URL.documentsDirectory`

To read data we've already used `String(contentsOf:)` and `Data(contentsOf:)`. To write data, we use `write(to:)`

### `write(to:)`

Takes in 2 parameters, `URL` to write to, and any additional settings. It's a good idea to pass in `.atomic` and `.completeFileProtection`

- `.atomic` turns data writing into an atomic operation so that it can't be interrupted.

- `.completeFileProtection` encrypts the file and it can only be unread when the device is unlocked.

    Button("Read and Write") {
        let data = Data("Test Message".utf8)
        let url = URL.documentsDirectory.appending(path: "message.txt")

        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }

### Switching View States with Enums

In the past, you can use a bool to change a view state like so:

    if Bool.random() {
        Rectangle()
    } else {
        Circle()
    }

Remember that when returning differnt kinds of a view, you want to be inside of the body property or using something like @ViewBuilder or Group to make sure all cases are handled.

To do this with an enum, you first need to make the enum and define the different states of the view:

    enum LoadingState {
        case loading, success, failed
    }

And then the actual views

    struct LoadingView: View {
        var body: some View {
            Text("Loading...")
        }
    }

    struct SuccessView: View {
        var body: some View {
            Text("Success!")
        }
    }

    struct FailedView: View {
        var body: some View {
            Text("Failed.")
        }
    }

Now inside `ContentView`, you can define the enum with a default value and inside of `body`, you can do something like this:

    @State private var loadingState = LoadingState.loading

    if loadingState == .loading {
        LoadingView()
    } else if loadingState == .success {
        SuccessView()
    } else if loadingState == .failed {
        FailedView()
    }

Or a switch block (which is better bc Swift checks it and can throw useful errors)

    switch loadingState {
    case .loading:
        LoadingView()
    case .success:
        SuccessView()
    case .failed:
        FailedView()
    }

### Adding Maps to SwiftUI

    import MapKit

Inside a view:

    Map()

There are a bunch of modifiers like such:

- `.mapStyle()` let's you do satellite or street view

- `Map(interactionModes: [.rotate, .zoom])` means that the position is fixed but users can rotate or zoom.

If we want to set a starting position it's a bit more involved. Let's say we want to set a constant location of London:

    let position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )

That can now be used in the `Map()`

    Map(initialPosition: position)

If you want to change the position over time, you can add `@State` to programatically change the location.

    HStack(spacing: 50) {
        Button("Paris") {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        }

        Button("Tokyo") {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        }
    }

We won't be able to read the new `Map()` location instantly though. Instead, we need to add `.onMapCameraChange()`. This can be configured to either act when the movement has finished or continuously.

    Map(position: $position)
        .onMapCameraChange { context in
            print(context.region)
        }

    Map(position: $position)
        .onMapCameraChange(frequency: .continuous) { context in
            print(context.region)
        }
    
If you want to add annotations to the map, a simple way is to define a `Location` data type, create an array of them, and then adding them to the map. `Location` must conform to `Identifiable`.

    struct Location: Identifiable {
        let id = UUID()
        var name: String
        var coordinate: CLLocationCoordinate2D
    }

    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

If we want to use the default marker, do this

    Map {
        ForEach(locations) { location in
            Marker(location.name, coordinate: location.coordinate)
        }
    }

If you want a custom annotation, do this:

    Annotation(location.name, coordinate: location.coordinate) {
        Text(location.name)
            .font(.headline)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
    .annotationTitles(.hidden)

To handle when something is tapped, we take advantage of the `MapReader` view.

    MapReader { proxy in
        Map()
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    print(coordinate)
                }
            }
    }

- ^^ `.local` signifies that we are using the tap location is relative to the top-left corner of the map. `.convert()` converts this to actual coordinates

### Touch ID and Face ID

meh, not important

### Misc Notes:

#### Comparison Function

MAKE SURE CUSTOM TYPES CONFORM TO `Equatable`. This means that you can simply check for equality (usually by UUID) with `==` instead of a custom check everytime. You have to define your own comparitor function.

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

When working with a custom annotation, you can use the `onLongPressGesture()` modifier to define behavior.

#### Enum's for loading state

This is already in the notes but you should do this for images and also just views in general.

### MVVM (Model View View-Model)

A system architecture model effectively separating program logic from view structs.

`ContentView-ViewModel`

So this file essentially contains a class that manipulates and formats our data for ContentView to then display.

First, create an `@Observable` class so that changes can be observed. This is also declared as an extension on `ContentView`, declaring it as the view model for ContentView

    extension ContentView {
        @Observable
        class ViewModel {
            
        }
    }

It's nice to declare as an extension because then it will always be called `ViewModel`. If you didn't do this, then you'd have to name the class something like `ContentViewViewModel` and refer to it as so.

You can then either move all of your `@State` variables into this class or only some of them, up to you.

So where `locations` and `selectedPlace` used to be `@State` in `ContentView`, they can now simply just look like this in our ViewModel class.

    extension ContentView {
        @Observable
        class ViewModel {
            var locations = [Location]()
            var selectedPlace: Location?        
        }
    }

And back in `ContentView`, we can obtain these values as so:

    @State private var viewModel = ViewModel()

Reading from a `ViewModel` is all fine and dandy, but writing to and manipulating it is not ideal.

So to make this divide more clear, you can declare your variables as such.
    
    extension ContentView {
        @Observable
        class ViewModel {
            private(set) var locations = [Location]()
            private(set) var selectedPlace: Location?        
        }
    }

- ^^ you can read just fine (`get`), but only within the class can you `set` the data.

So, let's move some functionality into our viewmodel.

    extension ContentView {
        @Observable
        class ViewModel {
            private(set) var locations = [Location]()
            private(set) var selectedPlace: Location?        
        }

        func addLocation(at point: CLLocationcoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
        }

        func update(location: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }

    }

Now, you can just call `viewModel.addLocation(at: coordinate)` or `viewModel.update(location: )` in our `ContentView` file.

If you want to do anything with saving data, you can just declare a `savePath` inside your `ViewModel`.

So inside `ViewModel`:

    let savePath = URL.documentsDicrectory.appending(path: "SavedPlaces")

    init() {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
    } catch {
        locatoins = []
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            try data.write(to: savePath, options: [.atomic])
        } catch {
            print("Unable to save data.)
        }
    }



