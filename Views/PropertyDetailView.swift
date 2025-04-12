import SwiftUI
import MapKit

struct PropertyDetailView: View {
    let property: Property
    @State private var selectedImageIndex = 0
    @State private var showingContactForm = false
    @State private var contactName = ""
    @State private var contactEmail = ""
    @State private var contactMessage = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageGallery
                propertyDetails
                mapView
                featuresSection
                contactButton
            }
        }
        .navigationTitle(property.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactForm) {
            contactForm
        }
        .alert("Message Sent", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var imageGallery: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(property.images.indices, id: \.self) { index in
                if let imageName = property.images[safe: index] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .tag(index)
                } else {
                    Color.gray.opacity(0.3)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                        .tag(index)
                }
            }
        }
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    private var propertyDetails: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("$\(property.price, specifier: "%.0f")")
                    .font(AppTheme.Typography.title)
                    .foregroundColor(AppTheme.Colors.primary)
                
                Spacer()
                
                Text(property.status.rawValue.capitalized)
                    .font(AppTheme.Typography.subheadline)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.primary.opacity(0.1))
                    .foregroundColor(AppTheme.Colors.primary)
                    .cornerRadius(AppTheme.CornerRadius.small)
            }
            
            Text(property.address)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Divider()
            
            HStack(spacing: AppTheme.Spacing.xl) {
                VStack {
                    Text("\(property.bedrooms)")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("Bedrooms")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                VStack {
                    Text("\(property.bathrooms)")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("Bathrooms")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                VStack {
                    Text("\(property.squareFootage)")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("Sq Ft")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            
            Divider()
            
            Text("Description")
                .font(AppTheme.Typography.headline)
            
            Text(property.description)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.surface)
    }
    
    private var mapView: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: property.location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )), annotationItems: [property]) { property in
            MapAnnotation(coordinate: property.location) {
                VStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(AppTheme.Colors.primary)
                        .font(.title)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .padding(AppTheme.Spacing.lg)
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Features")
                .font(AppTheme.Typography.headline)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(property.features) { feature in
                        VStack {
                            Image(systemName: feature.icon)
                                .font(.title2)
                                .foregroundColor(AppTheme.Colors.primary)
                            Text(feature.name)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .frame(width: 80, height: 80)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
        }
        .padding(.vertical, AppTheme.Spacing.lg)
    }
    
    private var contactButton: some View {
        Button(action: { showingContactForm = true }) {
            Text("Contact Agent")
                .font(AppTheme.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.primary)
                .cornerRadius(AppTheme.CornerRadius.medium)
        }
        .padding(AppTheme.Spacing.lg)
    }
    
    private var contactForm: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    TextField("Name", text: $contactName)
                    TextField("Email", text: $contactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Message")) {
                    TextEditor(text: $contactMessage)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Send Message") {
                        sendMessage()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(AppTheme.Colors.primary)
                    .disabled(contactName.isEmpty || contactEmail.isEmpty || contactMessage.isEmpty)
                }
            }
            .navigationTitle("Contact Agent")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMessage() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: contactEmail) else {
            alertMessage = "Please enter a valid email address"
            showingAlert = true
            return
        }
        
        print("Sending message from \(contactName) (\(contactEmail)): \(contactMessage)")
        
        alertMessage = "Your message has been sent successfully!"
        showingAlert = true
        
        contactName = ""
        contactEmail = ""
        contactMessage = ""
        showingContactForm = false
    }
}