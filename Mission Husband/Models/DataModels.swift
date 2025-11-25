//
//  DataModels.swift
//  Mission Husband
//
//  Core data models for Mission Husband app
//

import Foundation

// MARK: - User Profile
struct UserProfile: Codable {
    var id: String = UUID().uuidString
    var name: String
    var profileImageData: Data?
    var missionStartDate: Date
    var missionPoints: Int = 0
    var rank: String = "Recruit"
    var bio: String = ""

    var daysOnMission: Int {
        Calendar.current.dateComponents([.day], from: missionStartDate, to: Date()).day ?? 0
    }
}

// MARK: - Daily Action
struct DailyAction: Identifiable, Codable {
    var id: String = UUID().uuidString
    var date: Date
    var title: String
    var description: String
    var executionScore: Int? // 1-10: how well you executed
    var receptionScore: Int?  // 1-10: how well the gesture was received
    var notes: String = ""

    var isCompleted: Bool {
        executionScore != nil && receptionScore != nil
    }
}

// MARK: - Learning Module
struct LearningModule: Identifiable, Codable {
    var id: String = UUID().uuidString
    var order: Int // position in the chain
    var title: String
    var description: String
    var content: String // main content/lesson
    var isUnlocked: Bool = false
    var isReviewed: Bool = false

    var canUnlock: Bool {
        order == 0 || isReviewed // unlock if first or previous is reviewed
    }
}

// MARK: - Community Post
struct CommunityPost: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var userName: String
    var userProfileImage: Data?
    var content: String
    var timestamp: Date
    var upvotes: Int = 0
    var comments: [PostComment] = []
    var hasUserUpvoted: Bool = false
}

struct PostComment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var userName: String
    var userProfileImage: Data?
    var content: String
    var timestamp: Date
}

// MARK: - Important Dates
struct ImportantDate: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var type: String // anniversary, birthday, event, etc.
}

// MARK: - Mission Stats
struct MissionStats: Codable {
    var totalActions: Int = 0
    var completedActions: Int = 0
    var averageExecutionScore: Double = 0
    var averageReceptionScore: Double = 0
    var pointsEarned: Int = 0
    var currentStreak: Int = 0
}
