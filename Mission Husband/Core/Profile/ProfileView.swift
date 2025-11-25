//
//  ProfileView.swift
//  Mission Husband
//
//  Profile and stats section with user info, graphs, and mission history
//

import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("OPERATIVE PROFILE")
                        .font(.headline)
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.accent)

                    Text("YOUR STATS")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppTheme.surface)

                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack(spacing: 16) {
                            Circle()
                                .fill(AppTheme.charcoal)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(AppTheme.accent)
                                )

                            VStack(spacing: 8) {
                                Text(appState.userProfile.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(AppTheme.text)

                                Text("On the mission since: \(appState.userProfile.missionStartDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Mission Stats Grid
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                StatCard(
                                    title: "MISSION POINTS",
                                    value: "\(appState.stats.pointsEarned)",
                                    icon: "star.fill",
                                    color: AppTheme.accent
                                )

                                StatCard(
                                    title: "RANK",
                                    value: appState.userProfile.rank,
                                    icon: "flag.fill",
                                    color: AppTheme.accent
                                )
                            }

                            HStack(spacing: 12) {
                                StatCard(
                                    title: "CURRENT STREAK",
                                    value: "\(appState.stats.currentStreak)",
                                    icon: "flame.fill",
                                    color: AppTheme.accent
                                )

                                StatCard(
                                    title: "COMPLETION RATE",
                                    value: appState.stats.totalActions > 0 ? "\(Int((Double(appState.stats.completedActions) / Double(appState.stats.totalActions)) * 100))%" : "0%",
                                    icon: "checkmark.circle.fill",
                                    color: AppTheme.accent
                                )
                            }
                        }
                        .padding(.horizontal)

                        // Important Dates
                        if !appState.importantDates.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("UPCOMING OPERATIONS")
                                    .font(.headline)
                                    .tracking(1.2)
                                    .foregroundStyle(AppTheme.accent)
                                    .padding(.horizontal)

                                VStack(spacing: 8) {
                                    ForEach(appState.importantDates.sorted { $0.date < $1.date }) { date in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(date.title)
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(AppTheme.text)

                                                Text(date.date.formatted(date: .abbreviated, time: .omitted))
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                            }

                                            Spacer()

                                            Text(daysUntil(date.date))
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(AppTheme.accent)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(AppTheme.surface)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Performance Graphs
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PERFORMANCE TRENDS")
                                .font(.headline)
                                .tracking(1.2)
                                .foregroundStyle(AppTheme.accent)
                                .padding(.horizontal)

                            VStack(spacing: 16) {
                                // Execution Score
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Execution Average")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.secondary)

                                        Spacer()

                                        Text(String(format: "%.1f", appState.stats.averageExecutionScore))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.accent)
                                    }

                                    ProgressBar(value: appState.stats.averageExecutionScore / 10)
                                }

                                // Reception Score
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Reception Average")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.secondary)

                                        Spacer()

                                        Text(String(format: "%.1f", appState.stats.averageReceptionScore))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.accent)
                                    }

                                    ProgressBar(value: appState.stats.averageReceptionScore / 10)
                                }

                                // Actions Completed
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Actions Completed")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.secondary)

                                        Spacer()

                                        Text("\(appState.stats.completedActions)/\(appState.stats.totalActions)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.accent)
                                    }

                                    ProgressBar(value: appState.stats.totalActions > 0 ? Double(appState.stats.completedActions) / Double(appState.stats.totalActions) : 0)
                                }
                            }
                            .padding()
                            .background(AppTheme.charcoal)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }

                        // Mission History
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MISSION LOG")
                                .font(.headline)
                                .tracking(1.2)
                                .foregroundStyle(AppTheme.accent)
                                .padding(.horizontal)

                            VStack(spacing: 8) {
                                ForEach(appState.dailyActions.sorted { $0.date > $1.date }) { action in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(action.title)
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(AppTheme.text)

                                                Text(action.date.formatted(date: .abbreviated, time: .omitted))
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                            }

                                            Spacer()

                                            if action.isCompleted {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.accent)
                                            }
                                        }

                                        if action.isCompleted, let execution = action.executionScore, let reception = action.receptionScore {
                                            HStack(spacing: 16) {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Execution")
                                                        .font(.caption2)
                                                        .foregroundStyle(AppTheme.secondary)
                                                    Text("\(execution)/10")
                                                        .font(.caption)
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(AppTheme.accent)
                                                }

                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Reception")
                                                        .font(.caption2)
                                                        .foregroundStyle(AppTheme.secondary)
                                                    Text("\(reception)/10")
                                                        .font(.caption)
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(AppTheme.accent)
                                                }

                                                Spacer()
                                            }

                                            if !action.notes.isEmpty {
                                                Text(action.notes)
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                                    .lineSpacing(1)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(AppTheme.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(AppTheme.background)
            }
            .background(AppTheme.background)
        }
    }

    private func daysUntil(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days < 0 {
            return "Passed"
        } else if days == 0 {
            return "Today"
        } else if days == 1 {
            return "Tomorrow"
        } else {
            return "\(days)d away"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            VStack(spacing: 4) {
                Text(value)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(AppTheme.text)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.charcoal)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ProgressBar: View {
    let value: Double

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(AppTheme.surface)
                .frame(height: 8)

            RoundedRectangle(cornerRadius: 4)
                .fill(AppTheme.accent)
                .frame(width: max(8, 200 * value), height: 8)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
