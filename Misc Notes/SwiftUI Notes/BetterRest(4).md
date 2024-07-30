# BetterRest

### Steppers

Basically a type of button that has a + and - to increment values.

`Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)`

### DatePicker

Swift has its own date type, Date, and DatePicker lets you pick one.

`DatePicker("Pick your date", selection: Date.now)`

If you don't want a label, use the `.labelsHidden()

If you want to add a range to your date, you can do something like

    let tomorrow = Date.now.addingTimeInterval(86400)

    let range = Date.now...Tomorrow

With a picker:

`DatePicker("Pick your date", selection: Date.now...)`

- This means that you can pick any date from now into the future

### Working with Dates

Date objects have a lot of random information. 

If you want to read/write specific parts of a date instead of the whole thing, you can use `DateComponents()`

    ex: 

    var components = DateComponents()
    components.hour = 8
    components.minute = 0
    let date = Calendar.current.date(from: components) ?? .now

- note that date is an optional, so nil coalesce to take care of that

So how do we then read specific components from a date?

    let components = Clendar.current.dateComponents([.hour, .minute], from: .now)

    let hour = components.hour ?? 0
    let minute = components.minute ?? 0

And this can be displayed with text as so

    Text(Date.now, format: .datetime.hour.minute)

    // or

    Text(Date.now.formatted(date: .long, time: .shortened))


### Create ML

Easy drag and drop way to add some ml to your projects.

- XCode>Open Developer Tool > Create ML

Tabular regression was the example, but it basically predicts a numerical value given the data.

You can add csv data for it to train on.

Target: what to predit

Features: what we think will have correlation 

