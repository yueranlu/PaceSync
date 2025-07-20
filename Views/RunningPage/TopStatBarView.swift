

import SwiftUI

struct TopStatsView: View {
    var body: some View {
        HStack(spacing: 20) {
            PaceStat()
            DistanceStat()
            TimeStat()
            CaloriesStat()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
// instead i made a view for each one
struct PaceStat: View {
    var body: some View {
        StatItem(icon: "shoeprints.fill", title: "Pace", value: "8:00", unit: "Min/km")
    }
}

struct DistanceStat: View {
    var body: some View {
        StatItem(icon: "chart.bar.fill", title: "Distance", value: "9.2", unit: "KM")
    }
}

struct TimeStat: View {
    var body: some View {
        StatItem(icon: "timer", title: "Time", value: "1:30", unit: "Min")
    }
}

struct CaloriesStat: View {
    var body: some View {
        StatItem(icon: "fork.knife", title: "Calories", value: "1150", unit: "Kcal")
    }
}
// this is to define the overall item/structure of each of the components
struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#0072C6"))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }

            Text(title)
                .font(.footnote)
                .foregroundColor(Color(hex: "#0072C6"))
                .bold()

            Text(value)
                .font(.headline)
                .foregroundColor(Color(hex: "#0072C6"))

            Text(unit)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TopStatsView()
}
