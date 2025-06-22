import SwiftUI
//  Music bar.swift
//  PaceSync (Frontend)
//
//  Created by Yueran Lu on 2025-06-07.
//

struct MusicBar: View{
    
    @State private var musicProgress: Double = 0
    // this is to decide whther the pause or play appears
    @State private var isPlaying: Bool = true
    
    var body: some View{
        // vstack of everything
        VStack(spacing:10){
            
            // vstack of the title and artist name
            VStack{
                Text("Song Name")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("Artist")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
            }
            
            // vstack of the bar
            VStack{
                // $ =binding variable
                Slider(value: $musicProgress, in: 0...100)
                HStack{
                    Text("0:00")// need to create function to track this
                    Spacer()
                    Text("3.00")
                }
                .font(.caption)
                .foregroundColor(.black.opacity(0.7))
            }
            // Hstack of play pause and next
            HStack(spacing: 40){
                Image(systemName: "backward.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                Button(action: {
                    // everytime that button is pressed isplayingtoggles
                    isPlaying.toggle()
                    // result of button
                }) {
                    Image(systemName: isPlaying ? "pause.fill": "play.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                
            }
        }
        .padding()
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                .padding(.horizontal)

    }

}


#Preview{
    MusicBar()
}
