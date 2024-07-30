# CupcakeCorner

### Sending/Receiving Codable Data 

To avoid getting slowed down by network (API) requests, you can take advantage of async/await code.


    struct Response: Codable {
        var results: [Result]
    }

    struct Result: Codable {
        var trackId: Int
        var trackName: String
        var collectionName: String
    }

    struct ContentView: View {
        @State private var results = [Result]()

        var body: some View {
            List(results, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }
            .task {
                await loadData()
            }
        }

        func loadData() async {
            guard let url = URL(string: 
            "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
                print("Invalid URL")
                return
            }

            do {
                // this tuple is data along with metadata
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    results = decodedResponse.results
                }

            } catch {
                print("Invalid data)
            }

        }
    }

If we want `loadData()` to be run right as the List is shown, we can't use `onAppear()` as that can't work with async functions. Instead, we use the `.task` modifier.

- Think of this as a try? block.

### Loading a Remote Image

To get an image from a remote server, you have to use `AsyncImage()` instead of `Image()`

    AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))

This, however, has a caveat, where Swift doesn't know the size or anything else about the image it's downloading. This means that modifiers don't work as we expect them to.

When we use AsyncImage() like above, we're applying modfiers to a wrapper around the image which also has a placeholder.

So, to get this to actually work, we need to pass the final image when it's ready (and we can also customize the placeholder).

    AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
        image
            .resizable()
            .scaledToFit()
    } placeholder: {
        Color.red
    }
    .frame(width: 200, height: 200)

- So here, the frame is being applied to the wrapper around the image, whereas the eventual, loaded-in image is defined as resizeable and scaled to fit in its frame.

- Basically, this shows us whether the image is loading, or loaded.

Let's say, however, we want to check whether the image loading encountered an error. This means we have to take in an image phase

    AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
        if let image = phase.image {
            image
                .resizable()
                .scaledToFit()
        } else if phase.error != nil {
            Text("There was an error loading the image.")
        } else {
            ProgressView()
        }
    }
    .frame(width: 200, height: 200)

### Validating and Disabling Forms

If you want to disable a form depending on certain values, you can use the `disabled()` modifier to your forms.

    struct ContentView: View {
        @State private var username = ""
        @State private var email = ""

        var disableForm: Bool {
            username.count < 5 || email.count < 5
        }

        var body: some View {
            Form {
                Section {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                }

                Section {
                    Button("Create account") {
                        print("Creating account…")
                    }
                }
                .disabled(disableForm)
            }
        }
    }

- This disables the create account button when disableForm is true.

### Adding Codable to an @Observable class

So in the past, if all the properties of a type conform to `Codable`, then the type itself will conform. However, this doesn't work with `@Observable` classes.

    @Observable
    class User: Codable {
        var name = "Taylor"
    }

    struct ContentView: View {
        var body: some View {
            Button("Encode Taylor", action: encodeTaylor)
        }

        func encodeTaylor() {
            let data = try! JSONEncoder().encode(User())
            let str = String(decoding: data, as: UTF8.self)
            print(str)
        }
    }

However, str now becomes `{"_name":"Taylor","_$observationRegistrar":{}}`.

To avoid this, we need to tell Swift exactly how data should be encoded and decoded by declaring an enum called `CodingKeys`

    @Observable
    class User: Codable {
        enum CodingKeys: String, CodingKey {
            case _name = "name"
        }

        var name = "Taylor"
    }

- This is saying our CodingKeys has a raw value of String and conforms to CodingKey

- in the case when `_name` is to be written, write `"name"` instead.

### Haptic (Vibrate) Effects

mmmmmeh this is not really relevant.
