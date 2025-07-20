import SwiftUI

struct HorizontalScrollView: View {
    // MARK: - Properties
    let selectedCategory: CategoryType
    
    // Sample data for demonstration - you can replace this with real data later
    private var sampleCards: [SampleCard] {
        switch selectedCategory {
        case .playlists:
            return [
                SampleCard(title: "Chill Vibes", subtitle: "Relaxing music", color: .purple),
                SampleCard(title: "Workout Mix", subtitle: "High energy tracks", color: .red),
                SampleCard(title: "Study Session", subtitle: "Focus music", color: .blue),
                SampleCard(title: "Road Trip", subtitle: "Adventure awaits", color: .orange),
                SampleCard(title: "Late Night", subtitle: "Smooth vibes", color: .indigo)
            ]
        case .genres:
            return [
                SampleCard(title: "Pop", subtitle: "Popular hits", color: .pink),
                SampleCard(title: "Rock", subtitle: "Classic & modern", color: .red),
                SampleCard(title: "Hip Hop", subtitle: "Urban beats", color: .orange),
                SampleCard(title: "Electronic", subtitle: "Digital sounds", color: .blue),
                SampleCard(title: "Jazz", subtitle: "Smooth jazz", color: .brown)
            ]
        case .songs:
            return [
                SampleCard(title: "Midnight Dreams", subtitle: "Luna Park", color: .purple),
                SampleCard(title: "Summer Breeze", subtitle: "Ocean Waves", color: .teal),
                SampleCard(title: "Electric Nights", subtitle: "Neon City", color: .blue),
                SampleCard(title: "Golden Hour", subtitle: "Sunset Drive", color: .yellow),
                SampleCard(title: "Rainy Day", subtitle: "Cloud Nine", color: .gray)
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Title
            HStack {
                Text(selectedCategory.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Horizontal Scroll View with 10 cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10, id: \.self) { index in
                        let card = sampleCards[index % sampleCards.count]
                        ContentCard(
                            title: card.title,
                            subtitle: card.subtitle,
                            backgroundColor: card.color
                        )
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedCategory)
    }
}

// MARK: - Sample Card Model (Frontend Only)
struct SampleCard {
    let title: String
    let subtitle: String
    let color: Color
}

// MARK: - Preview
struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HorizontalScrollView(selectedCategory: .playlists)
            HorizontalScrollView(selectedCategory: .genres)
            HorizontalScrollView(selectedCategory: .songs)
        }
        .background(Color(.systemBackground))
    }
}

