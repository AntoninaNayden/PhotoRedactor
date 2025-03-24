import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            FlowerBack()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                    .padding(.top, 60)
                
                Spacer()
                
                TextField("Email", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 2)
                            .background(Color.white)
                            .cornerRadius(12)
                    )
                    .padding(.horizontal, 24)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 2)
                            .background(Color.white)
                            .cornerRadius(12)
                    )
                    .padding(.horizontal, 24)
                
                Button {
                    if authManager.isValidEmail(email) && authManager.isValidPassword(password) {
                        authManager.register(email: email, password: password)
                    } else {
                        authManager.errorMessage = "Invalid email or password"
                        showAlert = true
                    }
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.yellow)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Already have an account? Log In")
                        .foregroundColor(Color.yellow)
                        .font(.body)
                        .underline()
                }
                .padding(.top, 10)

               
                
                if let error = authManager.errorMessage {
                    Text(error)
                        .foregroundColor(error.contains("sent") ? .green : .red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(authManager.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthManager())
}

