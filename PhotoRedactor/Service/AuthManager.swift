import SwiftUI
import FirebaseAuth
import GoogleSignIn

final class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasAccount = false
    @Published var showAlert = false
    @Published var isSuccess = false
    
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isSuccess = false
                    self.showAlert = true
                } else {
                    self.checkEmailVerification()
                }
            }
        }
    }

    func register(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isSuccess = false
                    self.showAlert = true
                } else {
                    self.sendEmailVerification()
                }
            }
        }
    }

    func sendEmailVerification() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.sendEmailVerification { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isSuccess = false
                    self.showAlert = true
                    print("Email verification failed: \(error.localizedDescription)")
                } else {
                    self.errorMessage = "Verification email sent to \(user.email ?? "")"
                    self.isSuccess = true
                    self.showAlert = true
                    print("Verification email sent to \(user.email ?? "")")
                }
            }
        }
    }

    func checkEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.reload { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isSuccess = false
                    self.showAlert = true
                } else {
                    if user.isEmailVerified {
                        print("Email is verified!")
                        self.isLoggedIn = true
                        DispatchQueue.main.async {
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: RedactorView())
                                window.makeKeyAndVisible()
                            }
                        }
                    } else {
                        print("Email is NOT verified!")
                        self.errorMessage = "Please verify your email."
                        self.isSuccess = false
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func resetPassword(email: String) {
         isLoading = true
         errorMessage = nil
         
         Auth.auth().sendPasswordReset(withEmail: email) { error in
             DispatchQueue.main.async {
                 self.isLoading = false
                 if let error = error {
                     self.errorMessage = error.localizedDescription
                     self.isSuccess = false
                 } else {
                     self.errorMessage = "Password reset link sent to \(email)"
                     self.isSuccess = true
                 }
                 self.showAlert = true
             }
         }
     }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Unable to access root view controller"
            self.showAlert = true
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isSuccess = false
                    self.isLoading = false
                    self.showAlert = true
                }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async {
                    self.errorMessage = "Google sign-in failed"
                    self.isSuccess = false
                    self.isLoading = false
                    self.showAlert = true
                }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.isSuccess = false
                        self.showAlert = true
                    } else {
                        self.isLoggedIn = true
                        self.isSuccess = true
                        self.errorMessage = "Successfully signed in with Google"
                        self.showAlert = true
                        DispatchQueue.main.async {
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: RedactorView())
                                window.makeKeyAndVisible()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func completeRegistration() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: RedactorView())
                window.makeKeyAndVisible()
            }
        }
    }

    func checkIfUserExists() {
        if let _ = Auth.auth().currentUser {
            hasAccount = true
        } else {
            hasAccount = false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
            showAlert = true
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}

