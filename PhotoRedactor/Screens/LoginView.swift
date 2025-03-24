import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var isShowingResetPassword = false
    @State private var isShowingAlert = false
    
    var body: some View {
        ZStack {
            
            FlowerBack()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Welcome Back!")
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
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 2)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if authManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                        .padding(.top, 10)
                }
                
                Button {
                    if authManager.isValidEmail(email) && authManager.isValidPassword(password) {
                        authManager.login(email: email, password: password)
                    } else {
                        authManager.errorMessage = "Invalid email or password"
                        showAlert = true
                    }
                } label: {
                    Text("Log In")
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
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                Button {
                    isShowingResetPassword = true
                } label: {
                    Text("Forgot password?")
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
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                Button {
                    authManager.signInWithGoogle()
                } label: {
                    HStack {
                        Image(systemName: "globe")
                            .font(.headline)
                        Text("Sign In with Google")
                            .font(.headline)
                    }
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
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 4)
                
                
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(Color.yellow)
                        .font(.body)
                        .underline()
                }
                .padding(.top, 10)

               
                
                if let error = authManager.errorMessage {
                    Text(error)
                        .foregroundColor(error.contains("email verification") ? .green : .red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $isShowingResetPassword) {
            ResetPasswordView()
        }

        .alert(isPresented: $authManager.showAlert) {
            Alert(
                title: Text(authManager.isSuccess ? "Success" : "Error"),
                message: Text(authManager.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}

