import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data
    @Binding var showPicker: Bool
    
    func makeCoordinator() -> Coordinator{
        return ImagePicker.Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
      
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
                parent.imageData = imageData
                parent.showPicker.toggle()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showPicker.toggle()
        }
    }
}

