//
//  Friend.swift
//  API-VaporPackageDescription
//
//  Created by Lindemann on 24.09.17.
//

import Vapor
import FluentProvider
import AuthProvider
import HTTP

final class Friend: Model {
	let storage = Storage()
	let userId: Identifier
	
	init(user: User) throws {
		userId = try user.assertExists()
	}
	
	// MARK: Row
	init(row: Row) throws {
		userId = try row.get(User.foreignIdKey)
	}
	
	func makeRow() throws -> Row {
		var row = Row()
		try row.set(User.foreignIdKey, userId)
		return row
	}
	
}

// MARK: Preparation
extension Friend: Preparation {
	static func prepare(_ database: Database) throws {
		try database.create(Friend.self) { builder in
			builder.id()
			builder.foreignId(for: User.self, unique: true)
		}
	}
	
	static func revert(_ database: Database) throws {
		try database.delete(Friend.self)
	}
}

// MARK: JSON
extension Friend: JSONRepresentable {
	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set("userID", userId)
		return json
	}
}

// MARK: HTTP
extension Friend: ResponseRepresentable { }



