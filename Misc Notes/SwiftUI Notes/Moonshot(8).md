# Moonshot

### Image Sizing

Sometimes, we want to size images either relative to the screen size or absolutely.

ALSO USE THE DIFFERENT PREVIEW MODES (live vs. selection) TO SEE YOUR FRAMES.

If we want to set it to some frame, we can do this:

    Image(.example)
        .resizable()
        .frame(width: 300, height: 300)

If you don't want your image to squeeze, you can do either `.scaleToFit()` or `.scaleToFill()`

### containerRelative

This let's us size an image relative to the size of the immediate parent container. For example, if we have a VStack where one of the several items is an image, then the image can be sized relatively to the size of the overall VStack.

    Image(.example)
        .resizable()
        .scaledToFit()
        
        // this defines that we want to get the horizontal axis, in which we retrieve the `size` of it and which `axis` it is. the closure returns the value we then want for said axis.
        .containerRelativeFrame(.horizontal) { size, axis in
            size * 0.8
        }

### ScrollView

Let's us scroll arbitrary content on the screen (instead of needing a list).

The scroll automatically takes up the space that it's contents is (meaning you can only scroll the area of the content).

If you don't want to have your VStack load all the content at once, you can use `LazyVStack()` or `LazyHStack()`

However, a `LazyVStack()` will take up all the space that is available, whereas a regular `VStack()` will only take up the space it needs. This is so that `LazyVStack()` isn't constantly changing its size.

    ScrollView {
        LazyVStack(spacing: 10) {
            ForEach(0..<100) {
                CustomText("Item \($0)")
                    .font(.title)
            }
        }
        .frame(maxWidth: .infinity)
    }

### NavigationLink

    NavigationStack {
        NavigationLink {
            Text("Detail View")
        } label: {
            VStack {
                Text("This is the label")
            }
        }
    }

This is usually good to show details about a specific item. Best place, for example, is in a list.

    NavigationStack {
        List(0..<100) { row in
            NavigationLink("Row \(row)") {
                Text("Detail \(row)")
            }
        }
        .navigationTitle("SwiftUI")
    }

This adds a little arrow to tell you to click it to view more details.

### Hierarchical Codable

Let's say you have a JSON string with hierarchical data, such as this nested data.

    let input = """
        {
            "name": "Taylor Swift",
            "address": {
                "street": "555, Taylor Swift Avenue",
                "city": "Nashville"
            }
        }
    """

You can then just decode that value itself.

    let data = Data(input.utf8)
    let decoder = JSONDecoder()
    if let user = try? decoder.decode(User.self, from: data) {
        print(user.address.street)
    }

### Creating a Scrollling Grid

If we want to create a grid of data, we can take advantage of LazyVGrid, which takes in a specific layout of how you want the grid to look.

In the case of a vertical grid:

    let layout = [
        GridItem(.adaptive(minimum: 80)),
    ]

    ScrollView {
        LazyVGrid(columns: layout) {
            ForEach(0..<1000) {
                Text("Item \($0)")
            }
        }
    }

### Nested Structs

Since the CrewRole struct is made to hold data about Mission, we can just put it here as a nested struct so that it makes more sense

    struct Mission: Codable, Identifiable {
        struct CrewRole: Codable {
            let name: String
            let role: String
        }
        let id: Int
        // note that since not all missions have a launch date, that means we can make launchDate an optional. Codable automatically skips over optionals if they are not decoded.
        let launchDate: String?
        let crew: [CrewRole]
        let description: String
    }

### Using Generics to load any Codable Data

If we take the following decode extension, we can change the definition to use generics instead of specifically `[String: Astronaut]`

    extension Bundle {
        func decode(_ file: String) -> [String: Astronaut] {
            // stuff
        }
    }

    extension Bundle {
        func decode<T: Codable>(_ file: String) -> T {
            // stuff
        }
    }

Note: T is just a generic shorthand, and basically just means that the function will operate on any type and will refer it as T. That's why we don't define the return as `-> [T]` because if let's say we decode `[String: Astronaut]`, then we are saying we want to return a `[[String: Astronaut]]`

We have to define decode to take in T: Decodable so that Swift can make sure that `decoder.decode()` works.

So, whenever you call the `Bundle.main.decode()` extension, you need to declare the type that is returned.

    let astronauts = Bundle.main.decode("astronauts.json")

    NOW BECOMES

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

### Codable = Decodable & Encodable

Codable actually refers to two separate protocols.

### Custom Colors

If we want to add a color theme, we can add an extension to `ShapeStyle`. Note that `Color` itself conforms to `ShapeStyle`s

### Dark mode vs Light mode

Titles font colors are bount to dark mode vs light mode, so, if you want to enforce either you can do this:

`.preferredColorScheme(.dark)`