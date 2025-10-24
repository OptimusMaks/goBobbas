//
//  HowToPlayView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI

struct BallInfo {
    let color: Color
    let title: String
    let description: String
    let icon: String
    let bonus: String
}

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var animationPhase = 0
    @State private var ballAnimations: [Bool] = Array(repeating: false, count: 5)
    
    private let ballInfos = [
        BallInfo(color: Color.yellow, title: "Bobbass Coin", description: "Coins drop more often when you collect them - your balance grows!", icon: "💰", bonus: "+20"),
        BallInfo(color: Color.red, title: "Red Pearl", description: "Wisdom from the Chinese Dragon\nChoose from: Money, Soul, Relations, Future\nAI generates wisdom to save or share", icon: "🔴", bonus: "x2"),
        BallInfo(color: Color.green, title: "Health Point", description: "Fitness challenge\nCreate 30 simple exercises and get random rewards", icon: "💚", bonus: "+40"),
        BallInfo(color: Color.blue, title: "Intelligence Boba", description: "AI generates life hacks and knowledge\nExample: Put avocado pit in glass with toothpick - it grows!", icon: "🧠", bonus: "x40"),
        BallInfo(color: Color(hex: "1a1a2e"), title: "Black Hole", description: "Works like a black ball in billiards\nPress it - game ends immediately and you lose", icon: "🕳️", bonus: "END")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Image("menu-bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Color.black
                .frame(width: 300, height: 700)
                .opacity(0.3)
                .blur(radius: 100)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer(minLength: 300)
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                dismiss()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.top, 150)
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    headerView
                        .padding(.top, -100)
                    
                    // Game Objective
                    gameObjectiveView
                    
                    // Tickets System
                    ticketsSystemView
                    
                    // Ball Types
                    ballTypesView
                    
                    // Game Tips
                    gameTipsView
                    Spacer(minLength: 700)
                    
                }
                .padding(.horizontal, 20)
            }
            .ignoresSafeArea()
        
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 80)
            
            Text("HOW TO PLAY")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(.linearGradient(
                    colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .scaleEffect(animationPhase > 0 ? 1.0 : 0.8)
                .opacity(animationPhase > 0 ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animationPhase)
            
            Text("🎯 POP BUBBLES & COLLECT BONUSES!")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.linearGradient(
                                    colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ), lineWidth: 2)
                        )
                )
                .scaleEffect(animationPhase > 1 ? 1.0 : 0.9)
                .opacity(animationPhase > 1 ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animationPhase)
        }
    }
    
    private var gameObjectiveView: some View {
        VStack(spacing: 15) {
            Text("🎮 GAME OBJECTIVE")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.linearGradient(
                    colors: [Color.white, Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .scaleEffect(animationPhase > 2 ? 1.0 : 0.8)
                .opacity(animationPhase > 2 ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: animationPhase)
            
            VStack(alignment: .leading, spacing: 12) {
                objectiveRow(icon: "🎯", text: "Tap and pop colorful bubbles")
                objectiveRow(icon: "⚡", text: "Each bubble gives unique bonuses")
                objectiveRow(icon: "🏆", text: "Collect coins and special rewards")
                objectiveRow(icon: "🎲", text: "Avoid the dangerous black hole!")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(animationPhase > 3 ? 1.0 : 0.9)
            .opacity(animationPhase > 3 ? 1.0 : 0.0)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.8), value: animationPhase)
        }
    }
    
    private var ticketsSystemView: some View {
        VStack(spacing: 15) {
            Text("🎫 TICKETS SYSTEM")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.linearGradient(
                    colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .scaleEffect(animationPhase > 4 ? 1.0 : 0.8)
                .opacity(animationPhase > 4 ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.0), value: animationPhase)
            
            VStack(spacing: 15) {
                ticketRow(icon: "🎫", title: "Need Tickets to Play", description: "Each game requires 1 ticket")
                ticketRow(icon: "🎁", title: "Get 3 Free Daily", description: "Tickets refresh every 24 hours")
                ticketRow(icon: "💰", title: "Buy More Tickets", description: "100 gold coins = 1 ticket")
                ticketRow(icon: "🎊", title: "Win from Bubbles", description: "Some bubbles drop bonus tickets")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.linearGradient(
                                colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ), lineWidth: 2)
                    )
            )
            .scaleEffect(animationPhase > 5 ? 1.0 : 0.9)
            .opacity(animationPhase > 5 ? 1.0 : 0.0)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(1.2), value: animationPhase)
        }
    }
    
    private var ballTypesView: some View {
        VStack(spacing: 20) {
            Text("🎨 BUBBLE TYPES")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.linearGradient(
                    colors: [Color.white, Color.gray],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .scaleEffect(animationPhase > 6 ? 1.0 : 0.8)
                .opacity(animationPhase > 6 ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.4), value: animationPhase)
            
            LazyVStack(spacing: 15) {
                ForEach(Array(ballInfos.enumerated()), id: \.offset) { index, ball in
                    ballInfoCard(ball: ball, index: index)
                }
            }
        }
    }
    
    private var gameTipsView: some View {
        VStack(spacing: 15) {
            Text("💡 PRO TIPS")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.linearGradient(
                    colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            
            VStack(alignment: .leading, spacing: 12) {
                tipRow(icon: "⚡", text: "Tap quickly for combo bonuses")
                tipRow(icon: "🎯", text: "Focus on colored bubbles first")
                tipRow(icon: "⚠️", text: "Always avoid the black hole")
                tipRow(icon: "💎", text: "Save coins for special purchases")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private func objectiveRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            Text(text)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
        }
    }
    
    private func ticketRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
    }
    
    private func tipRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            Text(text)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
        }
    }
    
    private func ballInfoCard(ball: BallInfo, index: Int) -> some View {
        HStack(spacing: 15) {
            // Animated Ball
            ZStack {
                Circle()
                    .fill(ball.color)
                    .frame(width: 60, height: 60)
                    .scaleEffect(ballAnimations[index] ? 1.1 : 1.0)
                    .shadow(color: ball.color.opacity(0.6), radius: 10, x: 0, y: 0)
                
                if ball.title == "Black Hole" {
                    Circle()
                        .fill(.black)
                        .frame(width: 50, height: 50)
                } else {
                    Text(ball.bonus)
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2)) {
                    ballAnimations[index] = true
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ball.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.linearGradient(
                        colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                
                Text(ball.description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(ball.color.opacity(0.5), lineWidth: 1)
                )
        )
        .scaleEffect(animationPhase > 6 + index ? 1.0 : 0.9)
        .opacity(animationPhase > 6 + index ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(1.6 + Double(index) * 0.1), value: animationPhase)
    }
    
    private func startAnimations() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if animationPhase < 15 {
                animationPhase += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    HowToPlayView()
}
