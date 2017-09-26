import Vapor
import AuthProvider
import SMTP

extension Droplet {
    func setupRoutes() throws {
        try setupUnauthenticatedRoutes()
        try setupPasswordProtectedRoutes()
        try setupTokenProtectedRoutes()
    }

    /// Sets up all routes that can be accessed
    /// without any authentication. This includes
    /// creating a new User.
    private func setupUnauthenticatedRoutes() throws {
        // a simple json example response
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
		
		// a simple plaintext example response
        get() { req in
			
//			let user1 = try User.all()[0]
//			let user2 = try User.all()[1]
//			let user3 = try User.all()[2]
//
//
//			let friend1 = try Friend(user: user2)
//			try friend1.save()
//			let friend2 = try Friend(user: user3)
//			try friend2.save()
//
//			try user1.friends.add(friend1)
//			try user1.friends.add(friend2)
//
//			print(try user1.friends.all().makeJSON())
//
//			for u in try User.all() {
//				if try u.friends.isAttached(friend1) {
//					print(u.name)
//				}
//			}
//
//			let users = try User.makeQuery().or({ orGroup in
//				try orGroup.filter("name", .contains, "user3")
//				try orGroup.filter("email", .contains, "a@aa.de")
//			}).all()
//			print(try users.makeJSON())
			
            return "VRTCL Server is running ( ◕ ◡ ◕ )"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        // create a new user
        //
        // POST /users
        // <json containing new user information>
        post("signup") { req in
            // require that the request body be json
            guard let json = req.json else {
                throw Abort(.badRequest)
            }

            // initialize the name and email from
            // the request json
            let user = try User(json: json)

            // ensure no user with this email already exists
            guard try User.makeQuery().filter("email", user.email).first() == nil else {
                throw Abort(.badRequest, reason: "A user with that email already exists.")
            }

            // require a plaintext password is supplied
            guard let password = json["password"]?.string else {
                throw Abort(.badRequest)
            }

            // hash the password and set it on the user
            user.password = try self.hash.make(password.makeBytes()).makeString()

            // save and return the new user
            try user.save()
            return user
        }
    }

    /// Sets up all routes that can be accessed using
    /// username + password authentication.
    /// Since we want to minimize how often the username + password
    /// is sent, we will only use this form of authentication to
    /// log the user in.
    /// After the user is logged in, they will receive a token that
    /// they can use for further authentication.
    private func setupPasswordProtectedRoutes() throws {
        // creates a route group protected by the password middleware.
        // the User type can be passed to this middleware since it
        // conforms to PasswordAuthenticatable
        let password = grouped([
            PasswordAuthenticationMiddleware(User.self)
        ])

        // verifies the user has been authenticated using the password
        // middleware, then generates, saves, and returns a new access token.
        //
        // POST /login
        // Authorization: Basic <base64 email:password>
        password.post("login") { req in
            let user = try req.user()
            let token = try Token.generate(for: user)
            try token.save()
            return token
        }
    }

    /// Sets up all routes that can be accessed using
    /// the authentication token received during login.
    /// All of our secure routes will go here.
    private func setupTokenProtectedRoutes() throws {
        // creates a route group protected by the token middleware.
        // the User type can be passed to this middleware since it
        // conforms to TokenAuthenticatable
        let token = grouped([
            TokenAuthenticationMiddleware(User.self)
        ])

        // simply returns a greeting to the user that has been authed
        // using the token middleware.
        //
        // GET /me
        // Authorization: Bearer <token from /login>
        token.get("user") { req in
            let user = try req.user()
            return user
        }
		
		// POST /sessions
		// Authorization: Bearer <token from /login>
		// Body: <sessions JSON>
		token.post("sessions") { req in
			// require that the request body be json
			guard let json = req.json else {
				throw Abort(.badRequest, reason: "No sessions data was submitted.")
			}
			// JSON -> String
			let data = try json.makeBytes()
			let sessionsString = data.makeString()
			
			// Get user
			let user = try req.user()
			user.sessions = sessionsString
			try user.save()
			
			let response = Response(status: .ok, body: "sessions saved")
			return response
		}
		
		// POST /photoURL
		// Authorization: Bearer <token from /login>
		// JSON: {"photoURL" : "https://???"}
		token.post("photoURL") { req -> ResponseRepresentable in
			// photURL
			guard let json = req.json else {
				throw Abort(.badRequest, reason: "No photo url was submitted.")
			}
			guard let photURL = json["photoURL"]?.string else {
				throw Abort(.badRequest, reason: "No photo url was submitted.")
			}
			// Get user
			let user = try req.user()
			user.photoURL = photURL
			try user.save()
			
			let response = Response(status: .ok, body: "photo url saved")
			return response
		}
		
		// POST /follow
		// Authorization: Bearer <token from /login>
		// JSON: {"userID" : 666}
		token.post("follow") { req -> ResponseRepresentable in
			guard let json = req.json else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}
			guard let userID = json["userID"]?.int else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}
			guard let userForID = try User.makeQuery().filter("id", userID).first() else {
				throw Abort(.badRequest, reason: "No user found for id.")
			}
			
			var friend: Friend
			if let tmpFfriend = try Friend.makeQuery().filter("user_id", userID).first() {
				friend = tmpFfriend
			} else {
				friend = try Friend(user: userForID)
				try friend.save()
			}

			let user = try req.user()
			if try user.friends.isAttached(friend) {
				throw Abort(.badRequest, reason: "Follows user already")
			} else {
				try user.friends.add(friend)
			}
			
			let response = Response(status: .ok, body: "Following user successful")
			return response
		}
		
		// POST /unfollow
		// Authorization: Bearer <token from /login>
		// JSON: {"userID" : 666}
		token.post("unfollow") { req -> ResponseRepresentable in
			guard let json = req.json else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}
			guard let userID = json["userID"]?.int else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}
			guard let friend = try Friend.makeQuery().filter("user_id", userID).first() else {
				throw Abort(.badRequest, reason: "No user found for id.")
			}
			
			let user = try req.user()
			if try user.friends.isAttached(friend) {
				try user.friends.remove(friend)
			} else {
				throw Abort(.badRequest, reason: "Not following user")
			}
			
			let response = Response(status: .ok, body: "Unfollowing user successful")
			return response
		}
		
		// GET /allUser
		// Authorization: Bearer <token from /login>
		token.get("allUser") { req -> ResponseRepresentable in
			return try User.all().makeJSON()
		}
		
		// POST /search
		// Authorization: Bearer <token from /login>
		// JSON: {"search" : "name or email"}
		token.post("search") { req -> ResponseRepresentable in
			
			guard let json = req.json else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}
			guard let searchTerm = json["search"]?.string else {
				throw Abort(.badRequest, reason: "No id submitted.")
			}

			let users = try User.makeQuery().or({ orGroup in
				try orGroup.filter("name", .contains, searchTerm)
				try orGroup.filter("email", .contains, searchTerm)
			}).all()
			
			return try users.makeJSON()
		}
		
		// GET /following
		// Authorization: Bearer <token from /login>
		token.get("following") { req -> ResponseRepresentable in
			let user = try req.user()
		
			var users: [User] = []
			for friend in try user.friends.all() {
				if let user = try User.makeQuery().filter("id", friend.userId).first() {
					users.append(user)
				}
			}
			return try users.makeJSON()
		}
		
		// GET /followers
		// Authorization: Bearer <token from /login>
		token.get("followers") { req -> ResponseRepresentable in
			
			let user = try req.user()
			// User -> Friend
			var friend: Friend
			if let tmpFfriend = try Friend.makeQuery().filter("user_id", user.id).first() {
				friend = tmpFfriend
			} else {
				friend = try Friend(user: user)
				try friend.save()
			}
			
			var users: [User] = []
			for follower in try User.all() {
				if try follower.friends.isAttached(friend) {
					users.append(follower)
				}
			}
			
			return try users.makeJSON()
		}
    }
}
