import SwiftUI

struct RedactorView: View {
    
    @StateObject var model = DrawingViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if let _ = UIImage(data: model.imageData) {
                        DrawingScreen()
                            .environmentObject(model)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        model.cancelImaheEditing()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    })
                                }
                            }
                    } else {
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            Text("+")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 255/255, green: 223/255, blue: 23/255),
                                            Color(red: 255/255, green: 180/255, blue: 0/255)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius:12))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                                .padding(.horizontal, 24)
                        })
                    }
                }
                .padding(.vertical, 20)
            }
            
            if model.addNewBox {
                Color.black.opacity(0.65)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    TextField("Type Here", text: $model.textBoes[model.currentIndex].text)
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        .foregroundColor(model.textBoes[model.currentIndex].textColor)
                        .padding(.horizontal, 24)

                    HStack(spacing: 16) {
                        Button(action: {
                            model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                            model.canvas.becomeFirstResponder()
                            withAnimation {
                                model.addNewBox = false
                            }
                        }, label: {
                            Text("Add")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 255/255, green: 223/255, blue: 23/255),
                                            Color(red: 255/255, green: 180/255, blue: 0/255)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        })
                        
                        Button(action: {
                            model.cancelTextView()
                        }, label: {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                                .foregroundColor(.black)
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                        })
                    }
                    .padding(.horizontal, 24)
                    
                    ColorPicker("", selection: $model.textBoes[model.currentIndex].textColor)
                        .labelsHidden()
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        .padding(.top, 10)
                }
            }
        }
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePicker(imageData: $model.imageData, showPicker: $model.showImagePicker)
        })
        .background(
            Image("fon")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    RedactorView()
}
