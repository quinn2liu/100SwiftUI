# WordScramble

### Lists

Kind of like forms, but lists let you simulate foreach behavior but in the case of a form.

    struct ContentView: View {
        let people = ["Finn", "Leia", "Luke", "Rey"]

        var body: some View {
            List(people, id: \.self) {
                Text($0)
            }
        }
    }

### Bundles

Whenever an app gets released, a bundle is created, where the App's binary code as well as all its photos/assets are stored.

When an `Image()` view is evoked, the app will automatically look for it in the bundle. For more general text files, whether it be .txt, .xml, or .json, you need to do the following to access that string data.

    if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
        // we found the file in our bundle!
    }

    if let fileContents = try? String(contentsOf: fileURL) {
        // we loaded the file into a string!
    }

### String manipulation

Splitting into array by some separating string

    let input = """
                a
                b
                c
                """
    let letters = input.components(separatedBy: "\n")

Getting random element from this string

    // .randomElement() returns an optional, since swift doesn't know if your input is empty or not and stuff
    let letter = letters.randomElement()

If you want to trim leading/trailing characters

    let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)

If you want to spell check, you can use on old UIKit framework to do so.

    let word = "swift"

    // instance of UITextChecker
    let checker = UITextChecker()

    // the range of how far in the string or document you want to check 
    let range = NSRange(location: 0, length: word.utf16.count)

    // check if there's any mispelling
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    // how to see if you actually had anything mispelled (NSNotFound means nothing was mispelled)
    let allGood = misspelledRange.location == NSNotFound

### `.onSubmit()`

When added to any view, if text is submitted, then the addNewWord function will be called.

The function inside `.onSubmit()` however must have no parameters and be null.

### Running code on app startup

Swift gives a special view modifier to run a function whenever a view appears.


