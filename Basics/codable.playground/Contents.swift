import Foundation

// -- Declaring a Codable type --

struct User: Codable {
    var name: String
    var age: Int
}

// -- Encoding, then decoding, a type to/from JSON data --

do {
    let user = User(name: "John", age: 31)
    let encoder = JSONEncoder()
    let data = try encoder.encode(user)

    let decoder = JSONDecoder()
    let secondUser = try decoder.decode(User.self, from: data)

    print("First:", user)
    print("Second:", secondUser)
} catch {
    print("Whoops, an error occured: \(error)")
}

// -- Making our type compatible with a different JSON structure --

extension User {
    struct CodingData: Codable {
        struct Container: Codable {
            var fullName: String
            var userAge: Int
        }

        var userData: Container
    }
}

extension User.CodingData {
    var user: User {
        return User(
            name: userData.fullName,
            age: userData.userAge
        )
    }
}

// -- Decoding JSON using that different structure --

do {
    let json = """
    {
        "user_data": {
            "full_name": "John Sundell",
            "user_age": 31
        }
    }
    """

    let data = Data(json.utf8)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let codingData = try decoder.decode(User.CodingData.self, from: data)
    let user = codingData.user

    print("Third:", user)
} catch {
    print("Whoops, an error occured: \(error)")
}
