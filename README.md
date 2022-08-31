# ModelAuthenticationLimitMiddleware

## This is considered Alpha, there are breaking changes coming:
1. Adding of a model requirement for number of concurrent sessions,
2. Adding a argument to the authentication method for max sessions globally
This is a Middleware for Vapor+Fluent that uses the Fluent Model for authentication,
and limits the number of concurrent sessions to a value contained within the Model.

This is is intended to be treated as an extension to the Fluent ModelCredentialsAuthenticatable Middleware.

Conform to things needed to make Fluent Model Authentication function properly.

Adding the following to your model will Conform to All Requirments

```swift
import MALM

// Extend the model for ModelCredentialsAuthenticatable
extension User: ModelCredentialsAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

// Extend the model for ModelSessionAuthenticatable
extension User: ModelSessionAuthenticatable { }


// Extend the model for ModelCredentialsSingleAuthenticatable
extension User: ModelCredentialsSingleAuthenticatable { }

```

Be sure to include session middleware and run the sessionAuthenticator()
in either your app directive or individual routes

```swift
app.middleware.use(app.sessions.middleware)
app.middleware.use(User.sessionAuthenticator())
// OR 
let sessionizer = app.grouped([
  app.sessions.middleware,
  User.sessionAuthenticator()
])
```
Add the authentication to route

```swift
let auth = app.grouped([
  User.credentialsSingleAuthenticator()
])

```

You can have both ```ModelCredentialsAuthenticable`` and ```ModelCredentialsSingleAuthenticable``` in the same app,
using them on the same route would be redundant, and is unknown what will happen.

