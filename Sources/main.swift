import Kitura
import Foundation

// Create a new router
let router = Router()

//let myCertPath = "/tmp/Creds/Self-Signed/cert.pfx"
//
//func getAbsolutePath(relativePath: String, useFallback: Bool) -> String? {
//	let initialPath = #file
//	let components = initialPath.characters.split(separator: "/").map(String.init)
//	let notLastTwo = components[0..<components.count - 2]
//	
//	var filePath = "/" + notLastTwo.joined(separator: "/") + relativePath
//	
//	let fileManager = FileManager.default
//	
//	if fileManager.fileExists(atPath: filePath) {
//		return filePath
//	} else if useFallback {
//		// Get path in alternate way, if first way fails
//		let currentPath = fileManager.currentDirectoryPath
//		filePath = currentPath + relativePath
//		if fileManager.fileExists(atPath: filePath) {
//			return filePath
//		} else {
//			return nil
//		}
//	} else {
//		return nil
//	}
//}
//
//let path = getAbsolutePath(relativePath: myCertPath, useFallback: true)
//
//let mySSLConfig =  SSLConfig(withChainFilePath: path, withPassword: "wmkwb", usingSelfSignedCerts: true)


// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    response.send("🐳📦 HELLO DOCKER 🐳📦\n🐦 HELLO KITURA 🐦")
    next()
}

router.get("/name/:name") { request, response, _ in
	let name = request.parameters["name"] ?? ""
	try response.send("Hello \(name)").end()
}

router.all("/", middleware: BodyParser())

router.post("/name") { request, response, next in
	guard let parsedBody = request.body else {
		next()
		return
	}
	
	switch(parsedBody) {
	case .json(let jsonBody):
		let name = jsonBody["name"].string ?? ""
		try response.send("Hello \(name)").end()
	default:
		break
	}
	next()
}

// Add an HTTP server and connect it to the router
//Kitura.addHTTPServer(onPort: 8080, with: router, withSSL: mySSLConfig)
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()

