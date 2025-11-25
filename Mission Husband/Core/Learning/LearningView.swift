//
//  LearningView.swift
//  Mission Husband
//
//  Learning section showing sequential learning modules in a chain format
//

import SwiftUI

struct LearningView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedModule: LearningModule?
    @State private var showDetail = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("LEARNING COMMAND")
                        .font(.headline)
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.accent)

                    Text("TRAINING SEQUENCE")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppTheme.surface)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(appState.learningModules.sorted { $0.order < $1.order }) { module in
                            VStack(spacing: 0) {
                                // Module Card
                                Button {
                                    if module.isUnlocked {
                                        selectedModule = module
                                        showDetail = true
                                    }
                                } label: {
                                    HStack(spacing: 16) {
                                        // Status indicator
                                        VStack(spacing: 4) {
                                            if module.isReviewed {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 28))
                                                    .foregroundStyle(AppTheme.accent)
                                            } else if module.isUnlocked {
                                                Circle()
                                                    .strokeBorder(AppTheme.accent, lineWidth: 2)
                                                    .frame(width: 28, height: 28)
                                                    .overlay(
                                                        Text("\(module.order + 1)")
                                                            .font(.caption)
                                                            .fontWeight(.semibold)
                                                            .foregroundStyle(AppTheme.accent)
                                                    )
                                            } else {
                                                Circle()
                                                    .fill(AppTheme.charcoal)
                                                    .frame(width: 28, height: 28)
                                                    .overlay(
                                                        Image(systemName: "lock.fill")
                                                            .font(.caption)
                                                            .foregroundStyle(AppTheme.secondary)
                                                    )
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(module.title)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(AppTheme.text)

                                            Text(module.description)
                                                .font(.caption)
                                                .foregroundStyle(AppTheme.secondary)
                                                .lineLimit(2)
                                        }

                                        Spacer()

                                        if !module.isUnlocked {
                                            Image(systemName: "lock.fill")
                                                .font(.caption)
                                                .foregroundStyle(AppTheme.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(AppTheme.charcoal)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(!module.isUnlocked)
                                .opacity(module.isUnlocked ? 1 : 0.6)

                                // Connector line
                                if appState.learningModules.last?.id != module.id {
                                    VStack(spacing: 0) {
                                        Divider()
                                            .frame(height: 2)
                                            .background(AppTheme.accent.opacity(0.3))
                                            .padding(.vertical, 8)

                                        Image(systemName: "arrow.down")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.accent.opacity(0.3))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .background(AppTheme.background)

                Spacer()
            }
            .background(AppTheme.background)
            .sheet(isPresented: $showDetail) {
                if let module = selectedModule {
                    LearningDetailView(module: module, isPresented: $showDetail)
                        .environmentObject(appState)
                }
            }
        }
    }
}

struct LearningDetailView: View {
    let module: LearningModule
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Close") {
                        isPresented = false
                    }
                    .font(.body)

                    Spacer()

                    Text("MODULE \(module.order + 1)")
                        .font(.headline)
                        .tracking(1.2)

                    Spacer()

                    if !module.isReviewed {
                        Button {
                            appState.markModuleReviewed(id: module.id)
                            isPresented = false
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.body)
                        }
                        .foregroundStyle(AppTheme.accent)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding()
                .background(AppTheme.surface)

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Text(module.title)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(AppTheme.text)

                            Text(module.description)
                                .font(.body)
                                .foregroundStyle(AppTheme.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 12) {
                            Text("LESSON CONTENT")
                                .font(.headline)
                                .tracking(1.0)
                                .foregroundStyle(AppTheme.accent)

                            Text(module.content)
                                .font(.body)
                                .foregroundStyle(AppTheme.text)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(AppTheme.charcoal)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        if !module.isReviewed {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("KEY TAKEAWAYS")
                                    .font(.headline)
                                    .tracking(1.0)
                                    .foregroundStyle(AppTheme.accent)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(["Understand the fundamentals", "Apply consistently", "Measure your progress"], id: \.self) { takeaway in
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .font(.caption)
                                                .foregroundStyle(AppTheme.accent)
                                            Text(takeaway)
                                                .font(.body)
                                                .foregroundStyle(AppTheme.text)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(AppTheme.charcoal)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
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
    LearningView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
