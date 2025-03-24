import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            model.saveImage()
                        }, label: {
                            Text("Save")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Button(action: {
                            model.textBoes.append(TextBox())
                            model.currentIndex = model.textBoes.count - 1
                            withAnimation {
                                model.addNewBox.toggle()
                            }
                            model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                            model.canvas.resignFirstResponder()
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        })
                    }
                    
                    CanvasView(canvas: $model.canvas,
                             imageData: $model.imageData,
                             toolPicker: $model.toolPicker,
                             rect: geometry.size)
                        .environmentObject(model)
                    
                    ZStack {
                        ForEach($model.textBoes) { $box in
                            TextBoxView(box: $box, isEditing: Binding(
                                get: { model.currentIndex == model.textBoes.firstIndex(of: box) && model.addNewBox },
                                set: { _ in }
                            ))
                        }
                    }
                }
            }
        }
    }
}

struct TextBoxView: View {
    @Binding var box: TextBox
    @Binding var isEditing: Bool
    
    var body: some View {
        Text(isEditing ? "" : box.text)
            .fontWeight(box.isBold ? .bold : .none)
            .foregroundColor(box.textColor)
            .offset(box.offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let current = value.translation
                        let lastOffset = box.lastOffset
                        box.offset = CGSize(width: lastOffset.width + current.width,
                                           height: lastOffset.height + current.height)
                    }
                    .onEnded { value in
                        box.lastOffset = box.offset
                    }
            )
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    var rect: CGSize
    @EnvironmentObject var model: DrawingViewModel
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            DispatchQueue.main.async {
                model.rect = CGRect(origin: .zero, size: rect)
            }
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.bounds.size != rect {
            DispatchQueue.main.async {
                model.rect = CGRect(origin: .zero, size: rect)
            }
        }
    }
}

#Preview {
    RedactorView()
}
