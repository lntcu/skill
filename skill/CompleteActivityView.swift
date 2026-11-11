import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation

struct CompleteActivityView: View {
    let skill: Skill
    let activity: ActivitySuggestion
    let minutes: Int
    let checked: Set<Int>
    var onComplete: () -> Void
    @Environment(\.modelContext) private var context
    @State private var photoItem: PhotosPickerItem?
    @State private var photo: Data?
    @State private var showingCamera = false
    @State private var loadingPhoto = false
    @State private var error: String?
    @State private var saved = false

    var body: some View {
        List {
            Section {
                Text(activity.title)
                    .font(.headline)
                if let photo, let image = UIImage(data: photo) {
					Image(uiImage: image).resizable().scaledToFit()
						.clipShape(.rect(cornerRadius: 16))
						.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                }
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Text("Upload Photo")
                }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("Take Photo") {
                        Task { await openCamera() }
                    }
                }
                if loadingPhoto { LoadingView(text: "Loading photo…") }
                if let error { Text(error).foregroundStyle(.red) }
            }
        }
        .navigationTitle("Completed")
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            Button("Complete Activity", action: complete)
                .bottomActionStyle()
                .disabled(loadingPhoto || saved)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView { photo = $0 }
        }
        .task(id: photoItem) {
            guard let photoItem else { return }
            error = nil
            loadingPhoto = true
            defer { loadingPhoto = false }
            do {
                guard let data = try await photoItem.loadTransferable(type: Data.self),
                      let image = UIImage(data: data), let jpeg = image.jpegData(compressionQuality: 0.7) else {
                    throw CocoaError(.fileReadCorruptFile)
                }
                try Task.checkCancellation()
                photo = jpeg
            } catch {
                if !Task.isCancelled { self.error = "Couldn't load the photo. Please try another." }
            }
        }
    }

    private func openCamera() async {
        error = nil
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        if granted {
            showingCamera = true
        } else {
            error = "Allow camera access in Settings to take a photo, or upload one instead."
        }
    }

    private func complete() {
        guard !saved else { return }
        let log = Activity(activity.title, isCompleted: true)
        log.details = activity.description
        log.targets = activity.targets
        log.checkedTargets = checked.sorted()
        log.durationMinutes = minutes
        log.completedAt = .now
        log.photo = photo
        skill.activities.append(log)
        do {
            try context.save()
            saved = true
            onComplete()
        } catch {
            skill.activities.removeAll { $0 === log }
            context.delete(log)
            self.error = "Couldn't save the activity. Please try again."
        }
    }
}

#Preview {
    NavigationStack {
        CompleteActivityView(skill: Skill.examples[0], activity: .example, minutes: 30, checked: [0], onComplete: {})
    }
    .modelContainer(previewContainer())
}
