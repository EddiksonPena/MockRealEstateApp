import Foundation
import Combine
import MapKit

class PropertyViewModel: ObservableObject {
    @Published var properties: [Property] = []
    @Published var filteredProperties: [Property] = []
    @Published var selectedProperty: Property?
    @Published var searchText: String = ""
    @Published var selectedFilters: Set<Property.PropertyType> = []
    @Published var priceRange: ClosedRange<Double> = 0...1000000
    @Published var minBedrooms: Int = 0
    @Published var minBathrooms: Int = 0
    @Published var minSquareFootage: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Load mock data for development
        loadMockData()
        
        // Set up filtering
        setupFiltering()
    }
    
    private func setupFiltering() {
        Publishers.CombineLatest7(
            $properties,
            $searchText,
            $selectedFilters,
            $priceRange,
            $minBedrooms,
            $minBathrooms,
            $minSquareFootage
        )
        .map { properties, searchText, filters, priceRange, minBedrooms, minBathrooms, minSquareFootage in
            properties.filter { property in
                let matchesSearch = searchText.isEmpty ||
                    property.title.localizedCaseInsensitiveContains(searchText) ||
                    property.address.localizedCaseInsensitiveContains(searchText)
                
                let matchesFilters = filters.isEmpty || filters.contains(property.propertyType)
                
                let matchesPrice = property.price >= priceRange.lowerBound &&
                    property.price <= priceRange.upperBound
                
                let matchesBedrooms = property.bedrooms >= minBedrooms
                let matchesBathrooms = property.bathrooms >= minBathrooms
                let matchesSquareFootage = property.squareFootage >= minSquareFootage
                
                return matchesSearch && matchesFilters && matchesPrice && 
                       matchesBedrooms && matchesBathrooms && matchesSquareFootage
            }
        }
        .assign(to: &$filteredProperties)
    }
    
    private func loadMockData() {
        let mockProperties = [
            Property(
                id: UUID(),
                title: "Luxury Waterfront Villa",
                description: "Stunning waterfront property with panoramic views",
                price: 1_250_000,
                address: "123 Ocean View Drive, Malibu, CA",
                location: CLLocationCoordinate2D(latitude: 34.0259, longitude: -118.7798),
                bedrooms: 4,
                bathrooms: 3,
                squareFootage: 3500,
                propertyType: .house,
                images: ["property1", "property2", "property3"],
                features: [
                    PropertyFeature(id: UUID(), name: "Pool", icon: "figure.pool.swim"),
                    PropertyFeature(id: UUID(), name: "Garage", icon: "car.fill"),
                    PropertyFeature(id: UUID(), name: "Garden", icon: "leaf.fill")
                ],
                status: .forSale
            ),
            Property(
                id: UUID(),
                title: "Modern Downtown Apartment",
                description: "Contemporary living in the heart of the city",
                price: 750_000,
                address: "456 City Center, Los Angeles, CA",
                location: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
                bedrooms: 2,
                bathrooms: 2,
                squareFootage: 1200,
                propertyType: .apartment,
                images: ["property4", "property5", "property6"],
                features: [
                    PropertyFeature(id: UUID(), name: "Gym", icon: "figure.run"),
                    PropertyFeature(id: UUID(), name: "Parking", icon: "car.fill"),
                    PropertyFeature(id: UUID(), name: "Security", icon: "lock.shield.fill")
                ],
                status: .forSale
            ),
            Property(
                id: UUID(),
                title: "Cozy Townhouse",
                description: "Perfect for small families or young professionals",
                price: 450_000,
                address: "789 Suburban Lane, Pasadena, CA",
                location: CLLocationCoordinate2D(latitude: 34.1478, longitude: -118.1445),
                bedrooms: 3,
                bathrooms: 2,
                squareFootage: 1800,
                propertyType: .townhouse,
                images: ["property7", "property8", "property9"],
                features: [
                    PropertyFeature(id: UUID(), name: "Patio", icon: "leaf.fill"),
                    PropertyFeature(id: UUID(), name: "Storage", icon: "archivebox.fill"),
                    PropertyFeature(id: UUID(), name: "Laundry", icon: "washer.fill")
                ],
                status: .pending
            )
        ]
        
        properties = mockProperties
    }
    
    func toggleFilter(_ type: Property.PropertyType) {
        if selectedFilters.contains(type) {
            selectedFilters.remove(type)
        } else {
            selectedFilters.insert(type)
        }
    }
    
    func updatePriceRange(_ range: ClosedRange<Double>) {
        priceRange = range
    }
    
    func selectProperty(_ property: Property) {
        selectedProperty = property
    }
}