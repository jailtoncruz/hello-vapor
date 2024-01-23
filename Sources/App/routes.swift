import Fluent
import Vapor

struct UserResponse: Content {
    let message: String
}

struct UserInfo: Content {
    let name: String
    let age: Int
}

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get("hello", ":name") { req async throws -> String in
        let name = try req.parameters.require("name")
        return "Hello, \(name.capitalized)!"
    }
    
    app.get("json", ":name") { req async throws -> UserResponse in
        let name = try req.parameters.require("name");
        return UserResponse(message: name);
    }
    
    app.post("user-info") { req async throws -> UserResponse in
        // 2
        let userInfo = try req.content.decode(UserInfo.self)
        // 3
        let message = "Hello, \(userInfo.name.capitalized)! You are \(userInfo.age) years old."
        return UserResponse(message: message)
    }


    try app.register(collection: TodoController())
}
