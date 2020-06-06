import Foundation

struct Pokemon: Codable {
    var name: String
    var thumbnailImage: String
    var type: [String]
}

extension Pokemon: Equatable {
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.name == rhs.name
    }
}
