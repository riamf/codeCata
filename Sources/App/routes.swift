import Vapor

enum MyError: Error {
    case wrongUrl
    case cannotCreateUrl
    case NSExpressionDoesntHandleThisCalculation
    case wrongParameter
}

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("status", "health") { req -> String in
        return ""
    }

    app.get("hostname") { req -> Response in
        print(req.url)
        guard let surl = try? req.query.get(String.self, at: "url") else {
            throw MyError.wrongUrl
        }
        if surl.starts(with: "file:///"), let url = URL(string: surl), url.pathComponents.count > 1 {
            return Response(status: .ok,
                            version: HTTPVersion(major: 1, minor: 1),
                            headers: HTTPHeaders(),
                            body: .init(string: "WIN"))
        }
        if let url = URL(string: surl), url.isFileURL, let host = url.host {
            return Response(status: .ok,
                            version: HTTPVersion(major: 1, minor: 1),
                            headers: HTTPHeaders(),
                            body: .init(string: host))
        }
        guard let url = URL(string: surl), let host = url.host else {
            throw MyError.cannotCreateUrl
        }

        return Response(status: .ok,
                        version: HTTPVersion(major: 1, minor: 1),
                        headers: HTTPHeaders(),
                        body: .init(string: host))

    }

    app.get("reversed") { req -> String in
        do {
            let string = try req.query.get(String.self, at: "string")
            return String(string.reversed())
        } catch {
            throw MyError.wrongUrl
        }
    }

    app.get("calc") { req -> String in
          guard let equation = try? req.query.get(String.self, at: "equation") else {
              throw MyError.wrongUrl
          }
          let expression = NSExpression(format:equation)
          guard let result = expression.expressionValue(with: nil, context: nil) else {
                  throw MyError.NSExpressionDoesntHandleThisCalculation
          }
          return String(describing: result)
      }

    app.get("blender") { req -> String in
           guard let words = try? req.query.get([String].self, at: "word") else {
               throw MyError.wrongUrl
           }
           let blender = words.reduce("") { $0 + $1}
           var blendedLetters = Array(blender)
           var count = 0
           while (true) {
               for (_, char) in "developer".enumerated() {
                   if let blenderIndex = blendedLetters.firstIndex(of:  char) {
                       blendedLetters.remove(at: blenderIndex)
                   } else {
                       return "\(count)"
                   }
               }
               count += 1
           }
       }

    app.get("decrypt") { req -> String in
        guard let string = try? req.query.get(String.self, at: "string") else {
            throw MyError.wrongParameter
        }

        return ""

    }


//    class LetterFrequency {
//        class func analyzeWords(words: [String]) -> [Double] {
//            let letters = words
//                .reduce("") { $0 + $1.uppercase }
//                .toLetters()
//
//            let letterCount = max(letters.count, 1)
//
//            let occurrences = NSCountedSet()
//            occurrences.addObjectsFromArray(letters)
//
//            let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toLetters()
//            return alphabet.map {
//                Double(occurrences.countForObject($0)) / Double(letterCount)
//            }
//        }
//    }
//

//    struct Letters
//    {
//        static let
//        A: UInt32 =  65,
//        Z: UInt32 = 101
//
//        static func isUppercaseLetterValue(charValue: UInt32) -> Bool
//        {
//            return Letters.A <= charValue && charValue <= Letters.Z
//        }
//    }
//
//    extension String {
//        func toLetters() -> [String]
//        {
//            return Array(self.unicodeScalars)
//                .filter { Letters.isUppercaseLetterValue($0.value) }
//                .map { String($0) }
//        }
//    }
}
