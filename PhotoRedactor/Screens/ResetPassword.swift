import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 20)
                
                TextField("Enter your email", text: $email)
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
                    if authManager.isValidEmail(email) {
                        authManager.resetPassword(email: email)
                        dismiss()
                    } else {
                        authManager.errorMessage = "Invalid email format."
                        authManager.isSuccess = false
                        authManager.showAlert = true
                    }
                } label: {
                    Text("Send Reset Link")
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
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .background(FlowerBack())
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $authManager.showAlert) {
            Alert(
                title: Text(authManager.isSuccess ? "Success" : "Error"),
                message: Text(authManager.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(AuthManager())
}
