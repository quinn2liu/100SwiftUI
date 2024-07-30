# GuessTheFlag

### V, H, and ZStack

You can put views into different "stacks." VStack, HStack, ZStack (vertical, horizontal, z-axis)

- think of these as flex containers

You can use `pacer()` to space out the elements in your vstack. This will be automatically divided based on how many spacers you have.

- if you have 2 spacers, then the view between them will be halfway on the screen.

ZStack: The first item in the zstack is placed first, so it is a lifo queue (or a literal stack) 

Stacks tend to take up the space of the views inside of them. You can declare the size of some views (like Color) with `.frame()`

### Materials

Materials are a cool way to add custom blurring effects or whatnot to your app. Look into later.

### Gradients

These can be standalone views or as background modifiers

1. Linear

2. Radial

3. Angualr

### Buttons
Must have an action associated with it.

- `role:` can be set to indicate info about a button, like if it's `.destructive`

### Images

There are 3 ways to show images in iOS

1. `Image()`

    - Standard

2. `Image(decorative: )`

    - Same as above, but the iOS screen reader won't read it out

3. `Image(systemName`)

    - Loads one of apple's default sf symbols

### Alerts

If you want to have an alert appear, you can add the `.alert()` property and within it, any button will dismiss the alert automatically if there's a two-way binding to an alert status.


    struct ContentView: View {
    @State private var showingAlert = false

        var body: some View {
            Button("Show alert) {
                showingAlert = true
            }
            .alert("Important message", isPresented: $showingAlert) {
                Button("OK") { }
            }
        }
    }
        
^^ notice how the closure for Button is empty. This is because the isPresented field indicates that buttons will automatically close the alert.
