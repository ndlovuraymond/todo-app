import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let username: String
    let age: Int
    let gender: String
}
