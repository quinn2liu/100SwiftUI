# Instafilter

### Property Wrappers Becoming Structs

In this example, the blurAmount is set by both the slider and the button. If we want the console to print the blur amount when it is set using didSet, only the button executes this code. But why?

    struct ContentView: View {
        @State private var blurAmount = 0.0 {
            didSet {
                print("blurAmount = \(blurAmount)")
            }
        }

        var body: some View {
            VStack {
                Text("Hello, World!")
                    .blur(radius: blurAmount)

                Slider(value: $blurAmount, in: 0...20)

                Button("Random Blur") {
                    blurAmount = Double.random(in: 0...20)
                }
            }
        }
    }

This is because property wrappers change the type of whatever it's wrapping. `@State` wraps `blurAmount` into a State struct.

Thus, what our code is actually doing is "whenever the `@State` wrapper of blurAmount changes, print the statement." `@State` wrappers, however, have a non-mutating setter. This means that the struct itself isn't changed. 

SO BASICALLY, using the button (blurAmount = Double.random()) works correctly because this triggers the non-mutating setter from the `@State` wrapper. Using the slider with a binding ($blurAmount) DOESN'T work because the binding bypasses this whole wrapper and updates the blurAmount struct directly.

### `onChange()`

So basically, property observers like `didSet` don't work the way you intend because of how SwiftUI sends binding updates (using a $ in front of a variable) to property wrappers (@State for ex).

To fix this, we use `onChange()`. 

    struct ContentView: View {
        @State private var blurAmount = 0.0

        var body: some View {
            VStack {
                Text("Hello, World!")
                    .blur(radius: blurAmount)

                Slider(value: $blurAmount, in: 0...20)
                    .onChange(of: blurAmount) { oldValue, newValue in
                        print("New value is \(newValue)")
                    }
            }
        }
    }

Note that this modifier automatically passes `oldValue` and `newValue` into the closure.

There's another version of `onChange()`, which takes in a value and operates whenever it changes.

    .onChange(of: blurAmount) {
        // do something
    }

### `confirmationDialog()`

In addition to alerts, we can use a `confirmationDialog()` to have users confirm something. This takes in 3 parameters: title to show, value to determine whether to show, and a closure for the internals.

    struct ContentView: View {
        @State private var showingConfirmation = false
        @State private var backgroundColor = Color.white

        var body: some View {
            Button("Hello, World!") {
                showingConfirmation = true
            }
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            ..confirmationDialog("Change background", isPresented: $showingConfirmation) {
                Button("Red") { backgroundColor = .red }
                Button("Green") { backgroundColor = .green }
                Button("Blue") { backgroundColor = .blue }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select a new color")
            }
        }
    }

### Integrating Core Image

Starting code

    struct ContentView: View {
        @State private var image: Image?

        var body: some View {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onAppear(perform: loadImage)
        }

        func loadImage() {
            image = Image(.example)
        }
    }

Here, the default SwiftUI image view is great for loading a viewing a stored image. But to get the other functionality from Core Image, you need to leverage 3 total types of image views. 

- `UIImage` comes from UIKit. This is most similar to the SwiftUI `Image`

- `CGImage` comes from Core Graphics. This is basically just a 2d array of pixels.

- `CIImage` comes from Core Image. This basically stores an image recipe rather than the actual image.

These 3 types make a few combinations:

- We can create a `UIImage` from a `CGImage` and vice versa

- We can create a `CIImage` from a `UIImage` and from a `CGImage`, and can create a `CGImage` from a `CIImage`.

- We can create a SwiftUI `Image` from both a `UIImage` and a `CGImage`.

Basically, these are all raw data that we have to convert into an `Image` view.

SO, to apply a filter using Core Image, follow the steps outlined in `loadImage()`

    import CoreImage
    import CoreImage.CIFilterBuiltins

    struct ContentView: View {
        @State private var image: Image?

        var body: some View {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onAppear(perform: loadImage)
        }

        func loadImage() {
        
            let inputImage = UIImage(resource: .example) // UIImage
            let beginImage = CIImage(image: inputImage) // CIImage

            // creating context and a filter
            let context = CIContext()
            let currentFilter = CIFilter.sepiaTone()

            currentFilter.inputImage = beginImage
            currentFilter.intensity = 1

            // CONVERSION
            // get a CIImage from our filter or exit if that fails
            guard let outputImage = currentFilter.outputImage else { return }

            // attempt to get a CGImage from our CIImage
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgImage)

            // and convert that to a SwiftUI image
            image = Image(uiImage: uiImage)

        }
    }

There's an old API for setting dynamic values for some filters. I'm not going to cover that here but just saying it exists lol.

### `ContentUnavailableView()`

This gives us a default view to be shown when there is data has nothing to display.

    struct ContentView: View {
        var body: some View {
            ContentUnavailableView {
                Label("No snippets", systemImage: "swift")
            } description: {
                Text("You don't have any saved snippets yet.")
            } actions: {
                Button("Create Snippet") {
                    // create a snippet
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

This is basically good way to "launch" the app when the user first arrives. 
    
### PhotosPicker

This is a nice way to get user photos from their library and then load them into the app.

First, you need to `import PhotosUI`

The way this works is that there's a PhotosPicker item, which is a reference to the user's photo library, and then an Image view where that image is shown.

    struct ContentView: View {
        
        @State private var pickerItem: PhotosPickerItem?
        @State private var selectedImage: Image?

        var body: some View {
            VStack {
                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                selectedImage?
                    .resizable()
                    .scaledToFit()
            }
            .onChange(of: pickerItem) {
                Task {
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
        }
    }

- specify `matching: .images` so that you can only pick pictures.

- the `onChange(of: pickerItem)` means that when an image has been picked, then the PhotosPickerItem is ready to be loaded into our view using `loadTransferable()`

- the image is then shown using selectedImage?

If you want to let them select an array of images, you can update your code like so:

    struct ContentView: View {
        
        @State private var pickerItems: [PhotosPickerItem]()
        @State private var selectedImages = [Image]()

        var body: some View {
            VStack {
                PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                    Label("Select a picture", systemImage: "photo")
                }
                ScrollView {
                    ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .onChange(of: pickerItems) {
                Task {
                    selectedImages.removeAll()

                    for item in pickerItems {
                        if let loadedImage = try await item.loadTransferable(type: Image.self) {
                            selectedImages.append(loadedImage)
                        }
                    }
                }
            }
        }
    }

- you can use the `maxSelectionCount` in `PhotosPicker` to specify how many you want to let the user seelct. 

- you can also filter more specifically what kind of images you want users to be able to use

- as well as add a label to the picker (the default is `Select a picture`)

### ShareLink

Let's us share content across apps and stuff.

    struct ContentView: View {
        var body: some View {
            ShareLink(item: URL(string: "https://www.hackingwithswift.com:")!) {
                Label("click here to share", systemImage: "swift")
            }
        }
    }

- You can customize your button using `Label()`

You can also share more complex data using the following:

    let example = Image(.example)

    ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
        Label("Click to share", systemImage: "airplane")
    }