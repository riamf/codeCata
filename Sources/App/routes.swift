import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("status", "health") { req -> String in
        return ""
//        Response(status: .ok,
//                        version: kCFHTTPVersion1_0,
//                        headers: HTTPHeaders([("Content-Type", "application.json")]),
//                        body: Response.Body.empty)
    }
}
