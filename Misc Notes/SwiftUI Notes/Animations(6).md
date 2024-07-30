# Animation

Using the `.animation()` view modifier, you can set it so that an animation is applied based on different conditions.

Here, we have it set so that a default animation will play whenever the value "animationAmount" is updated.

    @State private var animationAmount = 1.0

    Button("Tap Me") {
        animationAmount += 1
    }
    .padding(50)
    .background(.red)
    .foregroundStyle(.white)
    .clipShape(.circle)
    .scaleEffect(animationAmount)
    .blur(radius: (animationAmount - 1) * 3)
    .animation(.default, value: animationAmount)

^^ note that `.animation()` applies to all modifiers that comes before it.

You can update the type of animation by adding modifiers like .linear, .easeInOut (.default is a spring)

### Overlays

You can use `.overlay()` to add animations to a view that continue forever for the life of the view.

    Button("Tap Me") {
        // animationAmount += 1
    }
    .padding(50)
    .background(.red)
    .foregroundStyle(.white)
    .clipShape(.circle)
    .overlay(
        Circle()
            .stroke(.red)
            .scaleEffect(animationAmount)
            .opacity(2 - animationAmount)
            .animation(
                .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                value: animationAmount
            )
    )
    .onAppear {
        animationAmount = 2
    }

### Bindings

You can also add animations to a specific value, so that whenever that value is updated, and animation that that value will update whenever that value is updated (but the specific animation is defined for the value)

    struct ContentView: View {
        @State private var animationAmount = 1.0

        var body: some View {
            VStack {
                Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)

                Spacer()

                Button("Tap Me") {
                    animationAmount += 1
                }
                .padding(40)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(.circle)
                .scaleEffect(animationAmount)
            }
        }
    }

### Explicit Animations
If you want an animation to occur explicitely without adding the animation tag, you can do something like this, where you add the `withAnimation {}` block to specifically add an animation for a view.

    struct ContentView: View {   
        @State private var animationAmount = 0.0

        var body: some View {
            Button("Tap Me") {
                withAnimation {
                    animationAmount += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
        }
    }

### Animation Stack

Just like view modifiers, animations depend on the order in which it's assigned. Only changes before the animations get updated.

This allows you to string together animations so that views have crazy compound animations depending on state changes.

### Animating Gestures

Can't be bothered

## Transitions

Previously, we could use a Bool to show or hide a view. But, you can do this with transitions as well

    struct ContentView: View {

        @State private var isShowingRed = false

        var body: some View {
            VStack {
                Button("Tap Me") {
                    withAnimation{
                        isShowingRed.toggle()
                    }
                    
                }

                if isShowingRed {
                    Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
                }
            }
        }
    }

### Custom transitions with ViewModifier

Also cannot be bothered 🤣

Basically you make a custom ViewModifier and have the content in the ViewModifier have a transition.

Then you can pass it as a transition into the transition modifier

`.transition(.pivot)`, where .pivot is a custom transition.
