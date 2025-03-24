import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var textBoes : [TextBox] = []
    @Published var addNewBox = false
    @Published var currentIndex : Int = 0
    @Published var rect: CGRect = .zero
    func cancelImaheEditing(){
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }
    func cancelTextView(){
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation{
            addNewBox = false
        }
        
        textBoes.removeLast()
    }
    func saveImage() {
        guard rect.size.width > 0 && rect.size.height > 0 else {
            print("Invalid rect size: \(rect.size)")
            return
        }
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image { ctx in
            canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
            let textView = ZStack {
                ForEach(textBoes) { box in
                    Text(box.text)
                        .fontWeight(box.isBold ? .bold : .none)
                        .foregroundColor(box.textColor)
                        .offset(box.offset)
                }
            }
            
            let controller = UIHostingController(rootView: textView).view!
            controller.frame = CGRect(origin: .zero, size: rect.size)
            controller.backgroundColor = .clear
            controller.drawHierarchy(in: controller.frame, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
