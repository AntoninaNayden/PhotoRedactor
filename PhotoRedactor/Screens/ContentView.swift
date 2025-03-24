import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            Group {
                if authManager.isLoggedIn  {
                    RedactorView()
                } else {
                    if authManager.hasAccount {
                        LoginView()
                    } else {
                        RegisterView()
                    }
                }
            }
            .onAppear {
                checkIfUserHasAccount()
            }
        }
    }
    
    private func checkIfUserHasAccount() {
        if let _ = Auth.auth().currentUser {
            authManager.hasAccount = true
            authManager.isLoggedIn = false
        } else {
            authManager.hasAccount = false
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}

