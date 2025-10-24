//
//  TreasureView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import UIKit
import Foundation

struct TreasureView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @State private var animationToggle = false
    @State private var selectedBall: BallType? = nil
    @State private var showingStats = false
    @State private var showingCoinConversion = false
    @State private var showingWisdomInterface = false
    @State private var showingIntelligenceInterface = false
    
    var totalCollected: Int {
        gameService.totalCollectedBalls.values.reduce(0, +)
    }
    
    var completionPercentage: Double {
        let collectedTypes = gameService.totalCollectedBalls.count
        return Double(collectedTypes) / Double(BallType.allCases.count) * 100
    }
    
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
            
            // Stars background animation
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: CGFloat.random(in: 2...4))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(animationToggle ? 1.2 : 0.8)
                    .opacity(animationToggle ? 0.8 : 0.3)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: animationToggle
                    )
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
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
                                Text("My Treasure")
                                    .font(.system(size: 36, weight: .black, design: .rounded))
                                    .foregroundStyle(.linearGradient(
                                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
                                
                                Text("Your personal achievement arsenal")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            // Stats button
                            Button(action: {
                                showingStats.toggle()
                            }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        LinearGradient(
                                            colors: [Color(hex: "FF6B6B"), Color(hex: "EE5A24")],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.top, 10)
                        
                        // Progress section
                        VStack(spacing: 10) {
                            HStack {
                                Text("Collection Progress")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(Int(completionPercentage))%")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.linearGradient(
                                        colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            }
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 12)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(10, UIScreen.main.bounds.width * 0.8 * completionPercentage / 100), height: 12)
                                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: completionPercentage)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Collection Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 25) {
                        ForEach(BallType.allCases, id: \.self) { ballType in
                            BallCollectionCard(
                                ballType: ballType,
                                count: gameService.getCollectedCount(for: ballType),
                                isSelected: selectedBall == ballType,
                                animationToggle: $animationToggle
                            ) {
                                if ballType == .yellow && gameService.getCollectedCount(for: ballType) > 0 {
                                    showingCoinConversion = true
                                } else if ballType == .red && gameService.getCollectedCount(for: ballType) > 0 {
                                    showingWisdomInterface = true
                                } else if ballType == .green && gameService.getCollectedCount(for: ballType) > 0 {
                                    showingIntelligenceInterface = true
                                } else {
                                    selectedBall = selectedBall == ballType ? nil : ballType
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Total stats
                    VStack(spacing: 15) {
                        Text("Total Statistics")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 30) {
                            StatCard(
                                title: "Total Balls",
                                value: "\(totalCollected)",
                                icon: "circle.fill",
                                color: Color(hex: "3742fa")
                            )
                            
                            StatCard(
                                title: "Types Found",
                                value: "\(gameService.totalCollectedBalls.count)/\(BallType.allCases.count)",
                                icon: "star.fill",
                                color: Color(hex: "f9ca24")
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animationToggle.toggle()
            }
        }
        .sheet(isPresented: $showingStats) {
            DetailedStatsView(gameService: gameService)
        }
        .sheet(isPresented: $showingCoinConversion) {
            CoinConversionView(gameService: gameService)
        }
        .fullScreenCover(isPresented: $showingWisdomInterface) {
            WisdomExperienceView(gameService: gameService)
        }
        .fullScreenCover(isPresented: $showingIntelligenceInterface) {
            IntelligenceLabView(gameService: gameService)
        }
    }
}

struct BallCollectionCard: View {
    let ballType: BallType
    let count: Int
    let isSelected: Bool
    @Binding var animationToggle: Bool
    let onTap: () -> Void
    
    var isUnlocked: Bool {
        count > 0
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                ZStack {
                    // Background glow
                    if isUnlocked {
                        Circle()
                            .fill(ballType.glowColor.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)
                            .scaleEffect(animationToggle ? 1.1 : 0.9)
                    }
                    
                    // Card background
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: isUnlocked ? [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.1)
                                ] : [
                                    Color.black.opacity(0.3),
                                    Color.black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    isUnlocked ? ballType.glowColor.opacity(0.5) : Color.gray.opacity(0.3),
                                    lineWidth: isSelected ? 3 : 1
                                )
                        )
                        .shadow(color: isUnlocked ? ballType.shadowColor : .black.opacity(0.5), radius: 15, x: 0, y: 8)
                    
                    VStack(spacing: 12) {
                        // Ball image
                        if isUnlocked {
                            Image(ballType.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .scaleEffect(isSelected ? 1.15 : 1.0)
                                .rotationEffect(.degrees(animationToggle ? 5 : -5))
                        } else {
                            Image(ballType.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .colorMultiply(.gray)
                                .opacity(0.3)
                        }
                        
                        // Ball name
                        Text(ballType.rawValue.capitalized)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isUnlocked ? .white : .gray)
                        
                        // Count
                        if isUnlocked {
                            Text("\(count)")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .scaleEffect(isSelected ? 1.2 : 1.0)
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                }
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 3), value: animationToggle)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct DetailedStatsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Detailed Statistics")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
                }
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(BallType.allCases, id: \.self) { ballType in
                            HStack {
                                Image(ballType.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(ballType.rawValue.capitalized)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("Collected: \(gameService.getCollectedCount(for: ballType))")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Text("\(gameService.getCollectedCount(for: ballType))")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(.linearGradient(
                                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct CoinConversionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @State private var ballsToConvert: Double = 1
    @State private var showingSuccessAnimation = false
    @State private var pulseAnimation = false
    @State private var coinAnimation = false
    
    var yellowBallsCount: Int {
        gameService.getCollectedCount(for: .yellow)
    }
    
    var coinsToEarn: Int {
        Int(ballsToConvert) * 10
    }
    
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
            
            // Floating coins animation
            if showingSuccessAnimation {
                ForEach(0..<15, id: \.self) { index in
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: CGFloat.random(in: 20...40), weight: .bold))
                        .foregroundStyle(.linearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .position(
                            x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                            y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100)
                        )
                        .scaleEffect(coinAnimation ? 1.5 : 0.5)
                        .opacity(coinAnimation ? 0 : 1)
                        .animation(
                            .easeOut(duration: 2.0)
                            .delay(Double.random(in: 0...1)),
                            value: coinAnimation
                        )
                }
            }
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("Coin Exchange")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        
                        Text("Convert Bobbass Coins to Money")
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
                
                // Available balls display
                VStack(spacing: 15) {
                    Text("Available Bobbass Coins")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        Image("yellow-ball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        
                        Text("\(yellowBallsCount)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: "f9ca24"), Color(hex: "f0932b")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "f9ca24").opacity(0.5), lineWidth: 2)
                            )
                    )
                }
                
                // Conversion controls
                VStack(spacing: 20) {
                    Text("Select Amount to Convert")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        // Slider
                        VStack(spacing: 10) {
                            HStack {
                                Text("Balls: \(Int(ballsToConvert))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("Coins: \(coinsToEarn)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.linearGradient(
                                        colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            }
                            
                            Slider(
                                value: $ballsToConvert,
                                in: 1...Double(max(1, yellowBallsCount)),
                                step: 1
                            )
                            .accentColor(Color(hex: "f9ca24"))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.1))
                        )
                        
                        // Quick select buttons
                        HStack(spacing: 15) {
                            ForEach([25, 50, 100], id: \.self) { percentage in
                                if yellowBallsCount >= percentage / 25 {
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            ballsToConvert = Double(min(yellowBallsCount * percentage / 100, yellowBallsCount))
                                        }
                                    }) {
                                        Text("\(percentage)%")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 60, height: 35)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color(hex: "f9ca24").opacity(0.3))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color(hex: "f9ca24"), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                            }
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    ballsToConvert = Double(yellowBallsCount)
                                }
                            }) {
                                Text("ALL")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 35)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: "FF6B6B").opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: "FF6B6B"), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                }
                
                // Conversion rate info
                VStack(spacing: 10) {
                    Text("Exchange Rate")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 20) {
                        HStack(spacing: 8) {
                            Image("yellow-ball")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text("1")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 8) {
                            Text("💰")
                                .font(.system(size: 20))
                            Text("10")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                Spacer()
                
                // Convert button
                Button(action: {
                    let success = gameService.convertYellowBallsToMoney(ballsToConvert: Int(ballsToConvert))
                    if success {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showingSuccessAnimation = true
                            coinAnimation = true
                        }
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        
                        // Auto dismiss after animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            dismiss()
                        }
                    }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text("Convert to Money")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("+\(coinsToEarn)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "26de81").opacity(0.3))
                            )
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "f9ca24"), Color(hex: "f0932b")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: Color(hex: "f0932b").opacity(0.5), radius: 15, x: 0, y: 8)
                    .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                }
                .disabled(yellowBallsCount <= 0 || showingSuccessAnimation)
                .opacity(yellowBallsCount <= 0 ? 0.5 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 20)
        }
        .onAppear {
            ballsToConvert = Double(min(yellowBallsCount, 1))
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseAnimation.toggle()
            }
        }
    }
}

// MARK: - Wisdom Experience

enum WisdomCategory: String, CaseIterable {
    case money = "Money"
    case soul = "Soul"
    case relations = "Relations"
    case future = "Future"
    
    var emoji: String {
        switch self {
        case .money: return "💰"
        case .soul: return "🧘‍♀️"
        case .relations: return "💕"
        case .future: return "🔮"
        }
    }
    
    var color: String {
        switch self {
        case .money: return "f9ca24"
        case .soul: return "9c88ff"
        case .relations: return "ff6b9d"
        case .future: return "45aaf2"
        }
    }
    
    var description: String {
        switch self {
        case .money: return "Financial wisdom and prosperity guidance"
        case .soul: return "Inner peace and spiritual growth insights"
        case .relations: return "Love, friendship and connection wisdom"
        case .future: return "Destiny and life path revelations"
        }
    }
}

class WisdomService: ObservableObject {
    @Published var isGenerating = false
    @Published var currentWisdom: String? = nil
    @Published var error: String? = nil
    
    private let apiKey = Config.openAIAPIKey
    
    func generateWisdom(for category: WisdomCategory) {
        guard Config.hasValidAPIKey else {
            error = "API ключ не настроен. Пожалуйста, установите переменную окружения OPENAI_API_KEY."
            isGenerating = false
            return
        }
        
        isGenerating = true
        error = nil
        
        let prompt = """
        You are an ancient Chinese dragon with infinite wisdom. Generate a profound and beautiful piece of wisdom about \(category.rawValue.lowercased()). 
        
        The wisdom should be:
        - Mystical and poetic
        - Practical yet philosophical  
        - In the style of ancient Chinese wisdom
        - 2-3 sentences maximum
        - Inspiring and memorable
        
        Focus on \(category.rawValue.lowercased()) and provide deep insight that can transform someone's perspective.
        """
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a wise Chinese dragon sharing ancient wisdom."
                ],
                [
                    "role": "user", 
                    "content": prompt
                ]
            ],
            "max_tokens": 150,
            "temperature": 0.8
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            error = "Invalid API URL"
            isGenerating = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.error = "Failed to encode request"
            self.isGenerating = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isGenerating = false
                
                if let error = error {
                    self.error = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        self.currentWisdom = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        self.error = "Failed to parse response"
                    }
                } catch {
                    self.error = "Failed to decode response"
                }
            }
        }.resume()
    }
}

struct WisdomExperienceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @StateObject private var wisdomService = WisdomService()
    @State private var selectedCategory: WisdomCategory? = nil
    @State private var showingWisdom = false
    @State private var dragonAnimation = false
    @State private var categoryAnimation = false
    @State private var mysticParticles = false
    @State private var showingSaveConfirmation = false
    
    var redBallsCount: Int {
        gameService.getCollectedCount(for: .red)
    }
    
    var body: some View {
        ZStack {
            // Mystical background
            LinearGradient(
                colors: [
                    Color(hex: "0f0f1e"),
                    Color(hex: "1a1a2e"),
                    Color(hex: "2c1810"),
                    Color(hex: "1a1a2e")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating mystical particles
            if mysticParticles {
                ForEach(0..<30, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "FFD700").opacity(0.6),
                                    Color(hex: "FF6B6B").opacity(0.4),
                                    Color(hex: "9c88ff").opacity(0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat.random(in: 3...8))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .scaleEffect(dragonAnimation ? CGFloat.random(in: 0.5...1.5) : 0.3)
                        .opacity(dragonAnimation ? CGFloat.random(in: 0.3...0.8) : 0.1)
                        .animation(
                            .easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...3)),
                            value: dragonAnimation
                        )
                }
            }
            
            if !showingWisdom {
                // Category Selection View
                VStack(spacing: 40) {
                    // Header with dragon theme
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
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 15) {
                            Text("🐉")
                                .font(.system(size: 80))
                                .scaleEffect(dragonAnimation ? 1.1 : 0.9)
                                .rotationEffect(.degrees(dragonAnimation ? 5 : -5))
                            
                            Text("Red Pearl Wisdom")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [
                                        Color(hex: "FF6B6B"),
                                        Color(hex: "FFD700"),
                                        Color(hex: "FF6B6B")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .multicolorGlow()
                            
                            Text("Ancient Dragon's Guidance")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        // Available red pearls
                        HStack(spacing: 15) {
                            Image("red-ball")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .scaleEffect(dragonAnimation ? 1.1 : 1.0)
                            
                            Text("\(redBallsCount) Red Pearls")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "FF6B6B"), Color(hex: "EE5A24")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(hex: "FF6B6B").opacity(0.5), lineWidth: 2)
                                )
                        )
                    }
                    
                    // Category selection
                    VStack(spacing: 25) {
                        Text("Choose Your Path to Wisdom")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 25) {
                            ForEach(WisdomCategory.allCases, id: \.self) { category in
                                WisdomCategoryCard(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    animationToggle: $categoryAnimation
                                ) {
                                    selectedCategory = category
                                } onWisdomRequest: {
                                    requestWisdom(for: category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            } else {
                // Wisdom Display View
                WisdomDisplayView(
                    category: selectedCategory!,
                    wisdom: wisdomService.currentWisdom,
                    isGenerating: wisdomService.isGenerating,
                    error: wisdomService.error,
                    dragonAnimation: $dragonAnimation,
                    onBack: {
                        showingWisdom = false
                        selectedCategory = nil
                        wisdomService.currentWisdom = nil
                    },
                    onSave: saveWisdom,
                    onShare: shareWisdom,
                    onNewWisdom: {
                        if let category = selectedCategory {
                            requestWisdom(for: category)
                        }
                    }
                )
            }
        }
        .onAppear {
            mysticParticles = true
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                dragonAnimation.toggle()
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                categoryAnimation.toggle()
            }
        }
    }
    
    private func requestWisdom(for category: WisdomCategory) {
        // Consume one red pearl
        if gameService.getCollectedCount(for: .red) > 0 {
            // Remove one red pearl (we'll implement this method in GameService)
            gameService.consumeRedPearl()
            
            showingWisdom = true
            wisdomService.generateWisdom(for: category)
        }
    }
    
    private func saveWisdom() {
        if let wisdom = wisdomService.currentWisdom {
            // Save to UserDefaults or Core Data
            var savedWisdoms = UserDefaults.standard.stringArray(forKey: "SavedWisdoms") ?? []
            let wisdomEntry = "[\(selectedCategory?.rawValue ?? "")] \(wisdom)"
            savedWisdoms.append(wisdomEntry)
            UserDefaults.standard.set(savedWisdoms, forKey: "SavedWisdoms")
            
            showingSaveConfirmation = true
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func shareWisdom() {
        if let wisdom = wisdomService.currentWisdom {
            let shareText = "🐉 Ancient Dragon Wisdom about \(selectedCategory?.rawValue ?? "Life"):\n\n\"\(wisdom)\"\n\n- From GoBobbas Red Pearl Collection"
            
            let activityViewController = UIActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityViewController, animated: true)
            }
        }
    }
}

struct WisdomCategoryCard: View {
    let category: WisdomCategory
    let isSelected: Bool
    @Binding var animationToggle: Bool
    let onTap: () -> Void
    let onWisdomRequest: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                ZStack {
                    // Mystical glow effect
                    Circle()
                        .fill(Color(hex: category.color).opacity(0.3))
                        .frame(width: 100, height: 100)
                        .blur(radius: 20)
                        .scaleEffect(isSelected ? 1.2 : 0.8)
                    
                    VStack(spacing: 10) {
                        Text(category.emoji)
                            .font(.system(size: 50))
                            .scaleEffect(isSelected ? 1.2 : 1.0)
                            .rotationEffect(.degrees(animationToggle ? 5 : -5))
                        
                        Text(category.rawValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(category.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding()
                }
                
                if isSelected {
                    Button(action: onWisdomRequest) {
                        HStack(spacing: 8) {
                            Text("🔮")
                                .font(.system(size: 16))
                            Text("Seek Wisdom")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: category.color).opacity(0.5), radius: 10, x: 0, y: 5)
                        .scaleEffect(animationToggle ? 1.05 : 1.0)
                    }
                }
            }
            .frame(height: 200)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isSelected ? 0.15 : 0.08),
                            Color.white.opacity(isSelected ? 0.1 : 0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            isSelected ? Color(hex: category.color) : Color.white.opacity(0.2),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

struct WisdomDisplayView: View {
    let category: WisdomCategory
    let wisdom: String?
    let isGenerating: Bool
    let error: String?
    @Binding var dragonAnimation: Bool
    let onBack: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void
    let onNewWisdom: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Dragon and category display
            VStack(spacing: 20) {
                Text("🐉")
                    .font(.system(size: 100))
                    .scaleEffect(dragonAnimation ? 1.1 : 0.9)
                    .rotationEffect(.degrees(dragonAnimation ? 10 : -10))
                
                HStack(spacing: 15) {
                    Text(category.emoji)
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Dragon's Wisdom")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("About \(category.rawValue)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    }
                }
            }
            
            // Wisdom content area
            VStack(spacing: 25) {
                if isGenerating {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: category.color)))
                            .scaleEffect(1.5)
                        
                        Text("The Dragon is consulting ancient wisdom...")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 50)
                } else if let error = error {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.red)
                        
                        Text("The dragon's wisdom is temporarily clouded")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 30)
                } else if let wisdom = wisdom {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Wisdom text with beautiful styling
                            Text(wisdom)
                                .font(.system(size: 20, weight: .medium, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .padding(25)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: category.color).opacity(0.2),
                                                    Color(hex: category.color).opacity(0.1),
                                                    Color.white.opacity(0.05)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(hex: category.color).opacity(0.3), lineWidth: 1)
                                        )
                                )
                            
                            // Action buttons
                            HStack(spacing: 15) {
                                Button(action: onSave) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Save")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                }
                                
                                Button(action: onShare) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Share")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "3742fa"), Color(hex: "2f3542")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // New wisdom button
                            Button(action: onNewWisdom) {
                                HStack(spacing: 10) {
                                    Text("🔮")
                                        .font(.system(size: 20))
                                    Text("Seek Another Wisdom")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .shadow(color: Color(hex: category.color).opacity(0.5), radius: 15, x: 0, y: 8)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

// MARK: - Intelligence Lab Experience

enum IntelligenceCategory: String, CaseIterable {
    case lifehacks = "Life Hacks"
    case science = "Science Facts"
    case psychology = "Psychology"
    case technology = "Technology"
    case biology = "Biology"
    case physics = "Physics"
    
    var emoji: String {
        switch self {
        case .lifehacks: return "💡"
        case .science: return "🔬"
        case .psychology: return "🧠"
        case .technology: return "💻"
        case .biology: return "🧬"
        case .physics: return "⚛️"
        }
    }
    
    var color: String {
        switch self {
        case .lifehacks: return "f9ca24"
        case .science: return "26de81"
        case .psychology: return "9c88ff"
        case .technology: return "45aaf2"
        case .biology: return "20bf6b"
        case .physics: return "3742fa"
        }
    }
    
    var description: String {
        switch self {
        case .lifehacks: return "Practical tips to improve your daily life"
        case .science: return "Amazing scientific facts and discoveries"
        case .psychology: return "Insights about human behavior and mind"
        case .technology: return "Cool tech facts and innovations"
        case .biology: return "Fascinating facts about life and nature"
        case .physics: return "Mind-blowing physics concepts explained"
        }
    }
}

class IntelligenceService: ObservableObject {
    @Published var isGenerating = false
    @Published var currentKnowledge: String? = nil
    @Published var error: String? = nil
    
    private let apiKey = Config.openAIAPIKey
    
    func generateKnowledge(for category: IntelligenceCategory) {
        guard Config.hasValidAPIKey else {
            error = "API ключ не настроен. Пожалуйста, установите переменную окружения OPENAI_API_KEY."
            isGenerating = false
            return
        }
        
        isGenerating = true
        error = nil
        
        let prompt: String
        
        switch category {
        case .lifehacks:
            prompt = """
            Generate a practical and surprising life hack that most people don't know. Make it:
            - Easy to implement
            - Actually useful in daily life
            - Something specific like "If you put an ice cube in your dryer with wrinkled clothes for 10 minutes, it removes wrinkles"
            - Include a brief explanation of why it works
            - 2-3 sentences maximum
            """
        case .science:
            prompt = """
            Share an amazing and little-known scientific fact. Make it:
            - Mind-blowing but true
            - Easy to understand
            - Something specific with actual numbers or examples
            - Include a brief explanation
            - 2-3 sentences maximum
            """
        case .psychology:
            prompt = """
            Share a fascinating psychological insight about human behavior. Make it:
            - Surprising and counterintuitive
            - Practically applicable
            - Based on real research
            - Include a brief explanation of the mechanism
            - 2-3 sentences maximum
            """
        case .technology:
            prompt = """
            Share a cool technology fact or hack that people can use. Make it:
            - About modern technology (phones, computers, internet)
            - Practical or just amazingly interesting
            - Something specific with clear instructions if applicable
            - Include brief context
            - 2-3 sentences maximum
            """
        case .biology:
            prompt = """
            Share a fascinating biological fact about life, nature, or the human body. Make it:
            - Amazing and surprising
            - Easy to understand
            - Something specific with real examples
            - Include brief explanation of the mechanism
            - 2-3 sentences maximum
            """
        case .physics:
            prompt = """
            Explain a mind-blowing physics concept or fact in simple terms. Make it:
            - Counterintuitive or surprising
            - Explained in everyday language
            - Something specific with relatable examples
            - Include why it matters or how it works
            - 2-3 sentences maximum
            """
        }
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a brilliant science communicator who makes complex knowledge accessible and exciting."
                ],
                [
                    "role": "user", 
                    "content": prompt
                ]
            ],
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            error = "Invalid API URL"
            isGenerating = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            self.error = "Failed to encode request"
            self.isGenerating = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isGenerating = false
                
                if let error = error {
                    self.error = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        self.currentKnowledge = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        self.error = "Failed to parse response"
                    }
                } catch {
                    self.error = "Failed to decode response"
                }
            }
        }.resume()
    }
}

struct IntelligenceLabView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @StateObject private var intelligenceService = IntelligenceService()
    @State private var selectedCategory: IntelligenceCategory? = nil
    @State private var showingKnowledge = false
    @State private var brainAnimation = false
    @State private var categoryAnimation = false
    @State private var scienceParticles = false
    @State private var showingSaveConfirmation = false
    
    var greenBallsCount: Int {
        gameService.getCollectedCount(for: .green)
    }
    
    var body: some View {
        ZStack {
            // Science lab background
            LinearGradient(
                colors: [
                    Color(hex: "0f1419"),
                    Color(hex: "1a2332"),
                    Color(hex: "26de81").opacity(0.1),
                    Color(hex: "1a2332")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating science particles
            if scienceParticles {
                ForEach(0..<25, id: \.self) { index in
                    Group {
                        // DNA helixes
                        Text("🧬")
                            .font(.system(size: CGFloat.random(in: 16...24)))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .scaleEffect(brainAnimation ? CGFloat.random(in: 0.8...1.2) : 0.5)
                            .opacity(brainAnimation ? CGFloat.random(in: 0.4...0.8) : 0.2)
                            .rotationEffect(.degrees(brainAnimation ? CGFloat.random(in: 0...360) : 0))
                        
                        // Atoms
                        Text("⚛️")
                            .font(.system(size: CGFloat.random(in: 12...20)))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .scaleEffect(brainAnimation ? CGFloat.random(in: 0.6...1.4) : 0.3)
                            .opacity(brainAnimation ? CGFloat.random(in: 0.3...0.7) : 0.1)
                        
                        // Light bulbs
                        Text("💡")
                            .font(.system(size: CGFloat.random(in: 14...22)))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .scaleEffect(brainAnimation ? CGFloat.random(in: 0.7...1.3) : 0.4)
                            .opacity(brainAnimation ? CGFloat.random(in: 0.5...0.9) : 0.2)
                    }
                    .animation(
                        .easeInOut(duration: Double.random(in: 4...7))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...4)),
                        value: brainAnimation
                    )
                }
            }
            
            if !showingKnowledge {
                // Category Selection View
                VStack(spacing: 40) {
                    // Header with brain theme
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
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 15) {
                            Text("🧠")
                                .font(.system(size: 80))
                                .scaleEffect(brainAnimation ? 1.1 : 0.9)
                                .rotationEffect(.degrees(brainAnimation ? 3 : -3))
                            
                            Text("Intelligence Boba")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [
                                        Color(hex: "26de81"),
                                        Color(hex: "45aaf2"),
                                        Color(hex: "26de81")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .scientificGlow()
                            
                            Text("Smart Life Hacks & Science Knowledge")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        // Available green balls
                        HStack(spacing: 15) {
                            Image("green-ball")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .scaleEffect(brainAnimation ? 1.1 : 1.0)
                            
                            Text("\(greenBallsCount) Intelligence Bobas")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(hex: "26de81").opacity(0.5), lineWidth: 2)
                                )
                        )
                    }
                    
                    // Category selection
                    VStack(spacing: 25) {
                        Text("Choose Your Learning Path")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                            ForEach(IntelligenceCategory.allCases, id: \.self) { category in
                                IntelligenceCategoryCard(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    animationToggle: $categoryAnimation
                                ) {
                                    selectedCategory = category
                                } onKnowledgeRequest: {
                                    requestKnowledge(for: category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            } else {
                // Knowledge Display View
                IntelligenceDisplayView(
                    category: selectedCategory!,
                    knowledge: intelligenceService.currentKnowledge,
                    isGenerating: intelligenceService.isGenerating,
                    error: intelligenceService.error,
                    brainAnimation: $brainAnimation,
                    onBack: {
                        showingKnowledge = false
                        selectedCategory = nil
                        intelligenceService.currentKnowledge = nil
                    },
                    onSave: saveKnowledge,
                    onShare: shareKnowledge,
                    onNewKnowledge: {
                        if let category = selectedCategory {
                            requestKnowledge(for: category)
                        }
                    }
                )
            }
        }
        .onAppear {
            scienceParticles = true
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                brainAnimation.toggle()
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                categoryAnimation.toggle()
            }
        }
    }
    
    private func requestKnowledge(for category: IntelligenceCategory) {
        // Consume one green ball
        if gameService.getCollectedCount(for: .green) > 0 {
            gameService.consumeGreenBoba()
            
            showingKnowledge = true
            intelligenceService.generateKnowledge(for: category)
        }
    }
    
    private func saveKnowledge() {
        if let knowledge = intelligenceService.currentKnowledge {
            var savedKnowledge = UserDefaults.standard.stringArray(forKey: "SavedKnowledge") ?? []
            let knowledgeEntry = "[\(selectedCategory?.rawValue ?? "")] \(knowledge)"
            savedKnowledge.append(knowledgeEntry)
            UserDefaults.standard.set(savedKnowledge, forKey: "SavedKnowledge")
            
            showingSaveConfirmation = true
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func shareKnowledge() {
        if let knowledge = intelligenceService.currentKnowledge {
            let shareText = "🧠 Smart Knowledge from Intelligence Boba (\(selectedCategory?.rawValue ?? "Science")):\n\n\(knowledge)\n\n- From GoBobbas Intelligence Collection"
            
            let activityViewController = UIActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityViewController, animated: true)
            }
        }
    }
}

struct IntelligenceCategoryCard: View {
    let category: IntelligenceCategory
    let isSelected: Bool
    @Binding var animationToggle: Bool
    let onTap: () -> Void
    let onKnowledgeRequest: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                ZStack {
                    // Scientific glow effect
                    Circle()
                        .fill(Color(hex: category.color).opacity(0.3))
                        .frame(width: 90, height: 90)
                        .blur(radius: 15)
                        .scaleEffect(isSelected ? 1.3 : 0.9)
                    
                    VStack(spacing: 8) {
                        Text(category.emoji)
                            .font(.system(size: 45))
                            .scaleEffect(isSelected ? 1.2 : 1.0)
                            .rotationEffect(.degrees(animationToggle ? 3 : -3))
                        
                        Text(category.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(category.description)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 8)
                }
                
                if isSelected {
                    Button(action: onKnowledgeRequest) {
                        HStack(spacing: 6) {
                            Text("🧠")
                                .font(.system(size: 14))
                            Text("Learn")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: category.color).opacity(0.5), radius: 8, x: 0, y: 4)
                        .scaleEffect(animationToggle ? 1.05 : 1.0)
                    }
                }
            }
            .frame(height: 170)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isSelected ? 0.15 : 0.08),
                            Color.white.opacity(isSelected ? 0.1 : 0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color(hex: category.color) : Color.white.opacity(0.2),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

struct IntelligenceDisplayView: View {
    let category: IntelligenceCategory
    let knowledge: String?
    let isGenerating: Bool
    let error: String?
    @Binding var brainAnimation: Bool
    let onBack: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void
    let onNewKnowledge: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Brain and category display
            VStack(spacing: 20) {
                Text("🧠")
                    .font(.system(size: 100))
                    .scaleEffect(brainAnimation ? 1.1 : 0.9)
                    .rotationEffect(.degrees(brainAnimation ? 5 : -5))
                
                HStack(spacing: 15) {
                    Text(category.emoji)
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Smart Knowledge")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(category.rawValue)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.linearGradient(
                                colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    }
                }
            }
            
            // Knowledge content area
            VStack(spacing: 25) {
                if isGenerating {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: category.color)))
                            .scaleEffect(1.5)
                        
                        Text("Processing intelligence data...")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 50)
                } else if let error = error {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.red)
                        
                        Text("Intelligence network is offline")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 30)
                } else if let knowledge = knowledge {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Knowledge text with beautiful styling
                            Text(knowledge)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(6)
                                .padding(25)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: category.color).opacity(0.15),
                                                    Color(hex: category.color).opacity(0.08),
                                                    Color.white.opacity(0.05)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(hex: category.color).opacity(0.3), lineWidth: 1)
                                        )
                                )
                            
                            // Action buttons
                            HStack(spacing: 15) {
                                Button(action: onSave) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "bookmark.fill")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Save")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                }
                                
                                Button(action: onShare) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Share")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "3742fa"), Color(hex: "2f3542")],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // New knowledge button
                            Button(action: onNewKnowledge) {
                                HStack(spacing: 10) {
                                    Text("🧠")
                                        .font(.system(size: 20))
                                    Text("Learn Something New")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: category.color), Color(hex: category.color).opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .shadow(color: Color(hex: category.color).opacity(0.5), radius: 15, x: 0, y: 8)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

extension View {
    func multicolorGlow() -> some View {
        self
            .shadow(color: Color(hex: "FF6B6B").opacity(0.6), radius: 20, x: -10, y: -10)
            .shadow(color: Color(hex: "FFD700").opacity(0.6), radius: 20, x: 10, y: 10)
            .shadow(color: Color(hex: "9c88ff").opacity(0.4), radius: 15, x: 0, y: 0)
    }
    
    func scientificGlow() -> some View {
        self
            .shadow(color: Color(hex: "26de81").opacity(0.6), radius: 20, x: -8, y: -8)
            .shadow(color: Color(hex: "45aaf2").opacity(0.6), radius: 20, x: 8, y: 8)
            .shadow(color: Color(hex: "9c88ff").opacity(0.4), radius: 15, x: 0, y: 0)
    }
}

#Preview {
    TreasureView(gameService: GameService())
}
