
import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Activity.completedAt, order: .reverse)
    private var activities: [Activity]

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    private var photoActivities: [Activity] {
        activities.filter { $0.photo != nil }
    }

    var body: some View {

        ScrollView {

            if photoActivities.isEmpty {

                ContentUnavailableView(
                    "No Photos Yet",
                    systemImage: "photo.on.rectangle",
                    description: Text("Complete activities and upload photos to fill your gallery.")
                )
                .padding(.top, 80)

            } else {

                LazyVGrid(columns: columns, spacing: 10) {

                    ForEach(photoActivities) { activity in

                        if let data = activity.photo,
                           let image = UIImage(data: data) {

                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 115)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Gallery")
        .appScreenBackground()
        .tint(.accentTeal)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }

    }
}

#Preview {
    NavigationStack {
        GalleryView()
    }
    .modelContainer(previewContainer())
}

