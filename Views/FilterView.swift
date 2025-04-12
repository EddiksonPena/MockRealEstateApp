import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: PropertyViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Price Range")) {
                    VStack(alignment: .leading) {
                        Text("$\(Int(viewModel.priceRange.lowerBound)) - $\(Int(viewModel.priceRange.upperBound))")
                            .font(AppTheme.Typography.headline)
                        
                        Slider(
                            value: .init(
                                get: { viewModel.priceRange.lowerBound },
                                set: { newValue in
                                    viewModel.updatePriceRange(newValue...viewModel.priceRange.upperBound)
                                }
                            ),
                            in: 0...1000000,
                            step: 10000
                        )
                    }
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
                
                Section(header: Text("Property Type")) {
                    ForEach(Property.PropertyType.allCases, id: \.self) { type in
                        Toggle(type.rawValue.capitalized, isOn: .init(
                            get: { viewModel.selectedFilters.contains(type) },
                            set: { isOn in
                                if isOn {
                                    viewModel.selectedFilters.insert(type)
                                } else {
                                    viewModel.selectedFilters.remove(type)
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("Bedrooms")) {
                    Stepper("Minimum: \(viewModel.minBedrooms)", value: .init(
                        get: { viewModel.minBedrooms },
                        set: { viewModel.minBedrooms = $0 }
                    ), in: 0...10)
                }
                
                Section(header: Text("Bathrooms")) {
                    Stepper("Minimum: \(viewModel.minBathrooms)", value: .init(
                        get: { viewModel.minBathrooms },
                        set: { viewModel.minBathrooms = $0 }
                    ), in: 0...10)
                }
                
                Section(header: Text("Square Footage")) {
                    VStack(alignment: .leading) {
                        Text("Minimum: \(viewModel.minSquareFootage) sqft")
                            .font(AppTheme.Typography.headline)
                        
                        Slider(
                            value: .init(
                                get: { Double(viewModel.minSquareFootage) },
                                set: { viewModel.minSquareFootage = Int($0) }
                            ),
                            in: 0...10000,
                            step: 100
                        )
                    }
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}