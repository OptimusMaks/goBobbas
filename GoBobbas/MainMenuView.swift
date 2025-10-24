//
//  MainMenuView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import UIKit
import StoreKit

struct ResourceView: View {
    @Binding var animationToggle: Bool
    @ObservedObject var gameService: GameService
    
    var totalBalls: Int {
        gameService.totalCollectedBalls.values.reduce(0, +)
    }
    
    var body: some View {
        ZStack {
            
            Image("resursi-container-btn")
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading, spacing: 0 ) {
                HStack {
                    Text("\(gameService.playerTickets)")
                    Image("tkt-icn")
                        .scaleEffect(animationToggle ? 1.1 : 1)
                }
                
                HStack {
                    Text("\(gameService.totalCollectedBalls.count)")
                    Image("bag-icn")
                    
                }
                
            }.font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(.linearGradient(colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")], startPoint: .top, endPoint: .bottom))
                .offset(x: 30, y: -90)
                
        }
        
    }
}
    
    
struct MainMenuView: View {
    @StateObject private var gameService = GameService()
    @State private var logoAnimTogle = false
    @State private var showHowToPlay = false
    @State private var showGame = false
    @State private var showTreasure = false
    @State private var showTicketShop = false
    @State private var playButtonPressed = false
    @State private var isLoadingGame = false
    @State private var showWonderBanner = true
    @State private var showInsufficientTicketsMessage = false
    @State private var wonderBannerPressed = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Image("menu-bg")
                .resizable()
                .scaledToFill()
                
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: -150) {
                    Color.clear.frame(width: 1, height: 600)
                    Image("logo-bobas")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(logoAnimTogle ? 1.1 : 1)
                    HStack(spacing: -150) {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showHowToPlay = true
                            }
                        }) {
                            Image("how-to-play-btn")
                                .resizable()
                                .scaledToFit()
                        }
//                        .scaleEffect(logoAnimTogle ? 1.05 : 1.0)
                            
                        ResourceView(animationToggle: $logoAnimTogle, gameService: gameService)
                            
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showTreasure = true
                        }
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }) {
                        Image("my-treasure-banner")
                            .rotationEffect(.degrees(logoAnimTogle ? 2 : 0))
                    }
                    
                    Button(action: {
                        playButtonPressed = true
                        isLoadingGame = true
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        
                        // Delay for loading animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showGame = true
                                isLoadingGame = false
                                playButtonPressed = false
                            }
                        }
                    }) {
                        ZStack {
                            Image("play-btn")
                                .scaleEffect(playButtonPressed ? 0.95 : (logoAnimTogle ? 1.05 : 1.0))
                                .rotation3DEffect(
                                    .degrees(playButtonPressed ? 5 : 0),
                                    axis: (x: 1, y: 0, z: 0)
                                )
                                .opacity(isLoadingGame ? 0.7 : 1.0)
                            
                            // Loading animation
                            if isLoadingGame {
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(.degrees(logoAnimTogle ? 360 : 0))
                                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: logoAnimTogle)
                            }
                        }
                    }
                    .disabled(isLoadingGame)
                    .scaleEffect(isLoadingGame ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: playButtonPressed)
                    .animation(.easeInOut(duration: 0.3), value: isLoadingGame)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showTicketShop = true
                        }
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }) {
                        Image("buy-banner")
                            .scaleEffect(logoAnimTogle ? 1.02 : 1.0)
                    }
                    
                    // Wonder Banner with animation
                    if showWonderBanner {
                        Button(action: {
                            wonderBannerPressed = true
                            
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            // Check if user has tickets
                            if gameService.hasTickets() {
                                // Future: Open Path of Wonder feature
                                print("Opening Path of Wonder...")
                            } else {
                                // Hide banner with animation and show insufficient tickets message
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    showWonderBanner = false
                                }
                                
                                // Show insufficient tickets message after banner hides
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                                        showInsufficientTicketsMessage = true
                                    }
                                }
                                
                                // Auto hide message after 3 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        showInsufficientTicketsMessage = false
                                        showWonderBanner = true
                                    }
                                }
                            }
                            
                            // Reset button press state
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                wonderBannerPressed = false
                            }
                        }) {
                            
                            Image("wonder-banner")
                                .scaleEffect(wonderBannerPressed ? 0.95 : (logoAnimTogle ? 1.02 : 1.0))
                                .rotation3DEffect(
                                    .degrees(wonderBannerPressed ? 3 : 0),
                                    axis: (x: 1, y: 0, z: 0)
                                )
                                .opacity(wonderBannerPressed ? 0.8 : 1.0)
                        }
                        .scaleEffect(showWonderBanner ? 1.0 : 0.0)
                        .opacity(showWonderBanner ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showWonderBanner)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: wonderBannerPressed)
                    } else {
                        Color.clear.frame(width: 1, height: 150)
                    }
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showSettings = true
                            }
                            
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        }) {
                            Image("settings-btn")
                        }
                        
                        Button(action: {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            // Request app review
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            Image("rateus-btn")
                        }
                    }.padding(.top, -70)
                    HStack {
                        Button(action: {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            // Open Terms of Use
                            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Terms of use")
                                .underline()
                                .foregroundStyle(.black)
                                .font(.system(size: 20, weight: .bold))
                        }
                        
                        Button(action: {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            // Open Privacy Policy
                            if let url = URL(string: "https://www.freeprivacypolicy.com/live/40aa73bf-23c4-4b39-8680-e1bf2afa5b2d") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Privacy policy")
                                .underline()
                                .foregroundStyle(.black)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    .padding(.top, 240)
                    
                    Text("Version 1.0")
                        .opacity(0.6)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 180)
                    Spacer(minLength: 600)
                }
                
                
            }.ignoresSafeArea()
            .onAppear(perform: viewDidLoad)
            
            // Insufficient Tickets Message Overlay
            if showInsufficientTicketsMessage {
                InsufficientTicketsMessageView(
                    isVisible: $showInsufficientTicketsMessage,
                    onBuyTickets: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showInsufficientTicketsMessage = false
                            showTicketShop = true
                            showWonderBanner = true
                        }
                    }
                )
                .zIndex(1000)
            }
        }
        .fullScreenCover(isPresented: $showHowToPlay) {
            HowToPlayView()
        }
        .fullScreenCover(isPresented: $showGame) {
            GameView(gameService: gameService)
        }
        .fullScreenCover(isPresented: $showTreasure) {
            TreasureView(gameService: gameService)
        }
        .fullScreenCover(isPresented: $showTicketShop) {
            TicketShopView(gameService: gameService)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private func viewDidLoad() {
        runAnimationForLogo()
    }
    
    private func runAnimationForLogo() {
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            logoAnimTogle.toggle()
        }
    }
}

struct TicketShopView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @State private var selectedTicketPack: TicketPack? = nil
    @State private var showingPurchaseAnimation = false
    @State private var pulseAnimation = false
    @State private var ticketAnimation = false
    
    let ticketPacks = [
        TicketPack(id: 1, name: "Starter Pack", tickets: 5, price: 50, color: "3742fa"),
        TicketPack(id: 2, name: "Power Pack", tickets: 15, price: 120, color: "f9ca24", isPopular: true),
        TicketPack(id: 3, name: "Ultimate Pack", tickets: 50, price: 350, color: "FF6B6B"),
        TicketPack(id: 4, name: "Mega Pack", tickets: 100, price: 600, color: "26de81")
    ]
    
    var body: some View {
        ZStack {
            // Background
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
            
            // Floating tickets animation
            if showingPurchaseAnimation {
                ForEach(0..<20, id: \.self) { index in
                    Image("tkt-icn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat.random(in: 20...40), height: CGFloat.random(in: 20...40))
                        .position(
                            x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                            y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100)
                        )
                        .scaleEffect(ticketAnimation ? 1.5 : 0.5)
                        .opacity(ticketAnimation ? 0 : 1)
                        .rotationEffect(.degrees(ticketAnimation ? 360 : 0))
                        .animation(
                            .easeOut(duration: 2.5)
                            .delay(Double.random(in: 0...1.5)),
                            value: ticketAnimation
                        )
                }
            }
            
            VStack(spacing: 25) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("exit-btn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("Ticket Shop")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        
                        Text("Buy tickets to play more games")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Current balance
                    VStack(spacing: 2) {
                        Text("💰")
                            .font(.system(size: 20))
                        Text("\(gameService.playerBalance)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(ticketPacks, id: \.id) { pack in
                            TicketPackCard(
                                pack: pack,
                                isSelected: selectedTicketPack?.id == pack.id,
                                canAfford: gameService.playerBalance >= pack.price,
                                pulseAnimation: $pulseAnimation
                            ) {
                                selectedTicketPack = pack
                            } onPurchase: {
                                purchaseTicketPack(pack)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseAnimation.toggle()
            }
        }
    }
    
    private func purchaseTicketPack(_ pack: TicketPack) {
        let success = gameService.spendMoney(pack.price)
        if success {
            // Add tickets to player's account
            gameService.addTickets(pack.tickets)
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showingPurchaseAnimation = true
                ticketAnimation = true
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            // Auto dismiss after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                dismiss()
            }
        }
    }
}

struct TicketPack {
    let id: Int
    let name: String
    let tickets: Int
    let price: Int
    let color: String
    let isPopular: Bool
    
    init(id: Int, name: String, tickets: Int, price: Int, color: String, isPopular: Bool = false) {
        self.id = id
        self.name = name
        self.tickets = tickets
        self.price = price
        self.color = color
        self.isPopular = isPopular
    }
}

struct TicketPackCard: View {
    let pack: TicketPack
    let isSelected: Bool
    let canAfford: Bool
    @Binding var pulseAnimation: Bool
    let onTap: () -> Void
    let onPurchase: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                // Popular badge
                if pack.isPopular {
                    HStack {
                        Spacer()
                        Text("MOST POPULAR")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(hex: "FF6B6B"))
                            )
                        Spacer()
                    }
                    .offset(y: -10)
                }
                
                HStack(spacing: 20) {
                    // Ticket icon and count
                    VStack(spacing: 8) {
                        Image("tkt-icn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                        
                        Text("\(pack.tickets)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(pack.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(pack.tickets) Tickets")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing: 8) {
                            Text("💰")
                                .font(.system(size: 16))
                            Text("\(pack.price)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                        }
                    }
                    
                    Spacer()
                    
                    // Purchase button
                    Button(action: onPurchase) {
                        Text(canAfford ? "BUY" : "NOT ENOUGH")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 35)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        canAfford ?
                                        LinearGradient(
                                            colors: [Color(hex: pack.color), Color(hex: pack.color).opacity(0.8)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ) :
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            .scaleEffect(canAfford && pulseAnimation ? 1.05 : 1.0)
                    }
                    .disabled(!canAfford)
                }
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isSelected ? 0.2 : 0.1),
                            Color.white.opacity(isSelected ? 0.1 : 0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color(hex: pack.color) : Color.white.opacity(0.2),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

struct InsufficientTicketsMessageView: View {
    @Binding var isVisible: Bool
    let onBuyTickets: () -> Void
    @State private var particleAnimation = false
    @State private var pulseAnimation = false
    @State private var textAnimation = false
    
    var body: some View {
        ZStack {
            // Dark overlay background
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isVisible = false
                    }
                }
            
            // Floating ticket particles
            ForEach(0..<15, id: \.self) { index in
                Image("tkt-icn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: CGFloat.random(in: 20...35), height: CGFloat.random(in: 20...35))
                    .position(
                        x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                        y: CGFloat.random(in: 200...UIScreen.main.bounds.height - 200)
                    )
                    .scaleEffect(particleAnimation ? CGFloat.random(in: 0.8...1.2) : 0.5)
                    .opacity(particleAnimation ? CGFloat.random(in: 0.4...0.8) : 0.1)
                    .rotationEffect(.degrees(particleAnimation ? CGFloat.random(in: -15...15) : 0))
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: particleAnimation
                    )
            }
            
            // Main message container
            VStack(spacing: 25) {
                // Lock icon with glow
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.red, Color.red.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 100, height: 100)
                        )
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                }
                
                // Error message
                VStack(spacing: 15) {
                    Text("Path Locked!")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.linearGradient(
                            colors: [Color.white, Color.gray.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .scaleEffect(textAnimation ? 1.05 : 1.0)
                    
                    Text("You need tickets to unlock the\nPath of Wonder")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: onBuyTickets) {
                        HStack(spacing: 12) {
                            Image("tkt-icn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text("Buy Tickets")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: "FFA500").opacity(0.5), radius: 15, x: 0, y: 8)
                        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isVisible = false
                        }
                    }) {
                        Text("Close")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "1a1a2e").opacity(0.95),
                                Color(hex: "16213e").opacity(0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isVisible)
        }
        .onAppear {
            particleAnimation = true
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseAnimation.toggle()
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                textAnimation.toggle()
            }
        }
    }
}

#Preview {
    MainMenuView()
}
                                                          
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
