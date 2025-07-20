import SwiftUI
//  PlayList Bar.swift
//  PaceSync (Frontend)
//
//  Created by Yueran Lu on 2025-06-23.
//

struct PlaylistBar: View{
    // variable declarations
    
    // tracks whic variable is selected for tha bar so it can witch the informatino it displays
    @State private var selectedCategory: CateogoryType = .playlists
    
    // decides whtether or not the search view is shown
    @State showSearchView = false
    
    // top bar that selects the other views
    var body: some View {
        // built in dwift function that is a nvaigation controller thingky
        NavigationView{
            VStack(spacing: 20){
                
                // view for actual top bar, passes the values for selecte category into it and showeing search, binding so if you change it here it gets changed elsewhere too
                TopBarView{
                selectedCategory: $selectedCategory
                    
                }
                .padding(.horizontal)
                
                HorizontalScrollView(selectedCategory: selectedCategory)
                
                Spacer()
            }
            .background(Color(.systemBackground))
            // Sets the background color of the VStack to the system background

            .navigationBarHidden(true)
            // Hides the default navigation bar
        }
        .sheet(isPresented: $showingSearch) {
            // Presents a modal sheet when `showingSearch` is true.
            // The sheet content is defined below.
            SearchView()
        }
        
    }
}

// search view ( placeholrder for now)
struct searchView: View{
    // when dismiss button is tapped, it will close/dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        NavigationView{
            VStack {
                Text("Search functionality")
                .font(.title2)
                .foregroundColor(.secondary)
                // Placeholder text for search UI

                Spacer()
                // Pushes the text to the top, leaving space below.
            }
            .navigationTitle("Search")
            // Sets the navigation bar title
            .navigationBarTitleDisplayMode(.inline)
            // Ensures the title is small and inline (not large format)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                        // Calls the dismiss function to close the sheet
                    }
                }
            }
        }
    }
}
