//
//  SettingsView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animationToggle = false
    @State private var showContactAlert = false
    @State private var buttonScale: [String: CGFloat] = [:]
    
    var body: some View {
        ZStack {
            // Background gradient matching app style
            LinearGradient(
                colors: [
                    Color(hex: "1a1a2e"),
                    Color(hex: "16213e"),
                    Color(hex: "0f3460")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating particles animation
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 3...8))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(animationToggle ? CGFloat.random(in: 0.8...1.2) : 0.5)
                    .opacity(animationToggle ? CGFloat.random(in: 0.3...0.7) : 0.1)
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...3)),
                        value: animationToggle
                    )
            }
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("exit-btn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        VStack(spacing: 5) {
                            Text("Settings")
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
                            
                            Text("Customize your experience")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Settings icon
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            .scaleEffect(animationToggle ? 1.1 : 1.0)
                            .rotationEffect(.degrees(animationToggle ? 180 : 0))
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                }
                
                // Settings Menu Items
                VStack(spacing: 20) {
                    // Rate Us
                    SettingsMenuItem(
                        icon: "star.fill",
                        title: "Rate Us",
                        subtitle: "Love the game? Leave us a review!",
                        iconColor: "FFD700",
                        backgroundColor: "FF6B6B",
                        buttonScale: buttonScale["rate"] ?? 1.0
                    ) {
                        rateApp()
                    }
                    .scaleEffect(buttonScale["rate"] ?? 1.0)
                    .onTapGesture {
                        animateButton("rate") {
                            rateApp()
                        }
                    }
                    
                    // Contact Us
                    SettingsMenuItem(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        subtitle: "Need help? We're here for you!",
                        iconColor: "45aaf2",
                        backgroundColor: "9c88ff",
                        buttonScale: buttonScale["contact"] ?? 1.0
                    ) {
                        showContactAlert = true
                    }
                    .scaleEffect(buttonScale["contact"] ?? 1.0)
                    .onTapGesture {
                        animateButton("contact") {
                            showContactAlert = true
                        }
                    }
                    
                    // Privacy Policy
                    SettingsMenuItem(
                        icon: "lock.shield.fill",
                        title: "Privacy Policy",
                        subtitle: "Learn how we protect your data",
                        iconColor: "26de81",
                        backgroundColor: "3742fa",
                        buttonScale: buttonScale["privacy"] ?? 1.0
                    ) {
                        openPrivacyPolicy()
                    }
                    .scaleEffect(buttonScale["privacy"] ?? 1.0)
                    .onTapGesture {
                        animateButton("privacy") {
                            openPrivacyPolicy()
                        }
                    }
                    
                    // Terms of Use
                    SettingsMenuItem(
                        icon: "doc.text.fill",
                        title: "Terms of Use",
                        subtitle: "App terms and conditions",
                        iconColor: "f9ca24",
                        backgroundColor: "FF6B6B",
                        buttonScale: buttonScale["terms"] ?? 1.0
                    ) {
                        openTermsOfUse()
                    }
                    .scaleEffect(buttonScale["terms"] ?? 1.0)
                    .onTapGesture {
                        animateButton("terms") {
                            openTermsOfUse()
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // App Version
                VStack(spacing: 10) {
                    Text("GoBobbas")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Version 1.0")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Made with ❤️ by Hadevs")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animationToggle.toggle()
            }
        }
        .alert("Contact Support", isPresented: $showContactAlert) {
            Button("Email Us", action: {
                openEmailApp()
            })
            Button("Copy Email", action: {
                copyEmailToClipboard()
            })
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Get help from our support team at support@gobobbas.com")
        }
    }
    
    // MARK: - Animation Functions
    
    private func animateButton(_ key: String, completion: @escaping () -> Void) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale[key] = 0.95
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale[key] = 1.0
            }
            completion()
        }
    }
    
    // MARK: - Action Functions
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/40aa73bf-23c4-4b39-8680-e1bf2afa5b2d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfUse() {
        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openEmailApp() {
        if let url = URL(string: "mailto:support@gobobbas.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func copyEmailToClipboard() {
        UIPasteboard.general.string = "support@gobobbas.com"
        
        // Show some visual feedback that email was copied
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

struct SettingsMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: String
    let backgroundColor: String
    let buttonScale: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: backgroundColor), Color(hex: backgroundColor).opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: Color(hex: backgroundColor).opacity(0.5), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: iconColor))
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Arrow indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
