# SwiftData

### Editing SwiftData model objects

See the example project, but we have a `User` SwiftData Model and a `EditUserView` to edit that User.

All you have to do to be able to edit a `User` model is inside of our `EditUserView`, you can update the user to be `@Bindable`

    struct EditUserView: View {
        @Bindable var user: User
        
        var body: some View {
            // stuff that updates user
        }
    }

ContentView

    struct ContentView: View {
        @Environment(\.modelContext) var modelContext
        @Query(sort: \User.name) var users: [User]
        @State private var path = [User]()
        
        var body: some View {
            NavigationStack(path: $path) {
                List(users) { user in
                    NavigationLink(value: user) {
                        Text(user.name)
                    }
                }
                .navigationTitle("Users")
                .navigationDestination(for: User.self) { user in
                    EditUserView(user: user)
                }
                .toolbar {
                    Button("Add User", systemImage: "plus") {
                        let user = User(name: "", city: "", joinDate: .now)
                        modelContext.insert(user)
                        path = [user]
                    }
                }
            }
        }
    }

This effectively has the same behavior as a regular @Observable class, except now we're writing to permanent storage.

### Filtering with `#Predicate`

Basically advanced filtering and sorting whenever we query.

### Dynamically sorting and filtering @Query

I'm done with this stupid SwiftData stuff