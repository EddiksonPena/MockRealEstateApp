import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = PropertyViewModel()
    @State private var selectedTab = 0
    @State private var showFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        featuredPropertiesCarousel
                        searchBar
                        propertyTypeFilters
                        propertyGrid
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Find Your Home")
            .sheet(isPresented: $showFilters) {
                FilterView(viewModel: viewModel)
            }
            .navigationDestination(for: Property.self) { property in
                PropertyDetailView(property: property)
            }
        }
    }
    
    private var featuredPropertiesCarousel: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Featured Properties")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.properties.prefix(5)) { property in
                        NavigationLink(value: property) {
                            FeaturedPropertyCard(property: property)
                        }
                    }
                }
                .padding(.vertical, AppTheme.Spacing.sm)
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            TextField("Search properties...", text: $viewModel.searchText)
                .font(AppTheme.Typography.body)
            
            Button(action: { showFilters = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(AppTheme.Colors.primary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadows.small.color, radius: AppTheme.Shadows.small.radius)
    }
    
    private var propertyTypeFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(Property.PropertyType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue.capitalized,
                        isSelected: viewModel.selectedFilters.contains(type),
                        action: { viewModel.toggleFilter(type) }
                    )
                }
            }
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }
    
    private var propertyGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
            GridItem(.flexible(), spacing: AppTheme.Spacing.md)
        ], spacing: AppTheme.Spacing.md) {
            ForEach(viewModel.filteredProperties) { property in
                NavigationLink(value: property) {
                    PropertyCard(property: property)
                }
            }
        }
    }
}

struct FeaturedPropertyCard: View {
    let property: Property
    @State private var imageLoadingError = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            if let imageName = property.images.first {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 280, height: 180)
                    .clipped()
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .overlay {
                        if imageLoadingError {
                            Color.gray.opacity(0.3)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                }
                        }
                    }
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: 280, height: 180)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                    }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(property.title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text(property.address)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Text("$\(property.price, specifier: "%.0f")")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.primary)
            }
            .padding(AppTheme.Spacing.sm)
        }
        .frame(width: 280)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadows.medium.color, radius: AppTheme.Shadows.medium.radius)
    }
}

struct PropertyCard: View {
    let property: Property
    @State private var imageLoadingError = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            if let imageName = property.images.first {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .overlay {
                        if imageLoadingError {
                            Color.gray.opacity(0.3)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                }
                        }
                    }
            } else {
                Color.gray.opacity(0.3)
                    .frame(height: 120)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                    }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(property.title)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.text)
                    .lineLimit(1)
                
                Text("$\(property.price, specifier: "%.0f")")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primary)
                
                HStack {
                    Label("\(property.bedrooms)", systemImage: "bed.double.fill")
                    Label("\(property.bathrooms)", systemImage: "bathtub.fill")
                    Label("\(property.squareFootage) sqft", systemImage: "square.fill")
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(AppTheme.Spacing.sm)
        }
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadows.small.color, radius: AppTheme.Shadows.small.radius)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.subheadline)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.surface)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.text)
                .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
}

#Preview {
    HomeView()
}