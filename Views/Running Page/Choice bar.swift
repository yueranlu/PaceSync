import SwiftUI


// enum with the values of the differnet options

enum selectionType: String, CaseIterable{
    case playlists = "Playlists"
    case genres = "Genres"
    case songs = "Songs"
}

// actual views

struct navigationBarView: View {
    @Binding var selectedCategory: CategoryType
    @Binding var showingSearch: Bool
    
    var body: some View{
        HStack(Spacing:16){
            Button(action:{
                //need to fill this !!!!!
                
            }){// stuff for button appearance
                Image(systemName: "magnifyingglass")
                    .font(.system(size:18, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
            }
            Hestack(Spacing:8){
                
            }
        }
    }
}
