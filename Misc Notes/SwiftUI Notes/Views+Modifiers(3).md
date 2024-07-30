# Views and Modifiers

When adding a modifier to a view (like `.background()` or `.frame()`), the order in which you do it matters.

For example:

    Button("Hello, world!") {
        print(type(of: self.body))
    }    
    .background(.red)
    .frame(width: 200, height: 200)

`.background(.red)` is applied to the button label first, and then the `.frame()` is applied, meaning that there is only red just around the text.

Everytime a view is modified, it SwiftUI actually creates a new view that modifies the previous one.

- the above button is of type `ModifiedContent<ModifiedContent<Button<Text>, _BackgroundStyleModifier>, _FrameLayout>`

### Ternary Conditional for Views

Try to use ternaries instead of if else blocks when rendering views.

    @State private var redText = false

    Button("hello world") {
        redText.toggle()
    }
    .foregroundStyle(redText ? .red : .blue)

### @ViewBuilder

Inside

    var body : some View {
        // views
    }

If you don't return a single view, then the @ViewBuilder property is applied, meaning that the multiple views inside get wrapped into a tuple.

ex:

    var body : some View {
        Text("view 1")
        Text("view 2")
    }

body is now a TupleView type with 2 views inside of it.

- note that TupleView is what happens to multiple views that are inside of a VStack

### Containers

If you have several views inside of a container, applying an environment modifier to that container will then modify all the views inside.

However, if a child view has the same view modifier, it will override the environment modifier.


    VStack {
        Text("hello")
        Text("hello again but smaller")
            .font(subtitle)
    }
    .font(title)

YOU DON'T KNOW IF A MODIFIER IS ENVIRONMENT OR NOT UNLESS YOU READ DOCS

### Views as Properties

If you have a basic view that repeats, you can declare it as a proeprty in your struct for easier use

    let motto = Text("motto")

    var body : some View {
        motto
            .font(subtitle)
    }

However, you can't have view properties depend on other properties in the struct due to race conditions.

You can also create computed view properties

    var motto : some View {
        Text("motto")
    }

- if you have multiple views inside of the view property, you need to either wrap in a stack or add @ViewBuilder (the latter is usually better)

### View Composition

You can create a struct that is effectively a custom view, and then you can create instances of that struct (a view) and add modifiers to it.

    struct CapsuleText: View {
        var text: String

        var body: some View {
            Text(text)
                .font(.largeTitle)
                .padding()
                .background(.blue)
                .clipShape(.capsule)
        }
    }

    struct ContentView: View {
        var body: some View {
            VStack(spacing: 10) {
                CapsuleText(text: "First")
                    .foregroundStyle(.white)
                CapsuleText(text: "Second")
                    .foregroundStyle(.yellow)
            }
        }
    }

### Custom Modifiers

You can create your own custom view modifiers by declaring a struct as the ViewModifier type

    struct Title: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .foregroundStyle(.white)
                .padding()
                .background(.blue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }

    var body : some View {
        Text("Hello World")
            .modifier(Title())
    }

You can also write an extension to the View protocol to not have to call .modifier(Title())

    struct Watermark: ViewModifier {
        var text: String

        func body(content: Content) -> some View {
            ZStack(alignment: .bottomTrailing) {
                content
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.black)
            }
        }
    }

    extension View {
        func watermarked(with text: String) -> some View {
            modifier(Watermark(text: text))
        }
    }

You might be wondering, why can't you just do an extension to the View protocol? You could, but if you want to have parameters like here with Watermark, you need to declare it as a struct first.
