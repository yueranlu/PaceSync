import SwiftUI

// Define the available categories (tabs)
enum CategoryType: String, CaseIterable {
    case playlists = "Playlists"  // Raw value is the display text
    case genres = "Genres"
    case songs = "Songs"
}

struct TopBarView: View{
    @Binding var selectedCategory: CategoryType  // Tracks the currently selected tab
    @Binding var showingSearch: Bool
    // hstack for the buttons
    var body: some View {
        HStack(spacing:16){
            Button(action:{
                // when pressed it will show the search view
                showingSearch = true
            }){ // for the search icon
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            
            Hstack(spacing: 8){
                // for loop to display all of the different options
                ForEach(CategoryType.allCases, id: \.self) { category in
                    // button that is selected, this stuff gets pased to the view category button
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        // Animate the selection change
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
struct CategoryButton: View {
    let category: CategoryType //caterogry of button
    let isSelected: Bool
    let action: () -> Void //action to eprform when tapped
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
