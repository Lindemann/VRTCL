import Vapor
import FluentProvider
import AuthProvider
import HTTP

final class User: Model {
    let storage = Storage()
    
    /// The name of the user
    var name: String

    /// The user's email
    var email: String

    /// The user's _hashed_ password
    var password: String?
	
	// String representation of Sessions JSON from the app
	// Fluent can't work with JSON directly, therefor it's a String here
	// Postgres DB saves it as JSON type and allows advanced manipultion
	var sessions: String?

    /// Creates a new User
	init(name: String, email: String, password: String? = nil, sessions: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
		self.sessions = sessions
    }

    // MARK: Row

    /// Initializes the User from the
    /// database row
    init(row: Row) throws {
        name = try row.get("name")
        email = try row.get("email")
        password = try row.get("password")
		sessions = try row.get("sessions")
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("email", email)
        try row.set("password", password)
		try row.set("sessions", sessions)
        return row
    }
}

// MARK: Preparation

extension User: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Users
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.string("email")
            builder.string("password")
			builder.custom("sessions", type: "json", optional: true)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new User (POST /users)
//
extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name"),
            email: json.get("email"),
			sessions: json.get("sessions")
        )
        id = try json.get("id")
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("email", email)
		try json.set("sessions", sessions)
        return json
    }
}

// MARK: HTTP

// This allows User models to be returned
// directly in route closures
extension User: ResponseRepresentable { }

// MARK: Password

// This allows the User to be authenticated
// with a password. We will use this to initially
// login the user so that we can generate a token.
extension User: PasswordAuthenticatable {
    var hashedPassword: String? {
        return password
    }

    public static var passwordVerifier: PasswordVerifier? {
        get { return _userPasswordVerifier }
        set { _userPasswordVerifier = newValue }
    }
}

// store private variable since storage in extensions
// is not yet allowed in Swift
private var _userPasswordVerifier: PasswordVerifier? = nil

// MARK: Request

extension Request {
    /// Convenience on request for accessing
    /// this user type.
    /// Simply call `let user = try req.user()`.
    func user() throws -> User {
        return try auth.assertAuthenticated()
    }
}

// MARK: Token

// This allows the User to be authenticated
// with an access token.
extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
