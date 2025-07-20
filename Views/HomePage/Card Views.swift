import SwiftUI  // Import the SwiftUI framework to build declarative user interfaces

struct ContentCard: View {
  
    let title: String           // Title text for the card
    let subtitle: String        // Subtitle text for the card
    let backgroundColor: Color  // Color used in the top section

    @State private var isPressed = false
    // State variable that tracks if the card is being pressed
    // Used for animation when user taps/presses the card

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Vertical stack with spacing between child views
            // Aligns content to the leading (left) edge

    
            ZStack {
                // ZStack overlays views on top of each other

                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)        // Fill with the given color
                    .frame(height: 100)           // Fixed height

                Image(systemName: "music.note")
                    // SF Symbol icon
                    .font(.system(size: 30, weight: .medium))  // Set font size and weight
                    .foregroundColor(.white)      // Icon color
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold)) // Title font style
                    .foregroundColor(.primary)   // Adapts to light/dark mode
                    .lineLimit(2)                // Max 2 lines of text
                    .multilineTextAlignment(.leading)  // Align text to the left

                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))  // Subtitle font
                    .foregroundColor(.secondary)  // Light gray color
                    .lineLimit(1)                 // Truncate after 1 line
            }

            Spacer()
            // Pushes everything up, leaves space at the bottom
        }


        .padding(8)
        // Padding inside the card (space between content and border)

        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))  // Card background color (light/dark mode aware)
                .shadow(
                    color: Color.black.opacity(0.1),  // Light drop shadow
                    radius: 4,                        // How soft the shadow is
                    x: 0, y: 2                        // Offset the shadow down
                )
        )

        .scaleEffect(isPressed ? 0.95 : 1.0)
        // Slightly shrink the card visually when pressed

        .animation(.easeInOut(duration: 0.1), value: isPressed)
        // Animate the scale change when isPressed changes

        .onTapGesture {
            handleCardTap()  // Trigger tap logic (prints, haptics, etc.)
        }

        .pressEvents {
            // Custom onPress handler using a gesture (defined below)
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true  // Set pressed state on tap down
            }
        } onRelease: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false  // Release the pressed state on tap up
            }
        }
    }


    private func handleCardTap() {
        print("Card tapped: \(title)")
        // Print to console when card is tapped

        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        // Trigger medium haptic feedback (vibration on tap)

        // Placeholder for navigation or action (e.g., open detail view)
    }
}


// Adds gesture handling for press/release state
extension View {
    func pressEvents(onPress: @escaping () -> Void = {}, onRelease: @escaping () -> Void = {}) -> some View {
        // Use a DragGesture with minimum distance 0 to detect touch-down and touch-up
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPress()  // Call onPress when finger touches down
                }
                .onEnded { _ in
                    onRelease()  // Call onRelease when finger lifts up
                }
        )
    }
}
