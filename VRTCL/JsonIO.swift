//
//  JsonIO.swift
//  VRTCL
//
//  Created by Lindemann on 09.07.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import Foundation

struct JsonIO {
	
	static func save<T>(codable: T, toFile file: String? = nil) where T : Codable {
		let fileName = file == nil ? String(describing: T.self) + ".json" : file!
		guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let data = try encoder.encode(codable)
			try data.write(to: fileUrl, options: [])
		} catch {
			print("💥 \(error)")
		}
	}
	
	static func codableType<T>(_ type: T.Type, fromFile file: String? = nil) -> T? where T : Codable {
		let fileName = file == nil ? String(describing: T.self) + ".json" : file!
		guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		let fileUrl = documentsDirectoryUrl.appendingPathComponent(fileName)
		let decoder = JSONDecoder()
		var result: T?
		do {
			let data = try Data(contentsOf: fileUrl, options: [])
			result = try decoder.decode(type, from: data)
		} catch {
			print("💥 \(error)")
		}
		return result
	}
}

