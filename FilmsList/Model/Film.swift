import Foundation

struct films: Codable {
    let id: Int?
    let localizedName: String?
    let name: String?
    let year: Int?
    let rating: Double?
    let imageURL: String?
    let description: String?
    let genres: [String]?
    
    enum CodingKeys: String, CodingKey {
           case id
           case localizedName = "localized_name"
           case name, year, rating
           case imageURL = "image_url"
           case description, genres
       }
}

