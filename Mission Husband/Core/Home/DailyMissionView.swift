//
//  DailyMissionView.swift
//  Mission Husband
//
//  Main screen showing today's daily action and results tracking
//

import SwiftUI

struct DailyMissionView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCompletionSheet = false

    var todayAction: DailyAction? {
        let today = Calendar.current.startOfDay(for: Date())
        return appState.dailyActions.first {
            Calendar.current.startOfDay(for: $0.date) == today
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("TODAY'S MISSION")
                        .font(.headline)
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.accent)

                    Text("OPERATIVE LOG")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppTheme.surface)

                ScrollView {
                    VStack(spacing: 20) {
                        if let action = todayAction {
                            // Current action card
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(action.title)
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(AppTheme.text)

                                    Text(action.description)
                                        .font(.body)
                                        .foregroundStyle(AppTheme.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Divider()
                                    .background(AppTheme.charcoal)

                                if !action.isCompleted {
                                    Button {
                                        showCompletionSheet = true
                                    } label: {
                                        Label("LOG RESULTS", systemImage: "checkmark.circle.fill")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.accent)
                                    .foregroundStyle(AppTheme.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    // Show completion status
                                    VStack(spacing: 12) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("EXECUTION")
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                                Text("\(action.executionScore ?? 0)/10")
                                                    .font(.title3)
                                                    .bold()
                                                    .foregroundStyle(AppTheme.accent)
                                            }
                                            Spacer()
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("RECEPTION")
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                                Text("\(action.receptionScore ?? 0)/10")
                                                    .font(.title3)
                                                    .bold()
                                                    .foregroundStyle(AppTheme.accent)
                                            }
                                            Spacer()
                                        }

                                        if !action.notes.isEmpty {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("NOTES")
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                                Text(action.notes)
                                                    .font(.body)
                                                    .foregroundStyle(AppTheme.text)
                                            }
                                        }

                                        Button {
                                            showCompletionSheet = true
                                        } label: {
                                            Text("EDIT")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(AppTheme.charcoal)
                                        .foregroundStyle(AppTheme.accent)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            .padding()
                            .background(AppTheme.charcoal)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            // Mission history
                            VStack(alignment: .leading, spacing: 12) {
                                Text("MISSION HISTORY")
                                    .font(.headline)
                                    .tracking(1.2)
                                    .foregroundStyle(AppTheme.accent)

                                VStack(spacing: 8) {
                                    ForEach(appState.dailyActions.filter { $0.id != action.id }.sorted { $0.date > $1.date }.prefix(5)) { pastAction in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(pastAction.title)
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(AppTheme.text)
                                                Text(pastAction.date.formatted(date: .abbreviated, time: .omitted))
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.secondary)
                                            }
                                            Spacer()
                                            if pastAction.isCompleted {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(AppTheme.accent)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(AppTheme.surface)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            // No mission today placeholder
                            VStack(spacing: 20) {
                                Image(systemName: "target")
                                    .font(.system(size: 60))
                                    .foregroundStyle(AppTheme.accent.opacity(0.5))

                                VStack(spacing: 8) {
                                    Text("NO MISSION ASSIGNED")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.text)
                                    Text("Check back tomorrow for your next action")
                                        .font(.body)
                                        .foregroundStyle(AppTheme.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxHeight: .infinity)
                            .padding()
                        }
                    }
                    .padding()
                }
            }
            .background(AppTheme.background)
            .sheet(isPresented: $showCompletionSheet) {
                if let action = todayAction {
                    MissionCompletionSheet(action: action, isPresented: $showCompletionSheet)
                        .environmentObject(appState)
                }
            }
        }
    }
}

struct MissionCompletionSheet: View {
    let action: DailyAction
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState

    @State private var executionScore = 5
    @State private var receptionScore = 5
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.body)

                    Spacer()

                    Text("LOG RESULTS")
                        .font(.headline)
                        .tracking(1.2)

                    Spacer()

                    Button("Save") {
                        appState.completeAction(
                            id: action.id,
                            executionScore: executionScore,
                            receptionScore: receptionScore,
                            notes: notes
                        )
                        isPresented = false
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.accent)
                }
                .padding()
                .background(AppTheme.surface)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(action.title)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(AppTheme.text)
                            Text(action.description)
                                .font(.body)
                                .foregroundStyle(AppTheme.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Execution Score
                        VStack(alignment: .leading, spacing: 12) {
                            Text("HOW WELL DID YOU EXECUTE?")
                                .font(.headline)
                                .tracking(1.0)
                                .foregroundStyle(AppTheme.accent)

                            HStack(spacing: 0) {
                                ForEach(1...10, id: \.self) { score in
                                    Button {
                                        executionScore = score
                                    } label: {
                                        Text("\(score)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(executionScore == score ? AppTheme.accent : AppTheme.charcoal)
                                    .foregroundStyle(executionScore == score ? AppTheme.black : AppTheme.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Reception Score
                        VStack(alignment: .leading, spacing: 12) {
                            Text("HOW WAS IT RECEIVED?")
                                .font(.headline)
                                .tracking(1.0)
                                .foregroundStyle(AppTheme.accent)

                            HStack(spacing: 0) {
                                ForEach(1...10, id: \.self) { score in
                                    Button {
                                        receptionScore = score
                                    } label: {
                                        Text("\(score)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(receptionScore == score ? AppTheme.accent : AppTheme.charcoal)
                                    .foregroundStyle(receptionScore == score ? AppTheme.black : AppTheme.text)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Notes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MISSION NOTES")
                                .font(.headline)
                                .tracking(1.0)
                                .foregroundStyle(AppTheme.accent)

                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(AppTheme.background)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .font(.body)
                                .foregroundStyle(AppTheme.text)
                        }
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
                .background(AppTheme.background)
            }
            .background(AppTheme.background)
        }
    }
}

#Preview {
    DailyMissionView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
