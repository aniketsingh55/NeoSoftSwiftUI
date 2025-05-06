

import SwiftUI

struct Splash: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack {
                Text("NeoSoft")
                    .font(.largeTitle)
                    .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

