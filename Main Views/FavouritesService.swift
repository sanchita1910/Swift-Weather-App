
import Foundation

struct Favorite: Codable, Identifiable, Equatable {
    var id: String
    var city: String
    var state: String
    

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case city
        case state
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
    }
    
 
       static func == (lhs: Favorite, rhs: Favorite) -> Bool {
           return lhs.id == rhs.id &&
                  lhs.city == rhs.city &&
                  lhs.state == rhs.state
       }
}

class FavoritesService {
    static let baseURL = "https://weatherappbackend-441501.uw.r.appspot.com"

    // Add to favorites functions
    static func addFavorite(city: String, state: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/favorites")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = try? JSONEncoder().encode(["city": city, "state": state])
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding favorite: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }

    // Remove from favorites function
    static func removeFavorite(favoriteId: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/favorites/\(favoriteId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error removing favorite: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
