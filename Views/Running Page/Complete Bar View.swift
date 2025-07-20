import SwiftUI

struct ContentView: View {
    // storesthe variable to strack selected category
    @State private var selectedCategory; CategorytType = .playlists
    @State private car showingSearch = false
    
    // actual view
    var body: some View{
        navigationView{
            VStack(spaacing: 20){
                
                navigationBarView(
                    // feed the seelcted category and showing search true or false into the function, binding varibale in navgation bar view
                    selectedCategory: $selectedCategory
                    showingSearch: $showingSearch
                )
                .padding(.horizontal)
                
                horizontalScrollView(
                    selectedCategory: selectedCategory
                )
                
                Spacer()
            }
            .background(Color(.systembackground))
            // hide the dfeaulut navigation bar
            .navigationBarHidden(true)
        }
    }
}

// view for the search thing

struct searchView: View{
    
    var body: some View{
        
        
    }
}
