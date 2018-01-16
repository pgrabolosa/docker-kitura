import Foundation
import Kitura
import SwiftKueryMySQL

// Prepare and connect to MySQL ================================================
let db = MySQLConnection(
  host: environment("MYSQL_HOST"),
  user: environment("MYSQL_USER_NAME"),
  password: environment("MYSQL_USER_PASSWORD"),
  database: environment("MYSQL_DATABASE"))

db.connect() { error in
    guard error == nil else {
        print("Error connecting to database.")
        exit(1)
    }
    
    // Initialize
    db.execute("DROP TABLE IF EXISTS messages") { _ in
        db.execute("CREATE TABLE messages (author varchar(255), message varchar(255), ts timestamp DEFAULT current_timestamp)") { _ in
        }
    }
}

// Setup the Routes ============================================================
let router = Router()
router.all("/*", middleware: BodyParser())

router.get("/") { request, response, next in
  response.send("""
    Available routes:
       - GET /messages returning an array of {"author": string, "message": string} JSON objects.
       - POST /messages expecting a JSON request payload {"author": string, "message": string}.
    """)
  next()
}

router.get("/messages") { request, response, next in
  db.execute("SELECT author, message FROM eleves ORDER BY eleves.ts ASC") { queryResult in
    
    var messages = [[String:String]]()
    
    if let rows = queryResult.asRows {
      for row in rows {
        guard let author = row["author"] as? String,
              let message = row["message"] as? String else {
          continue
        }
        messages.append(["author": author, "message": message])
      }
    }
    
    response.send(json: messages)
  }
  next()
}

router.post("/messages") { request, response, next in
  
  guard case let .json(jsonBody)? = request.body else {
    response.status(.badRequest)
    next()
    return
  }
  
  if let author = jsonBody["author"] as? String,
     let message = jsonBody["message"] as? String {
    db.execute("INSERT INTO messages(author, message) VALUES (:author, :message)", parameters: [
      ":author": author,
      ":message": message
    ]) {_ in }
  
    response.send("Message sent\n")
  } else {
    response.send("Message was not sent\n") // report some error
  }
  next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
