import SwiftUI

struct FlowerBack: View {
    @State private var f1Offset: CGFloat = -500
    @State private var f2Offset: CGFloat = 500
    @State private var f3Offset: CGFloat = -150
    @State private var f4Offset: CGFloat = 340
    @State private var f5Offset: CGFloat = -50
    @State private var f22Offset: CGFloat = 10
    @State private var f12Offset: CGFloat = 500
    @State private var f32Offset: CGFloat = -150
    @State private var f42Offset: CGFloat = 120
    @State private var f52Offset: CGFloat = 200
    @State private var f13Offset: CGFloat = 400
    
    @State private var blurAmount: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("flower1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.3)
                    .offset(x: -geometry.size.width * 0.35, y: f1Offset - geometry.size.height * 0.1)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1)) {
                            f1Offset = -geometry.size.height * 0.3
                            blurAmount = 4
                        }
                    }

                Image("flower2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.4)
                    .offset(x: geometry.size.width * 0.35, y: f2Offset -  geometry.size.height * 0.14)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f2Offset = -geometry.size.height * 0.2
                            blurAmount = 4
                        }
                    }

                Image("flower3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.35)
                    .offset(x: -geometry.size.width * 0.04, y: f3Offset - geometry.size.height * 0.31)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.4)) {
                            f3Offset = 0
                            blurAmount = 4
                        }
                    }

                Image("flower4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.25)
                    .offset(x: geometry.size.width * 0.4, y: f4Offset)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.6)) {
                            f4Offset = 0
                            blurAmount = 4
                        }
                    }

                Image("flower5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.3)
                    .offset(x: 0, y: f5Offset + geometry.size.height * 0.1)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.8)) {
                            f5Offset = geometry.size.height * 0.3
                            blurAmount = 4
                        }
                    }
                
                Image("flower2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.4)
                    .offset(x: geometry.size.width * 0.15, y: f22Offset)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f22Offset = -geometry.size.height * 0.1
                            blurAmount = 2
                        }
                    }
                Image("flower1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.34)
                    .offset(x: geometry.size.width * 0.31, y: f12Offset + geometry.size.height * 0.28)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f12Offset = -geometry.size.height * 0.1
                            blurAmount = 2
                        }
                    }
                Image("flower3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.44)
                    .offset(x: geometry.size.width * -0.11, y: f32Offset + geometry.size.height * 0.344)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f22Offset = -geometry.size.height * 0.1
                            blurAmount = 2
                        }
                    }
                
                Image("flower1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.34)
                    .offset(x: geometry.size.width * -0.31, y: f13Offset + geometry.size.height * 0.40)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f13Offset = -geometry.size.height * 0.1
                            blurAmount = 2
                        }
                    }
            
                Image("flower4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.23)
                    .offset(x: geometry.size.width * -0.3, y: f42Offset + 400)
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f42Offset = -geometry.size.height * 0.65
                            blurAmount = 2
                        }
                    }
                Image("flower5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.4)
                    .offset(x: geometry.size.width * -0.2, y: f52Offset - geometry.size.height * 0.14 )
                    .blur(radius: blurAmount)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).delay(0.2)) {
                            f52Offset = -geometry.size.height * 0.1
                            blurAmount = 2
                        }
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FlowerBack()
}

