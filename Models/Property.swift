import Foundation
import CoreLocation

struct Property: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let address: String
    let location: CLLocationCoordinate2D
    let bedrooms: Int
    let bathrooms: Int
    let squareFootage: Int
    let propertyType: PropertyType
    let images: [String]
    let features: [PropertyFeature]
    let status: PropertyStatus
    
    enum PropertyType: String, Codable, CaseIterable {
        case house
        case apartment
        case condo
        case townhouse
        case land
    }
    
    enum PropertyStatus: String, Codable {
        case forSale
        case pending
        case sold
    }
}

struct PropertyFeature: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}