//
//  LoadingView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Image("logo-bobas")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                
                // Loading indicator
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotationAngle)
                }
                
                // Loading text
                Text("Loading...")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.linearGradient(
                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .opacity(isAnimating ? 0.5 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
            rotationAngle = 360
        }
    }
}

#Preview {
    LoadingView()
}
