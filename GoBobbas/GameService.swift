//
//  GameService.swift
//  GoBobbas
//
//  Created by Hadevs on 9/1/25.
//

import SwiftUI
import Foundation

class GameService: ObservableObject {
    @Published var totalCollectedBalls: [String: Int] = [:]
    @Published var gameTimeRemaining: Int = 0
    @Published var isGameActive: Bool = false
    @Published var playerBalance: Int = 0
    @Published var playerTickets: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let collectionKey = "CollectedBallsCollection"
    private let balanceKey = "PlayerBalance"
    private let ticketsKey = "PlayerTickets"
    
    init() {
        loadCollectedBalls()
        loadPlayerBalance()
        loadPlayerTickets()
    }
    
    // MARK: - Collection Management
    
    func addCollectedBall(type: BallType, count: Int = 1) {
        let key = type.rawValue
        totalCollectedBalls[key, default: 0] += count
        saveCollectedBalls()
    }
    
    func saveCurrentGameCollection(_ collectedBalls: [CollectedBall]) {
        for ball in collectedBalls {
            addCollectedBall(type: ball.type, count: ball.count)
        }
    }
    
    private func saveCollectedBalls() {
        userDefaults.set(totalCollectedBalls, forKey: collectionKey)
    }
    
    private func loadCollectedBalls() {
        if let saved = userDefaults.object(forKey: collectionKey) as? [String: Int] {
            totalCollectedBalls = saved
        }
    }
    
    private func loadPlayerBalance() {
        playerBalance = userDefaults.integer(forKey: balanceKey)
    }
    
    private func savePlayerBalance() {
        userDefaults.set(playerBalance, forKey: balanceKey)
    }
    
    private func loadPlayerTickets() {
        playerTickets = userDefaults.integer(forKey: ticketsKey)
    }
    
    private func savePlayerTickets() {
        userDefaults.set(playerTickets, forKey: ticketsKey)
    }
    
    // MARK: - Timer Management
    
    func startNewGame() {
        gameTimeRemaining = Int.random(in: 15...30)
        isGameActive = true
        startGameTimer()
    }
    
    func endGame() {
        isGameActive = false
        gameTimeRemaining = 0
    }
    
    private func startGameTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !self.isGameActive {
                timer.invalidate()
                return
            }
            
            if self.gameTimeRemaining > 0 {
                self.gameTimeRemaining -= 1
            } else {
                timer.invalidate()
                self.endGame()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func getCollectedCount(for type: BallType) -> Int {
        return totalCollectedBalls[type.rawValue, default: 0]
    }
    
    func resetAllCollections() {
        totalCollectedBalls.removeAll()
        saveCollectedBalls()
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    // MARK: - Balance Management
    
    func convertYellowBallsToMoney(ballsToConvert: Int) -> Bool {
        let yellowBallsCount = getCollectedCount(for: .yellow)
        
        guard ballsToConvert <= yellowBallsCount && ballsToConvert > 0 else {
            return false
        }
        
        // Convert yellow balls to money (1 ball = 10 coins)
        let coinsEarned = ballsToConvert * 10
        playerBalance += coinsEarned
        
        // Remove converted balls from collection
        let newCount = yellowBallsCount - ballsToConvert
        if newCount <= 0 {
            totalCollectedBalls.removeValue(forKey: BallType.yellow.rawValue)
        } else {
            totalCollectedBalls[BallType.yellow.rawValue] = newCount
        }
        
        // Save changes
        saveCollectedBalls()
        savePlayerBalance()
        
        return true
    }
    
    func addMoney(_ amount: Int) {
        playerBalance += amount
        savePlayerBalance()
    }
    
    func spendMoney(_ amount: Int) -> Bool {
        guard playerBalance >= amount else {
            return false
        }
        
        playerBalance -= amount
        savePlayerBalance()
        return true
    }
    
    func consumeRedPearl() -> Bool {
        let redPearlsCount = getCollectedCount(for: .red)
        
        guard redPearlsCount > 0 else {
            return false
        }
        
        // Remove one red pearl from collection
        let newCount = redPearlsCount - 1
        if newCount <= 0 {
            totalCollectedBalls.removeValue(forKey: BallType.red.rawValue)
        } else {
            totalCollectedBalls[BallType.red.rawValue] = newCount
        }
        
        // Save changes
        saveCollectedBalls()
        
        return true
    }
    
    func consumeGreenBoba() -> Bool {
        let greenBobaCount = getCollectedCount(for: .green)
        
        guard greenBobaCount > 0 else {
            return false
        }
        
        // Remove one green boba from collection
        let newCount = greenBobaCount - 1
        if newCount <= 0 {
            totalCollectedBalls.removeValue(forKey: BallType.green.rawValue)
        } else {
            totalCollectedBalls[BallType.green.rawValue] = newCount
        }
        
        // Save changes
        saveCollectedBalls()
        
        return true
    }
    
    // MARK: - Tickets Management
    
    func addTickets(_ amount: Int) {
        playerTickets += amount
        savePlayerTickets()
    }
    
    func spendTickets(_ amount: Int) -> Bool {
        guard playerTickets >= amount else {
            return false
        }
        
        playerTickets -= amount
        savePlayerTickets()
        return true
    }
    
    func hasTickets() -> Bool {
        return playerTickets > 0
    }
}
