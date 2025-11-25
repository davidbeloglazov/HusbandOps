//
//  CommunityView.swift
//  Mission Husband
//
//  Community section for posts, upvotes, and comments
//

import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var appState: AppState
    @State private var showNewPost = false
    @State private var expandedPostId: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("COMMAND CENTER")
                        .font(.headline)
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.accent)

                    Text("OPERATIVE NETWORK")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppTheme.surface)

                // New Post Button
                HStack {
                    Spacer()
                    Button {
                        showNewPost = true
                    } label: {
                        Image(systemName: "square.and.pencil.fill")
                            .font(.title3)
                        Text("NEW REPORT")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.accent)
                    .foregroundStyle(AppTheme.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
                .background(AppTheme.surface)

                // Posts Feed
                ScrollView {
                    VStack(spacing: 12) {
                        if appState.communityPosts.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "message")
                                    .font(.system(size: 60))
                                    .foregroundStyle(AppTheme.accent.opacity(0.5))

                                VStack(spacing: 8) {
                                    Text("NO REPORTS YET")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.text)
                                    Text("Be the first to share your progress")
                                        .font(.body)
                                        .foregroundStyle(AppTheme.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxHeight: .infinity)
                            .padding()
                        } else {
                            ForEach(appState.communityPosts) { post in
                                CommunityPostCard(post: post, isExpanded: expandedPostId == post.id)
                                    .environmentObject(appState)
                                    .onTapGesture {
                                        withAnimation {
                                            expandedPostId = expandedPostId == post.id ? nil : post.id
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
                .background(AppTheme.background)
            }
            .background(AppTheme.background)
            .sheet(isPresented: $showNewPost) {
                NewPostSheet(isPresented: $showNewPost)
                    .environmentObject(appState)
            }
        }
    }
}

struct CommunityPostCard: View {
    let post: CommunityPost
    let isExpanded: Bool
    @EnvironmentObject var appState: AppState
    @State private var showCommentInput = false
    @State private var commentText = ""

    var body: some View {
        VStack(spacing: 12) {
            // Post header with user info
            HStack(spacing: 12) {
                Circle()
                    .fill(AppTheme.charcoal)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.accent)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.userName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.text)

                    Text(post.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary)
                }

                Spacer()
            }

            // Post content
            Text(post.content)
                .font(.body)
                .foregroundStyle(AppTheme.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(2)

            Divider()
                .background(AppTheme.charcoal)

            // Engagement metrics
            HStack(spacing: 20) {
                Button {
                    appState.togglePostUpvote(id: post.id)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: post.hasUserUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.caption)
                        Text("\(appState.communityPosts.first { $0.id == post.id }?.upvotes ?? post.upvotes)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(appState.communityPosts.first { $0.id == post.id }?.hasUserUpvoted == true ? AppTheme.accent : AppTheme.secondary)
                }

                Button {
                    withAnimation {
                        showCommentInput.toggle()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                            .font(.caption)
                        Text("\(appState.communityPosts.first { $0.id == post.id }?.comments.count ?? 0)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(AppTheme.secondary)
                }

                Spacer()
            }

            // Comments section
            if isExpanded {
                VStack(spacing: 12) {
                    Divider()
                        .background(AppTheme.charcoal)

                    // Existing comments
                    if let expandedPost = appState.communityPosts.first(where: { $0.id == post.id }), !expandedPost.comments.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("RESPONSES")
                                .font(.caption)
                                .tracking(1.0)
                                .foregroundStyle(AppTheme.accent)

                            VStack(spacing: 12) {
                                ForEach(expandedPost.comments) { comment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 8) {
                                            Text(comment.userName)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(AppTheme.text)

                                            Spacer()

                                            Text(comment.timestamp.formatted(date: .omitted, time: .shortened))
                                                .font(.caption2)
                                                .foregroundStyle(AppTheme.secondary)
                                        }

                                        Text(comment.content)
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(AppTheme.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }
                        }
                    }

                    // Comment input
                    if showCommentInput {
                        HStack(spacing: 8) {
                            TextField("Add a response...", text: $commentText)
                                .font(.caption)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(AppTheme.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 6))

                            Button {
                                let newComment = PostComment(
                                    userId: appState.userProfile.id,
                                    userName: appState.userProfile.name,
                                    content: commentText,
                                    timestamp: Date()
                                )
                                appState.addCommentToPost(postId: post.id, comment: newComment)
                                commentText = ""
                                showCommentInput = false
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(commentText.isEmpty ? AppTheme.secondary : AppTheme.accent)
                            }
                            .disabled(commentText.isEmpty)
                        }
                    }
                }
            }
        }
        .padding()
        .background(AppTheme.charcoal)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NewPostSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    @State private var postText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.body)

                    Spacer()

                    Text("NEW REPORT")
                        .font(.headline)
                        .tracking(1.2)

                    Spacer()

                    Button("Post") {
                        let newPost = CommunityPost(
                            userId: appState.userProfile.id,
                            userName: appState.userProfile.name,
                            content: postText,
                            timestamp: Date()
                        )
                        appState.addCommunityPost(newPost)
                        isPresented = false
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.accent)
                    .disabled(postText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                .background(AppTheme.surface)

                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(AppTheme.charcoal)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.accent)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(appState.userProfile.name)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.text)

                            Text("Posting to network")
                                .font(.caption)
                                .foregroundStyle(AppTheme.secondary)
                        }
                    }

                    TextEditor(text: $postText)
                        .frame(minHeight: 200)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(AppTheme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(.body)
                        .foregroundStyle(AppTheme.text)
                }
                .padding()

                Spacer()
            }
            .background(AppTheme.background)
        }
    }
}

#Preview {
    CommunityView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
