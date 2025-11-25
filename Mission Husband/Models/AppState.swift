//
//  AppState.swift
//  Mission Husband
//
//  Central state management for the app
//

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var dailyActions: [DailyAction] = []
    @Published var learningModules: [LearningModule] = []
    @Published var communityPosts: [CommunityPost] = []
    @Published var importantDates: [ImportantDate] = []
    @Published var stats: MissionStats = MissionStats()

    init() {
        // Initialize with defaults
        self.userProfile = UserProfile(
            name: "Mission Operative",
            missionStartDate: Date()
        )
        setupSampleData()
    }

    private func setupSampleData() {
        // Sample daily actions
        dailyActions = [
            DailyAction(
                date: Date().addingTimeInterval(-86400),
                title: "Morning Briefing",
                description: "Start the day with intentional planning"
            ),
            DailyAction(
                date: Date(),
                title: "Evening Connection",
                description: "Dedicate focused time for meaningful conversation"
            )
        ]

        // Sample learning modules
        learningModules = [
            LearningModule(
                order: 0,
                title: "Mission Fundamentals",
                description: "The core principles of sustained success",
                content: "Successful missions require clarity of purpose, consistency in execution, and measurement of results. This module covers the foundation.",
                isUnlocked: true,
                isReviewed: false
            ),
            LearningModule(
                order: 1,
                title: "Communication Protocol",
                description: "Master the art of effective dialogue",
                content: "Communication is the backbone of any strong partnership. Learn techniques for active listening and clear expression.",
                isUnlocked: false,
                isReviewed: false
            ),
            LearningModule(
                order: 2,
                title: "Consistency Strategy",
                description: "Building sustainable habits and routines",
                content: "Small, consistent actions compound over time. Discover how to establish and maintain meaningful routines.",
                isUnlocked: false,
                isReviewed: false
            )
        ]

        // Sample important dates
        importantDates = [
            ImportantDate(
                title: "Anniversary",
                date: Date().addingTimeInterval(86400 * 45),
                type: "anniversary"
            )
        ]

        // Sample community posts
        communityPosts = [
            CommunityPost(
                userId: "user1",
                userName: "Captain Steele",
                content: "Just completed my 30th consecutive day of morning briefings. The consistency is paying off.",
                timestamp: Date().addingTimeInterval(-3600),
                upvotes: 12,
                hasUserUpvoted: false
            ),
            CommunityPost(
                userId: "user2",
                userName: "Operative Dark",
                content: "Started the new communication protocol module. Game changer.",
                timestamp: Date().addingTimeInterval(-7200),
                upvotes: 8,
                hasUserUpvoted: false
            )
        ]

        stats = MissionStats(
            totalActions: 15,
            completedActions: 12,
            averageExecutionScore: 7.8,
            averageReceptionScore: 8.2,
            pointsEarned: 150,
            currentStreak: 5
        )
    }

    func completeAction(id: String, executionScore: Int, receptionScore: Int, notes: String) {
        if let index = dailyActions.firstIndex(where: { $0.id == id }) {
            dailyActions[index].executionScore = executionScore
            dailyActions[index].receptionScore = receptionScore
            dailyActions[index].notes = notes
            updateStats()
        }
    }

    func markModuleReviewed(id: String) {
        if let index = learningModules.firstIndex(where: { $0.id == id }) {
            learningModules[index].isReviewed = true
            // Unlock the next module
            if index + 1 < learningModules.count {
                learningModules[index + 1].isUnlocked = true
            }
        }
    }

    func togglePostUpvote(id: String) {
        if let index = communityPosts.firstIndex(where: { $0.id == id }) {
            communityPosts[index].hasUserUpvoted.toggle()
            communityPosts[index].upvotes += communityPosts[index].hasUserUpvoted ? 1 : -1
        }
    }

    func addCommunityPost(_ post: CommunityPost) {
        var newPost = post
        newPost.timestamp = Date()
        communityPosts.insert(newPost, at: 0)
    }

    func addCommentToPost(postId: String, comment: PostComment) {
        if let index = communityPosts.firstIndex(where: { $0.id == postId }) {
            communityPosts[index].comments.append(comment)
        }
    }

    private func updateStats() {
        stats.totalActions = dailyActions.count
        stats.completedActions = dailyActions.filter { $0.isCompleted }.count

        let executionScores = dailyActions.compactMap { $0.executionScore }
        stats.averageExecutionScore = executionScores.isEmpty ? 0 : Double(executionScores.reduce(0, +)) / Double(executionScores.count)

        let receptionScores = dailyActions.compactMap { $0.receptionScore }
        stats.averageReceptionScore = receptionScores.isEmpty ? 0 : Double(receptionScores.reduce(0, +)) / Double(receptionScores.count)
    }
}
