
import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    
    // Animation states
    @State private var logoFloating = false
    @State private var logoPulsing = false
    @State private var textAppeared = false
    
    var body: some View {
        Group {
            if showSplash {
                GeometryReader { geometry in
                    ZStack {
                        Color.black
                        
                        // Lavender — #AF99FD
                        Circle()
                            .foregroundStyle(
                                Color(red: 0.686, green: 0.600, blue: 0.992)
                            )
                            .frame(width: geometry.size.width * 0.8)
                            .blur(radius: 100)
                            .offset(
                                x: logoFloating ? geometry.size.width * 0.4 : -geometry.size.width * 0.4,
                                y: -geometry.size.height * 0.2
                            )
                            .opacity(0.35)
                        
                        // Periwinkle — #7F81FF
                        Circle()
                            .foregroundStyle(
                                Color(red: 0.498, green: 0.506, blue: 1.000)
                            )
                            .frame(width: geometry.size.width * 0.7)
                            .blur(radius: 110)
                            .offset(
                                x: logoFloating ? -geometry.size.width * 0.35 : geometry.size.width * 0.35,
                                y: geometry.size.height * 0.25
                            )
                            .opacity(0.3)
                        
                        // Burnt Orange — #B75718
                        Circle()
                            .foregroundStyle(
                                Color(red: 0.718, green: 0.341, blue: 0.094)
                            )
                            .frame(width: geometry.size.width * 0.65)
                            .blur(radius: 110)
                            .offset(
                                x: logoPulsing ? geometry.size.width * 0.35 : -geometry.size.width * 0.35,
                                y: logoFloating ? geometry.size.height * 0.35 : -geometry.size.height * 0.15
                            )
                            .opacity(0.3)
                        
                        // White
                        Circle()
                            .fill(.white)
                            .frame(width: geometry.size.width * 0.3)
                            .blur(radius: 100)
                            .offset(
                                x: 0,
                                y: logoPulsing ? -geometry.size.height * 0.35 : geometry.size.height * 0.35
                            )
                            .opacity(0.08)
                        
                        VStack(spacing: geometry.size.height * 0.025) {
                            // MARK: Animated Logo
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: min(geometry.size.width * 0.38, 180),
                                    height: min(geometry.size.height * 0.22, 180)
                                )
                                .scaleEffect(logoPulsing ? 1.06 : 0.96)
                                .offset(y: logoFloating ? -10 : 10)
                                .shadow(
                                    color: Color(red: 0.686, green: 0.600, blue: 0.992)
                                        .opacity(logoPulsing ? 0.45 : 0.12),
                                    radius: logoPulsing ? 25 : 8
                                )
                                .onAppear {
                                    
                                    // Floating movement
                                    withAnimation(
                                        .easeInOut(duration: 2)
                                        .repeatForever(autoreverses: true)
                                    ) {
                                        logoFloating = true
                                    }
                                    
                                    // Breathing and glow
                                    withAnimation(
                                        .easeInOut(duration: 1.8)
                                        .repeatForever(autoreverses: true)
                                    ) {
                                        logoPulsing = true
                                    }
                                }
                            
                            // MARK: App Name
                            Text("Journali")
                                .font(
                                    .system(
                                        size: min(geometry.size.width * 0.10, 42),
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.white
                                )
                                .opacity(textAppeared ? 1 : 0)
                                .offset(y: textAppeared ? 0 : 12)
                            
                            // MARK: Subtitle
                            Text("Your thoughts, your story")
                                .font(
                                    .system(
                                        size: min(geometry.size.width * 0.045, 18)
                                    )
                                )
                                .foregroundStyle(.white.opacity(0.75))
                                .opacity(textAppeared ? 1 : 0)
                                .offset(y: textAppeared ? 0 : 12)
                        }
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0).delay(1.0)) {
                        textAppeared = true
                    }
                }
                
            } else {
            JournalView()
            }
        }
        .preferredColorScheme(.dark)
        .task {
            try? await Task.sleep(for: .seconds(5))
            showSplash = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

#Preview {
    ContentView()
}
