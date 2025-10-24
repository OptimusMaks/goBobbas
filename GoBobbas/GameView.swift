//
//  GameView.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import UIKit
import UIKit

struct ParticleEffect {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var color: Color
    var size: CGFloat
    var life: Double = 1.0
    var opacity: Double = 1.0
}

struct CollectedBall {
    let id = UUID()
    let type: BallType
    var count: Int
    var animatingPosition: CGPoint = .zero
    var isAnimating: Bool = false
}

struct FlyingBall {
    let id = UUID()
    let type: BallType
    var position: CGPoint
    var targetPosition: CGPoint
    var animationProgress: Double = 0.0
}

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameService: GameService
    @State private var logoAnimTogle = false
    @State private var particles: [ParticleEffect] = []
    @State private var collectedBalls: [CollectedBall] = []
    @State private var flyingBalls: [FlyingBall] = []
    @State private var gameOver = false
    @State private var showGameOverAlert = false
    @State private var timeUpAlert = false
    @State private var showCountdown = true
    @State private var countdownNumber = 3
    @State private var countdownScale: CGFloat = 0.5
    @State private var countdownOpacity: Double = 0.0
    
    init(gameService: GameService) {
        self.gameService = gameService
    }
    
    var body: some View {
        ZStack {
            Image("game-background")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            VStack {
                LinearGradient(colors: [Color(hex: "0059FF"), Color(hex: "007AFF")], startPoint: .top, endPoint: .bottom)
                    .frame(height: 150)
                    .cornerRadius(30)
                    .overlay(content: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30).stroke(.white, lineWidth: 0)
                            
                            // Timer in top-right corner
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 2) {
//                                        Text("TIME")
//                                            .font(.system(size: 12, weight: .bold))
//                                            .foregroundColor(.white.opacity(0.8))
                                        Text(gameService.formatTime(gameService.gameTimeRemaining))
                                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                                            .foregroundStyle(.linearGradient(
                                                colors: gameService.gameTimeRemaining <= 5 ? 
                                                    [Color.red, Color.orange] : 
                                                    [Color(hex: "FFCC00"), Color(hex: "FF9500")], 
                                                startPoint: .top, 
                                                endPoint: .bottom
                                            ))
                                            .scaleEffect(gameService.gameTimeRemaining <= 5 ? (logoAnimTogle ? 1.2 : 1.0) : 1.0)
                                    }
                                    .padding(.trailing, 16)
                                    .padding(.top, 64)
                                    .padding(.bottom, -3)
                                }
                                Spacer()
                            }
                                
                            HStack {
                                
                                Image("bag-icn")
                                Text("0")
                                
                                Spacer()
                                Image("logo-bobas")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .scaleEffect(logoAnimTogle ? 1.15 : 1)
                                    .offset(y: 16)
                                Spacer()
                                Text("0")
                                Image("tkt-icn")
                                
                            }
                            .padding(.horizontal, 16)
                            .offset(y: 40)
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.linearGradient(colors: [Color(hex: "FFCC00"), Color(hex: "FF9500")], startPoint: .top, endPoint: .bottom))
                        }
                    }).shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 4)
                    .shadow(color: .blue, radius: 30, x: 0, y: 4)
                    .shadow(color: .blue.opacity(0.4), radius: 90, x: 0, y: 6)
                        
                    .padding(.top, -8)
                    .padding(.horizontal, 4)
                  
                Spacer()
                ZStack {
                    LinearGradient(colors: [Color(hex: "0059FF"), Color(hex: "007AFF")], startPoint: .top, endPoint: .bottom)
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("exit-btn")
                        }
                        .padding(.leading, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(collectedBalls, id: \.id) { ball in
                                    VStack(spacing: 4) {
                                        ZStack {
                                            Circle()
                                                .fill(.white.opacity(0.2))
                                                .frame(width: 35, height: 35)
                                            
                                            Text("\(ball.count)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Image(ball.type.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .scaleEffect(ball.isAnimating ? 1.2 : 1.0)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: ball.isAnimating)
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                    }
                }
                    .frame(height: 120)
                    .cornerRadius(30, corners: .topLeft)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -4)
                    .shadow(color: .blue, radius: 30, x: 0, y: -4)
                    
                        
                    .padding(.top, 0)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 65)
                
            }
            
            // Particles Layer
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .opacity(particle.opacity)
                    .position(particle.position)
                    .animation(.easeOut(duration: 0.8), value: particle.opacity)
            }
            
            // Flying Balls Layer (for collection animation)
            ForEach(flyingBalls, id: \.id) { flyingBall in
                Image(flyingBall.type.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .position(flyingBall.position)
                    .scaleEffect(1.0 - flyingBall.animationProgress * 0.3)
                    .opacity(1.0 - flyingBall.animationProgress * 0.2)
            }
            
            // Balls Layer
            ForEach(activeBalls, id: \.self) { ball in
                ZStack {
                    // Glow effect for black balls about to disappear
                    if ball.type == .black && ball.isDisappearing {
                        Circle()
                            .fill(Color.red)
                            .frame(width: ball.glowSize, height: ball.glowSize)
                            .blur(radius: 15)
                            .opacity(0.6)
                            .scaleEffect(ball.pulseEffect)
                    }
                    
                    // Main ball using your assets
                    Image(ball.type.imageName)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(ball.scaleEffect)
                        .rotationEffect(.degrees(ball.rotation))
                        .shadow(color: ball.type.shadowColor, radius: 8, x: 0, y: 4)
                        .opacity(ball.opacity)
                }
                .position(ball.position)
                .onTapGesture {
                    if !gameOver {
                        popBall(ball)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: ball.scaleEffect)
                .animation(.easeInOut(duration: 0.5), value: ball.opacity)
            }
            
            // Countdown Overlay
            if showCountdown {
                ZStack {
                    // Semi-transparent background
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    ZStack {
                        // Glow effect
                        if countdownNumber > 0 {
                            Text("\(countdownNumber)")
                                .font(.system(size: 200, weight: .black, design: .rounded))
                                .foregroundColor(countdownNumber == 3 ? .red : countdownNumber == 2 ? .orange : .green)
                                .blur(radius: 20)
                                .scaleEffect(countdownScale * 1.5)
                                .opacity(countdownOpacity * 0.6)
                        } else {
                            Text("GO!")
                                .font(.system(size: 120, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color.green, Color.yellow],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .blur(radius: 15)
                                .scaleEffect(countdownScale * 1.3)
                                .opacity(countdownOpacity * 0.8)
                        }
                        
                        // Main text
                        if countdownNumber > 0 {
                            Text("\(countdownNumber)")
                                .font(.system(size: 200, weight: .black, design: .rounded))
                                .foregroundColor(countdownNumber == 3 ? .red : countdownNumber == 2 ? .orange : .green)
                                .scaleEffect(countdownScale)
                                .opacity(countdownOpacity)
                                .shadow(color: .black, radius: 10, x: 0, y: 5)
                        } else {
                            Text("GO!")
                                .font(.system(size: 120, weight: .black, design: .rounded))
                                .foregroundStyle(.linearGradient(
                                    colors: [Color.green, Color.yellow],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .scaleEffect(countdownScale)
                                .opacity(countdownOpacity)
                                .shadow(color: .black, radius: 15, x: 0, y: 8)
                        }
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: countdownScale)
                .animation(.easeOut(duration: 0.3), value: countdownOpacity)
            }
        }.ignoresSafeArea()
            .onAppear {
                runAnimationForLogo()
                startParticleUpdate()
                startCountdown()
            }
            .alert("Game Over!", isPresented: $showGameOverAlert) {
                Button("Restart") {
                    restartGame()
                }
                Button("Exit") {
                    dismiss()
                }
            } message: {
                Text("You touched a black ball! Game Over.")
            }
            .alert("Time's Up!", isPresented: $timeUpAlert) {
                Button("Play Again") {
                    restartGame()
                }
                Button("Exit") {
                    dismiss()
                }
            } message: {
                Text("Great game! Your collection has been saved.")
            }
            .onChange(of: gameService.isGameActive) { isActive in
                if !isActive && gameService.gameTimeRemaining == 0 {
                    // Time's up - save collection and show alert
                    gameService.saveCurrentGameCollection(collectedBalls)
                    gameOver = true
                    timeUpAlert = true
                }
            }
        
    }
    
    private func runAnimationForLogo() {
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            logoAnimTogle.toggle()
        }
    }
    
    private func startCountdown() {
        countdownNumber = 3
        animateCountdownNumber()
    }
    
    private func animateCountdownNumber() {
        // Reset animation values
        countdownScale = 0.5
        countdownOpacity = 0.0
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // Scale and fade in animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            countdownScale = 1.2
            countdownOpacity = 1.0
        }
        
        // Scale down slightly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                countdownScale = 1.0
            }
        }
        
        // Fade out and next number
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.2)) {
                countdownOpacity = 0.0
                countdownScale = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if countdownNumber > 1 {
                    countdownNumber -= 1
                    animateCountdownNumber()
                } else {
                    // Show "GO!" and start game
                    countdownNumber = 0
                    animateGoText()
                }
            }
        }
    }
    
    private func animateGoText() {
        // Reset animation values
        countdownScale = 0.3
        countdownOpacity = 0.0
        
        // Stronger haptic feedback for GO!
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // Dramatic entrance for GO!
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
            countdownScale = 1.3
            countdownOpacity = 1.0
        }
        
        // Settle to normal size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                countdownScale = 1.0
            }
        }
        
        // Hide countdown and start game
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                countdownOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCountdown = false
                startGame()
            }
        }
    }
    
    private func startGame() {
        gameService.startNewGame()
        runBallSpawnTimer()
        startBlackBallChecker()
    }
    
    private func runBallSpawnTimer() {
        guard !gameOver && gameService.isGameActive else { return }
        let delay = Double.random(in: 0.8...2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            print("spawned with delay \(delay)s")
            runBallSpawnTimer()
            spawnRandomBall()
        }
    }
    
    @State private var activeBalls: [Ball] = []
    
    private func spawnRandomBall() {
        guard activeBalls.count <= 8 else {
            return
        }
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let y = CGFloat.random(in: (screenHeight * 0.25)...(screenHeight * 0.75))
        let x = CGFloat.random(in: (screenWidth * 0.15)...(screenWidth * 0.85))
        let ballType = BallType.allCases.randomElement()!
        let point = CGPoint(x: x, y: y)
        let ball = Ball(type: ballType, position: point, scaleEffect: ballType.scaleEffect)
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            // Add ball to array first
            activeBalls.append(ball)
            
        }
 
        // Start floating animation for the ball
        startBallFloating(ball)
    }
    
    private func startBallFloating(_ ball: Ball) {
        guard let index = activeBalls.firstIndex(where: { $0.id == ball.id }) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard let ballIndex = activeBalls.firstIndex(where: { $0.id == ball.id }) else {
                timer.invalidate()
                return
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                activeBalls[ballIndex].pulseEffect = Double.random(in: 0.8...1.2)
                activeBalls[ballIndex].rotation += Double.random(in: -2...2)
            }
        }
    }
    
    private func popBall(_ ball: Ball) {
        guard let index = activeBalls.firstIndex(where: { $0.id == ball.id }) else { return }
        
        // Check if it's a black ball - game over!
        if ball.type == .black {
            gameOver = true
            gameService.endGame()
            gameService.saveCurrentGameCollection(collectedBalls)
            showGameOverAlert = true
            return
        }
        
        // Create explosion particles
        createExplosionParticles(at: ball.position, color: ball.type.particleColor)
        
        // Start collection animation
        addToCollection(ball: ball)
        
        // Pop animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            activeBalls[index].scaleEffect = 0.0
        }
        
        // Remove ball after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            activeBalls.removeAll { $0.id == ball.id }
        }
    }
    
    private func createExplosionParticles(at position: CGPoint, color: Color) {
        let particleCount = 12
        
        for i in 0..<particleCount {
            let angle = (Double(i) / Double(particleCount)) * 2 * .pi
            let velocity = CGPoint(
                x: cos(angle) * Double.random(in: 100...200),
                y: sin(angle) * Double.random(in: 100...200)
            )
            
            let particle = ParticleEffect(
                position: position,
                velocity: velocity,
                color: color,
                size: CGFloat.random(in: 8...16)
            )
            
            particles.append(particle)
        }
    }
    
    private func startParticleUpdate() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in particles.indices.reversed() {
            particles[i].position.x += particles[i].velocity.x * 0.016
            particles[i].position.y += particles[i].velocity.y * 0.016
            particles[i].velocity.x *= 0.98
            particles[i].velocity.y *= 0.98
            particles[i].life -= 0.016
            particles[i].opacity = particles[i].life
            particles[i].size *= 0.99
            
            if particles[i].life <= 0 {
                particles.remove(at: i)
            }
        }
    }
    
    private func addToCollection(ball: Ball) {
        // Check if this ball type is already collected
        if let existingIndex = collectedBalls.firstIndex(where: { $0.type == ball.type }) {
            // Increase count for existing ball type
            collectedBalls[existingIndex].count += 1
            
            // Trigger animation for existing ball
            collectedBalls[existingIndex].isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                collectedBalls[existingIndex].isAnimating = false
            }
        } else {
            // Add new ball type to collection
            let newCollectedBall = CollectedBall(type: ball.type, count: 1)
            collectedBalls.append(newCollectedBall)
        }
        
        // Start flying animation
        startFlyingAnimation(ball: ball)
    }
    
    private func startFlyingAnimation(ball: Ball) {
        // Calculate target position in the collection area
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let targetX = screenWidth * 0.4 // Position in the scroll view area
        let targetY = screenHeight - 60 // Bottom area where collection is
        let targetPosition = CGPoint(x: targetX, y: targetY)
        
        let flyingBall = FlyingBall(
            type: ball.type,
            position: ball.position,
            targetPosition: targetPosition,
            animationProgress: 0.0
        )
        
        flyingBalls.append(flyingBall)
        
        // Animate the flying ball
        animateFlyingBall(flyingBall.id)
    }
    
    private func animateFlyingBall(_ flyingBallId: UUID) {
        guard let index = flyingBalls.firstIndex(where: { $0.id == flyingBallId }) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            guard let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBallId }) else {
                timer.invalidate()
                return
            }
            
            flyingBalls[ballIndex].animationProgress += 0.03
            
            if flyingBalls[ballIndex].animationProgress >= 1.0 {
                timer.invalidate()
                flyingBalls.removeAll { $0.id == flyingBallId }
                return
            }
            
            let progress = flyingBalls[ballIndex].animationProgress
            let startPos = flyingBalls[ballIndex].position
            let endPos = flyingBalls[ballIndex].targetPosition
            
            // Bezier curve animation for natural movement
            let midX = (startPos.x + endPos.x) / 2
            let midY = min(startPos.y, endPos.y) - 100 // Arc upward
            
            let t = progress
            let x = (1-t)*(1-t)*startPos.x + 2*(1-t)*t*midX + t*t*endPos.x
            let y = (1-t)*(1-t)*startPos.y + 2*(1-t)*t*midY + t*t*endPos.y
            
            flyingBalls[ballIndex].position = CGPoint(x: x, y: y)
        }
    }
    
    private func startBlackBallChecker() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard !gameOver && gameService.isGameActive else {
                timer.invalidate()
                return
            }
            
            let currentTime = Date()
            
            for i in activeBalls.indices.reversed() {
                if activeBalls[i].type == .black {
                    let timeElapsed = currentTime.timeIntervalSince(activeBalls[i].creationTime)
                    
                    // Start warning animation at 2 seconds
                    if timeElapsed >= 2.0 && !activeBalls[i].isDisappearing {
                        activeBalls[i].isDisappearing = true
                        startBlackBallWarningAnimation(ballId: activeBalls[i].id)
                    }
                    
                    // Remove at 3 seconds
                    if timeElapsed >= 3.0 {
                        withAnimation(.easeOut(duration: 0.5)) {
                            if let index = activeBalls.firstIndex(where: { $0.id == activeBalls[i].id }) {
                                activeBalls[index].scaleEffect = 0.0
                                activeBalls[index].opacity = 0.0
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if activeBalls.indices.contains(i) {
                                withAnimation {
                                    activeBalls.removeAll { $0.id == activeBalls[i].id }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func startBlackBallWarningAnimation(ballId: UUID) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard let ballIndex = activeBalls.firstIndex(where: { $0.id == ballId }) else {
                timer.invalidate()
                return
            }
            
            guard activeBalls[ballIndex].isDisappearing else {
                timer.invalidate()
                return
            }
            
            let timeElapsed = Date().timeIntervalSince(activeBalls[ballIndex].creationTime)
            if timeElapsed >= 3.0 {
                timer.invalidate()
                return
            }
            
            withAnimation(.easeInOut(duration: 0.2)) {
                activeBalls[ballIndex].pulseEffect = Double.random(in: 1.5...2.0)
                activeBalls[ballIndex].rotation += Double.random(in: -10...10)
            }
        }
    }
    
    private func restartGame() {
        gameOver = false
        showGameOverAlert = false
        timeUpAlert = false
        activeBalls.removeAll()
        collectedBalls.removeAll()
        flyingBalls.removeAll()
        particles.removeAll()
        
        // Reset countdown and start again
        showCountdown = true
        countdownNumber = 3
        countdownScale = 0.5
        countdownOpacity = 0.0
        
        startCountdown()
    }
}
struct Ball: Identifiable, Hashable {
    let id = UUID()
    let type: BallType
    let position: CGPoint
    var scaleEffect: CGFloat
    var pulseEffect: Double = 1.0
    var rotation: Double = 0.0
    var appearanceScale: CGFloat = 0.0
    let creationTime: Date
    var isDisappearing: Bool = false
    var opacity: Double = 1.0
    var size: CGFloat { type.size }
    var glowSize: CGFloat { size * 1.5 }
    
    init(type: BallType, position: CGPoint, scaleEffect: CGFloat) {
        self.type = type
        self.position = position
        self.scaleEffect = scaleEffect
        self.appearanceScale = 0.0
        self.creationTime = Date()
    }
    
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum BallType: String, CaseIterable {
    case black
    case red
    case green
    case blue
    case yellow
    
    var scaleEffect: CGFloat {
        switch self {
        case .black: return 0.3
        case .red: return 0.25
        case .green, .blue: return 0.2
        case .yellow: return 0.1
        }
    }
    
    var size: CGFloat {
        switch self {
        case .black: return 90
        case .red: return 75
        case .green, .blue: return 70
        case .yellow: return 65
        }
    }
    
    var gradientColor: LinearGradient {
        switch self {
        case .black:
            return LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "000000")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .red:
            return LinearGradient(
                colors: [Color(hex: "FF6B6B"), Color(hex: "EE5A24")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .green:
            return LinearGradient(
                colors: [Color(hex: "26de81"), Color(hex: "20bf6b")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .blue:
            return LinearGradient(
                colors: [Color(hex: "3742fa"), Color(hex: "2f3542")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .yellow:
            return LinearGradient(
                colors: [Color(hex: "f9ca24"), Color(hex: "f0932b")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var glowColor: Color {
        switch self {
        case .black: return Color(hex: "1a1a2e")
        case .red: return Color(hex: "FF6B6B")
        case .green: return Color(hex: "26de81")
        case .blue: return Color(hex: "3742fa")
        case .yellow: return Color(hex: "f9ca24")
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .black: return Color.black.opacity(0.8)
        case .red: return Color(hex: "EE5A24").opacity(0.6)
        case .green: return Color(hex: "20bf6b").opacity(0.6)
        case .blue: return Color(hex: "2f3542").opacity(0.6)
        case .yellow: return Color(hex: "f0932b").opacity(0.6)
        }
    }
    
    var particleColor: Color {
        switch self {
        case .black: return Color(hex: "666666")
        case .red: return Color(hex: "FF6B6B")
        case .green: return Color(hex: "26de81")
        case .blue: return Color(hex: "3742fa")
        case .yellow: return Color(hex: "f9ca24")
        }
    }
    
    var imageName: String {
        rawValue + "-ball"
    }
}

#Preview {
    GameView(gameService: GameService())
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
