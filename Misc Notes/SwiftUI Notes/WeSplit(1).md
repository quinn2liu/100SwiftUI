# WeSplit (project 1)

## Views are a function of their state 🙂

### NavigationStack 

- navigation bar that goes at the top of a screen. it's a view that lets us display a root view and enables you to add additional views over it. 

- NavigationStack automatically provides back buttons in the navigation bar for when you venture to different views.

### @State

Inside of structs (which can be made as constants), you can't update property values like we have previously thought.

- "mutating" keyword doesn't work, only works on funcs

So, you can add a property wrapper, @State, to let SwiftUI know to track and update the state of the var (similar to useState in React)

Best practice to use "private" access so that the state is only created and viewable here.

### Two Way Binding

In SwiftUI, some views (like TextField) that display a state variable need to both know which variable to READ from and which variable to WRITE to.

To achieve a 2-way binding (read and write), add $ before an @State var when being passed into the corresponding view

    @State private var name = ""

    TextField("Ener your name", text: $name)

### Decimal Pad

When using a TextField input, you can add the attribute `keyboardType(.decimalPad)` , which will change the default text-entry keyboard to a number pad

- Note that if using the decimal keyboard you need to manually declare when to dismiss the keyboard

### @FocusState

New property property wrapper, just to handle focus input.