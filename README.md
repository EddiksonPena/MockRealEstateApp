# Mock Real Estate App

A modern iOS real estate application built with SwiftUI, featuring a beautiful UI, interactive property listings, and advanced search capabilities.

## Features

- 🏠 Modern, card-based property listings
- 🔍 Advanced search and filtering
- 📱 Responsive design with dark mode support
- 🗺️ Interactive maps integration
- 💬 Built-in contact form
- ✨ Custom animations and transitions
- 🎨 Consistent design system

## Screenshots

[Screenshots will be added soon]

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/EddiksonPena/MockRealEstateApp.git
```

2. Open `MockRealEstateApp.xcodeproj` in Xcode

3. Build and run the project

## Project Structure

```
MockRealEstateApp/
├── Models/
│   └── Property.swift
├── ViewModels/
│   └── PropertyViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── PropertyDetailView.swift
│   └── FilterView.swift
├── Theme/
│   └── AppTheme.swift
└── Extensions/
    └── Array+Safe.swift
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures representing properties and their features
- **Views**: SwiftUI views for displaying the UI
- **ViewModels**: Business logic and state management
- **Theme**: Centralized design system for consistent styling

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- SwiftUI for the modern UI framework
- MapKit for map integration
- SF Symbols for the icon set