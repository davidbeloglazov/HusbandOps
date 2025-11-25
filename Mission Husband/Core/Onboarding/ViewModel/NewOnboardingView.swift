//
//  NewOnboardingView.swift
//  HusbandOps
//
//  Created by David Beloglazov on 11/20/25.
//

import SwiftUI

// MARK: - Data Models & Enums

enum OnboardingStep {
    case splash              // Page 1A
    case welcome             // Page 2
    case signUp              // Page 3
    case quiz(index: Int)    // Page 5 (Questions 1-10)
    case aboutYou            // Page 5 (End)
    case calculating         // Page 6
    case analysis            // Page 7
    case impacts             // Page 8
    case driftCarousel       // Page 9 (The Drift)
    case tacticalCarousel    // Page 10 (Welcome/Tactical)
    case benefitsTestimonials // Page 11
    case stabilityGraph      // Page 12
    case missionObjectives   // Page 13
    case referral            // Page 14
    case ratings             // Page 15
    case commitment          // Page 16
    case planIntro           // Page 17
    case operationsOrder     // Page 18
    case oneTimeOffer        // Page 19
    case breakStagnation     // Page 20
    case allInOne            // Page 21
    case subscription        // Page 22
}

struct QuizOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
}

struct QuestionData {
    let title: String
    let text: String
    let options: [QuizOption]
}

struct Line {
    var points: [CGPoint]
}

struct TestimonialData: Identifiable {
    let id = UUID()
    let name: String
    let handle: String?
    let text: String
    let role: String? // e.g., "Ph.D."
    let isVerified: Bool
    let imageName: String
}

// MARK: - Main Content View

struct NewOnboardingView: View {
    @State private var currentStep: OnboardingStep = .splash
    
    // Quiz Data
    let questions: [QuestionData] = [
        QuestionData(title: "Question #1", text: "How long have you and your wife been together?", options: [
            QuizOption(text: "1 year or less"), QuizOption(text: "2–5 years"), QuizOption(text: "6–10 years"), QuizOption(text: "11+ years")
        ]),
        QuestionData(title: "Question #2", text: "How much time do you and your wife spend alone together each week (not counting chores or kids)?", options: [
            QuizOption(text: "Several hours"), QuizOption(text: "1–2 hours"), QuizOption(text: "Less than 1 hour"), QuizOption(text: "Almost never")
        ]),
        QuestionData(title: "Question #3", text: "How often do you and your wife have arguments?", options: [
            QuizOption(text: "More than once a day"), QuizOption(text: "Once a day"), QuizOption(text: "A few times a week"), QuizOption(text: "Less than once a week")
        ]),
        QuestionData(title: "Question #4", text: "Does she ever criticize you or your work in a way that feels personal?", options: [
            QuizOption(text: "Frequently"), QuizOption(text: "Occasionally"), QuizOption(text: "Rarely or never")
        ]),
        QuestionData(title: "Question #5", text: "When was the last time she genuinely laughed at your joke?", options: [
            QuizOption(text: "Within the past week"), QuizOption(text: "Within the past month"), QuizOption(text: "A few months ago"), QuizOption(text: "Honestly, I don’t even try anymore")
        ]),
        QuestionData(title: "Question #6", text: "Do you find it difficult to feel desire or initiate intimacy?", options: [
            QuizOption(text: "Frequently"), QuizOption(text: "Occasionally"), QuizOption(text: "Rarely or never")
        ]),
        QuestionData(title: "Question #7", text: "Do you use work, your phone, or hobbies to avoid tough conversations?", options: [
            QuizOption(text: "Frequently"), QuizOption(text: "Occasionally"), QuizOption(text: "Rarely or never")
        ]),
        QuestionData(title: "Question #8", text: "Do simple requests — like her doing the dishes or tidying up — often lead to conflict?", options: [
            QuizOption(text: "Frequently"), QuizOption(text: "Occasionally"), QuizOption(text: "Rarely or never")
        ]),
        QuestionData(title: "Question #9", text: "When you come home, do you hesitate before opening the door — because you don’t know what mood you’re walking into.", options: [
            QuizOption(text: "Frequently"), QuizOption(text: "Occasionally"), QuizOption(text: "Rarely or never")
        ]),
        QuestionData(title: "Question #10", text: "Have arguments ever escalated to talk — or threats — of separation or divorce?", options: [
            QuizOption(text: "Yes"), QuizOption(text: "No"), QuizOption(text: "Somewhat")
        ])
    ]
    
    var body: some View {
        ZStack {
            // Global Background
            StarryBackground()
                .ignoresSafeArea()
            
            // Main Content Switcher
            Group {
                switch currentStep {
                case .splash:
                    SplashView(onFinished: { withAnimation { currentStep = .welcome } })
                case .welcome:
                    WelcomeView(onStart: { withAnimation { currentStep = .signUp } })
                case .signUp:
                    SignUpView(onSkip: { withAnimation { currentStep = .quiz(index: 0) } })
                case .quiz(let index):
                    if index < questions.count {
                        QuestionView(
                            step: index + 1,
                            totalSteps: questions.count,
                            data: questions[index],
                            onNext: {
                                let nextIndex = index + 1
                                if nextIndex < questions.count {
                                    withAnimation { currentStep = .quiz(index: nextIndex) }
                                } else {
                                    withAnimation { currentStep = .aboutYou }
                                }
                            }
                        )
                    }
                case .aboutYou:
                    AboutYouView(onNext: { withAnimation { currentStep = .calculating } })
                case .calculating:
                    CalculatingView(onFinished: { withAnimation { currentStep = .analysis } })
                case .analysis:
                    AnalysisView(onNext: { withAnimation { currentStep = .impacts } })
                case .impacts:
                    ImpactsView(onNext: { withAnimation { currentStep = .driftCarousel } })
                case .driftCarousel:
                    DriftCarouselView(onNext: { withAnimation { currentStep = .tacticalCarousel } })
                case .tacticalCarousel:
                    TacticalCarouselView(onNext: { withAnimation { currentStep = .benefitsTestimonials } })
                case .benefitsTestimonials:
                    BenefitsTestimonialsView(onNext: { withAnimation { currentStep = .stabilityGraph } })
                case .stabilityGraph:
                    StabilityGraphView(onNext: { withAnimation { currentStep = .missionObjectives } })
                case .missionObjectives:
                    MissionObjectivesView(onNext: { withAnimation { currentStep = .referral } })
                case .referral:
                    ReferralView(onNext: { withAnimation { currentStep = .ratings } })
                case .ratings:
                    RatingsView(onNext: { withAnimation { currentStep = .commitment } })
                case .commitment:
                    CommitmentView(onNext: { withAnimation { currentStep = .planIntro } })
                case .planIntro:
                    PlanIntroView(onNext: { withAnimation { currentStep = .operationsOrder } })
                case .operationsOrder:
                    OperationsOrderView(onNext: { withAnimation { currentStep = .oneTimeOffer } })
                case .oneTimeOffer:
                    OneTimeOfferView(onNext: { withAnimation { currentStep = .breakStagnation } })
                case .breakStagnation:
                    BreakStagnationView(onNext: { withAnimation { currentStep = .allInOne } })
                case .allInOne:
                    AllInOneView(onNext: { withAnimation { currentStep = .subscription } })
                case .subscription:
                    SubscriptionView()
                }
            }
            .transition(.opacity.combined(with: .move(edge: .trailing)))
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Page Views

// PAGE 1A
struct SplashView: View {
    var onFinished: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("HUSBAND OPS").font(.system(size: 40, weight: .heavy, design: .monospaced)).foregroundColor(.white).tracking(2)
            Text("Being a Great Husband. Operationalized.").font(.title3).fontWeight(.medium).multilineTextAlignment(.center).foregroundColor(.white.opacity(0.9))
            FiveStars()
            Spacer()
        }
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { onFinished() } }
    }
}

// PAGE 2
struct WelcomeView: View {
    var onStart: () -> Void
    var body: some View {
        VStack {
            Text("HUSBAND OPS").font(.system(size: 24, weight: .bold, design: .monospaced)).tracking(1).padding(.top, 40)
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome!").font(.largeTitle).fontWeight(.bold)
                Text("Let’s start by finding out where your marriage stands.").font(.title3)
            }.padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
            FiveStars().padding(.vertical, 50)
            Spacer()
            Button(action: onStart) {
                HStack { Text("Start Quiz").fontWeight(.bold); Image(systemName: "chevron.right") }
                    .frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30)
            Button("Already joined via web?") {}.font(.footnote).foregroundColor(.white.opacity(0.7)).padding(.bottom, 40).padding(.top, 10)
        }
    }
}

// PAGE 3
struct SignUpView: View {
    var onSkip: () -> Void
    var body: some View {
        VStack {
            Spacer().frame(height: 60)
            Text("HUSBAND OPS").font(.system(size: 32, weight: .heavy, design: .monospaced)).tracking(1)
            Spacer()
            VStack(spacing: 24) {
                Text("Become part of\nHusband Ops").font(.title).fontWeight(.bold).multilineTextAlignment(.center)
                Text("Join husbands on a mission to rebuild connection, strength, and desire.").multilineTextAlignment(.center).font(.body).foregroundColor(.gray).padding(.horizontal, 30)
            }
            Spacer()
            VStack(spacing: 12) {
                Button(action: {}) { HStack { Image(systemName: "apple.logo"); Text("Continue with Apple") }.frame(maxWidth: .infinity).padding().background(Color.black).foregroundColor(.white).cornerRadius(30).overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.2))) }
                Button(action: {}) { HStack { Text("G").fontWeight(.heavy).foregroundColor(.blue); Text("Continue with Google") }.frame(maxWidth: .infinity).padding().background(Color.white.opacity(0.05)).foregroundColor(.white).cornerRadius(30).overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.2))) }
                Button(action: onSkip) { HStack { Text("Skip for now"); Image(systemName: "arrow.right") }.frame(maxWidth: .infinity).padding().background(Color.clear).foregroundColor(.white).overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.3))).cornerRadius(30) }
            }.padding(.horizontal, 30)
            Button("Want to skip this step? Skip") { onSkip() }.font(.caption).foregroundColor(.gray).padding(.top, 10).padding(.bottom, 40)
        }
    }
}

// PAGE 5 & 5 (End)
struct QuestionView: View {
    var step: Int; var totalSteps: Int; var data: QuestionData; var onNext: () -> Void
    @State private var selectedOption: UUID?
    var body: some View {
        VStack {
            HStack {
                GeometryReader { geo in ZStack(alignment: .leading) { Capsule().fill(Color.white.opacity(0.2)); Capsule().fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)).frame(width: geo.size.width * (CGFloat(step) / CGFloat(totalSteps))) } }.frame(height: 6)
            }.padding().padding(.top, 20)
            Spacer()
            Text(data.title).font(.headline).fontWeight(.bold).foregroundColor(.gray).padding(.bottom, 8)
            Text(data.text).font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.horizontal).fixedSize(horizontal: false, vertical: true)
            Spacer().frame(height: 40)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(data.options, id: \.self) { option in
                        Button(action: { selectedOption = option.id; DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { selectedOption = nil; onNext() } }) {
                            HStack {
                                ZStack { Circle().fill(selectedOption == option.id ? Color.blue : Color.white.opacity(0.1)).frame(width: 24, height: 24); if selectedOption == option.id { Image(systemName: "checkmark").font(.caption2).foregroundColor(.white) } }
                                Text(option.text).fontWeight(.medium).foregroundColor(.white).padding(.leading, 8).multilineTextAlignment(.leading)
                                Spacer()
                            }.padding().background(Color.white.opacity(0.08)).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedOption == option.id ? Color.blue : Color.clear, lineWidth: 2))
                        }
                    }
                }.padding(.horizontal)
            }
            Spacer()
        }
    }
}

struct AboutYouView: View {
    var onNext: () -> Void; @State private var name = ""; @State private var age = ""
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            Text("Finally").font(.largeTitle).fontWeight(.bold)
            Text("A little more **about you**").foregroundColor(.gray).font(.title3)
            Spacer().frame(height: 30)
            VStack(alignment: .leading, spacing: 8) { Text("Name").font(.caption).foregroundColor(.gray).padding(.leading); TextField("Name", text: $name).padding().background(Color.white.opacity(0.1)).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2))) }.padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) { Text("Age").font(.caption).foregroundColor(.gray).padding(.leading); TextField("Age", text: $age).padding().background(Color.white.opacity(0.1)).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2))).keyboardType(.numberPad) }.padding(.horizontal)
            Spacer()
            Button(action: onNext) { Text("Complete Quiz").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30) }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 6 & 7
struct CalculatingView: View {
    var onFinished: () -> Void; @State private var progress: CGFloat = 0.0; @State private var statusText = "Understanding responses"
    let statuses = ["Understanding responses", "Analyzing your relationship dynamics", "Detecting stagnation loops", "Learning friction points", "Evaluating communication recovery rate", "Calculating overall mission readiness"]
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 20)
                Circle().trim(from: 0, to: progress).stroke(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 20, lineCap: .round)).rotationEffect(.degrees(-90)).animation(.easeOut(duration: 5.0), value: progress)
                Text("\(Int(progress * 100))%").font(.system(size: 50, weight: .bold))
            }.frame(width: 200, height: 200)
            Spacer().frame(height: 40)
            Text("Calculating").font(.largeTitle).fontWeight(.bold)
            Text(statusText).foregroundColor(.gray).padding(.top, 8).font(.headline).id(statusText).transition(.opacity)
            Spacer()
        }.onAppear {
            progress = 1.0; let interval = 5.0 / Double(statuses.count)
            for (index, status) in statuses.enumerated() { DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * interval)) { withAnimation { statusText = status } } }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) { onFinished() }
        }
    }
}

struct AnalysisView: View {
    var onNext: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            HStack { Text("Analysis Complete").font(.title2).fontWeight(.bold); Image(systemName: "checkmark.circle.fill").foregroundColor(.green) }
            Text("We’ve got some news to break to you…").font(.subheadline).foregroundColor(.gray)
            Text("Your responses indicate that your Relationship Strain Index is higher than average*").multilineTextAlignment(.center).padding(.horizontal).font(.title3).fontWeight(.semibold).padding(.vertical, 10)
            Spacer()
            HStack(alignment: .bottom, spacing: 60) {
                VStack { Text("64%").font(.headline).padding(6).background(Color.white.opacity(0.1)).cornerRadius(4).padding(.bottom, 4); Rectangle().fill(Color.red).frame(width: 60, height: 220).cornerRadius(8, corners: [.topLeft, .topRight]); Text("Your Score").font(.caption).fontWeight(.bold).padding(.top, 8) }
                VStack { Text("32%").font(.headline).padding(6).background(Color.white.opacity(0.1)).cornerRadius(4).padding(.bottom, 4); Rectangle().fill(Color.green).frame(width: 60, height: 110).cornerRadius(8, corners: [.topLeft, .topRight]); Text("Average").font(.caption).foregroundColor(.gray).padding(.top, 8) }
            }.padding(.bottom, 20)
            HStack { Text("32%").foregroundColor(.red).fontWeight(.bold); Text("higher relationship strain"); Image(systemName: "arrow.down.right.circle.fill").foregroundColor(.red) }.font(.subheadline)
            Spacer()
            Text("* Relationship Strain Index (RSI) measures frequency of conflict, avoidance, and emotional shutdown vs. connected baselines.").font(.caption2).foregroundColor(.gray).padding(.horizontal, 30).multilineTextAlignment(.center).padding(.bottom, 10)
            Button(action: onNext) { Text("Review your strain profile").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30) }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 8
struct ImpactsView: View {
    var onNext: () -> Void
    @State private var selectedItems: Set<String> = []
    
    // Grouped data structure
    let categories: [(String, [String])] = [
        ("Mental", ["Mentally checked out during conversations", "Losing patience faster than usual", "Replaying arguments", "Poor memory or \"brain fog\""]),
        ("Physical", ["Persistent fatigue", "Lower sex drive", "Feeling older or slower than you should"]),
        ("Social", ["Operating solo in your own home", "Avoiding the hard conversations", "Feeling undermined in front of others", "Navigating a minefield", "Withdrawing from the squad"]),
        ("Purpose", ["Feeling like just a ATM machine", "Loss of direction for the family future"])
    ]
    
    var body: some View {
        VStack {
            HStack { Spacer(); Text("Impacts of Relationship Strain").fontWeight(.semibold); Spacer() }.padding().foregroundColor(.white)
            
            Text("Chronic relationship strain shows up as measurable drops in energy, focus, and real-world success.")
                .font(.body).foregroundColor(.gray).padding(.horizontal).multilineTextAlignment(.center)
            
            Text("Review the indicators below and mark what applies to you:")
                .font(.subheadline).fontWeight(.semibold).padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(categories, id: \.0) { category in
                        VStack(alignment: .leading) {
                            Text(category.0).font(.headline).foregroundColor(.white).padding(.horizontal)
                            ForEach(category.1, id: \.self) { item in
                                Button(action: {
                                    if selectedItems.contains(item) { selectedItems.remove(item) } else { selectedItems.insert(item) }
                                }) {
                                    HStack {
                                        Image(systemName: selectedItems.contains(item) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedItems.contains(item) ? .blue : .gray)
                                        Text(item).foregroundColor(.white).multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedItems.contains(item) ? Color.blue : Color.white.opacity(0.1)))
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    Spacer().frame(height: 50)
                }
            }
            
            Button(action: onNext) {
                Text("Reboot my marriage").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 9: Drift Carousel
struct DriftCarouselView: View {
    var onNext: () -> Void
    @State private var index = 0
    
    let slides: [(String, String, Color, String)] = [
        ("Complacency is a killer", "When you stop 'dating' your wife, the relationship enters **The Drift**. This passive state replaces **passion** with **routine**, slowly eroding the strength of your unit.", .orange, "gear"),
        ("Resentment builds walls", "Unaddressed friction doesn't just disappear; it **hardens** into resentment. This creates an **invisible wall** that blocks access, trust, and communication.", .orange, "brick.fill"),
        ("Stress kills the drive", "More than 60% of husbands report that **unmanaged stress** and **instability at home** are the primary killers of their **sex life** and physical affection.", .orange, "bolt.horizontal.circle"),
        ("A vacuum of leadership", "When a husband abdicates **leadership** in the home, chaos fills the void. This forces your partner into a **manager role**, killing her **attraction** to you.", .orange, "signpost.right.and.left"),
        ("Operationalize the Home", "Victory is possible. By **systematizing your efforts** and bringing **strategy** back to the marriage, you can rebuild trust, reignite desire, and **lead your family**.", .blue, "shield.fill")
    ]
    
    var body: some View {
        VStack {
            Text("HUSBAND OPS").font(.system(size: 20, weight: .bold, design: .monospaced)).padding()
            Spacer()
            
            // Carousel Content
            TabView(selection: $index) {
                ForEach(0..<slides.count, id: \.self) { i in
                    VStack {
                        Image(systemName: slides[i].3)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(slides[i].2)
                            .padding(.bottom, 30)
                        
                        Text(slides[i].0)
                            .font(.title).fontWeight(.bold)
                            .foregroundColor(slides[i].2)
                            .padding(.bottom, 10)
                        
                        Text(.init(slides[i].1)) // Markdown
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 400)
            
            Spacer()
            
            Button(action: {
                if index < slides.count - 1 {
                    withAnimation { index += 1 }
                } else {
                    onNext()
                }
            }) {
                Text("Next").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 10: Tactical Carousel
struct TacticalCarouselView: View {
    var onNext: () -> Void
    @State private var index = 0
    
    let slides: [(String, String, String)] = [
        ("Welcome to HUSBAND OPS", "With a growing brotherhood of users, HUSBAND OPS is the **tactical advantage** you need, based on **proven strategies** and successful relationship dynamics.", "eagle"),
        ("Audit your operations", "Strategic tools help you **audit** your relationship patterns, **identify** friction points, and **deploy** effective countermeasures to stop arguments before they start.", "list.clipboard"),
        ("Stay on mission", "Marriage is a marathon, not a sprint. Your daily briefing keeps you **focused** on your role as a partner and leader, helping you become **your best self**.", "flag.fill"),
        ("Avoid conflict loops", "HUSBAND OPS **learns your triggers** and recurring arguments, providing you with **intel** on how to de-escalate and communicate effectively.", "dot.radiowaves.left.and.right"),
        ("Conquer the drift", "**Know your role** to conquer the drift. Understand your **leadership style** and **situational awareness**, earn ranks, and track your **Unit Morale**.", "hand.wave.fill"),
        ("Level up your legacy", "Operationalizing your marriage has immense **generational** benefits. Build a stronger, stable, and happier home for your future.", "figure.2.and.child.holdinghands")
    ]
    
    var body: some View {
        ZStack {
            // Tactical Grid Overlay
            VStack(spacing: 40) {
                ForEach(0..<20) { _ in Divider().background(Color.white.opacity(0.05)) }
            }.ignoresSafeArea()
            
            VStack {
                Text("HUSBAND OPS").font(.system(size: 20, weight: .bold, design: .monospaced)).padding()
                Spacer()
                
                TabView(selection: $index) {
                    ForEach(0..<slides.count, id: \.self) { i in
                        VStack {
                            Image(systemName: slides[i].2)
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100).foregroundColor(.blue).padding(.bottom)
                            Text(slides[i].0).font(.title).fontWeight(.bold).padding(.bottom)
                            Text(.init(slides[i].1)).multilineTextAlignment(.center).padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                Text("Men's Health").font(.caption).fontWeight(.bold)
                                Text("Psychology Today").font(.caption).fontWeight(.bold)
                            }.foregroundColor(.gray).padding(.top, 40)
                        }.tag(i)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 500)
                
                Spacer()
                Button(action: {
                    if index < slides.count - 1 { withAnimation { index += 1 } } else { onNext() }
                }) {
                    Text("Next").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
                }.padding(.horizontal, 30).padding(.bottom, 20)
            }
        }
    }
}

// PAGE 11: Operational Benefits
struct BenefitsTestimonialsView: View {
    var onNext: () -> Void
    let testimonials: [TestimonialData] = [
        TestimonialData(name: "Jordan Peterson", handle: nil, text: "Taking responsibility for the atmosphere of your household is the highest form of leadership. It stabilizes the chaos and re-establishes order.", role: "Clean up your room, then your marriage", isVerified: true, imageName: "person.crop.circle"),
        TestimonialData(name: "Jocko Willink", handle: nil, text: "If you want a better marriage, you have to take ownership. Extreme ownership. Don't blame her mood. Blame your lack of strategy and execution.", role: "Discipline equals freedom", isVerified: true, imageName: "person.crop.circle.fill"),
        TestimonialData(name: "James", handle: nil, text: "We were living parallel lives. I felt like a ghost in my own house. The Ops plan gave me a roadmap to actually engage again.", role: "I stopped being a roommate...", isVerified: true, imageName: "h.circle.fill"),
        TestimonialData(name: "Marcus", handle: nil, text: "I didn't realize how passive I had become. Taking the lead on small things changed the dynamic. The respect came back.", role: "I got my confidence back", isVerified: true, imageName: "h.circle.fill")
    ]
    
    var body: some View {
        VStack {
            Text("Operational Benefits").font(.headline).padding()
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(testimonials) { t in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: t.imageName).resizable().frame(width: 40, height: 40).foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    HStack { Text(t.name).fontWeight(.bold); if t.isVerified { Image(systemName: "checkmark.seal.fill").foregroundColor(.blue).font(.caption) } }
                                    if let role = t.role { Text(role).font(.caption).foregroundColor(.white.opacity(0.8)) }
                                }
                            }
                            Text("\"\(t.text)\"").font(.subheadline).foregroundColor(.white.opacity(0.9))
                        }
                        .padding().background(Color.white.opacity(0.1)).cornerRadius(12)
                    }
                }.padding()
            }
            Button(action: onNext) {
                Text("Continue").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 12: Stability Graph
struct StabilityGraphView: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("Operational Benefits").font(.headline).padding()
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.5)).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2)))
                VStack {
                    HStack { Text("Household Stability"); Spacer(); Text("HUSBAND OPS").fontWeight(.bold) }.padding()
                    Spacer()
                    // Simplified Graph Representation
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(0..<10) { i in
                            Rectangle().fill(Color.red.opacity(0.5)).frame(width: 10, height: CGFloat.random(in: 20...100))
                            Spacer()
                        }
                    }.frame(height: 100).padding()
                    
                    Path { path in
                        path.move(to: CGPoint(x: 20, y: 150))
                        path.addCurve(to: CGPoint(x: 300, y: 20), control1: CGPoint(x: 100, y: 150), control2: CGPoint(x: 200, y: 20))
                    }.stroke(Color.green, lineWidth: 3).frame(height: 150)
                }
            }.frame(height: 300).padding()
            
            Text("HUSBAND OPS helps you reduce conflict 76% faster than counseling alone. 📈").padding()
            Spacer()
            Button(action: onNext) {
                Text("Continue").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 13: Mission Objectives
struct MissionObjectivesView: View {
    var onNext: () -> Void
    @State private var selection: Set<String> = []
    let objectives = ["Rebuild trust", "Reignite the bedroom", "Clear communication lines", "Reduce daily friction", "Stop the fighting", "Earn respect", "Master listening", "Lead with confidence"]
    
    var body: some View {
        VStack {
            Text("Choose your mission objectives").font(.title2).fontWeight(.bold).padding()
            Text("Select the goals you wish to track during your operation.").foregroundColor(.gray)
            ScrollView {
                VStack {
                    ForEach(objectives, id: \.self) { obj in
                        Button(action: { if selection.contains(obj) { selection.remove(obj) } else { selection.insert(obj) } }) {
                            HStack {
                                Text(obj).foregroundColor(.white)
                                Spacer()
                                Image(systemName: selection.contains(obj) ? "checkmark.circle.fill" : "circle").foregroundColor(selection.contains(obj) ? .blue : .gray)
                            }.padding().background(Color.white.opacity(0.1)).cornerRadius(12).padding(.horizontal)
                        }
                    }
                }
            }
            Button(action: onNext) {
                Text("Track these objectives").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 14: Referral
struct ReferralView: View {
    var onNext: () -> Void
    @State private var code = ""
    var body: some View {
        VStack {
            Spacer()
            Text("Do you have a referral code?").font(.title2).fontWeight(.bold)
            Text("You can skip this step").foregroundColor(.gray)
            TextField("Referral Code", text: $code).padding().background(Color.white.opacity(0.1)).cornerRadius(12).padding()
            Spacer()
            Button(action: onNext) {
                Text("Next").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
        .onAppear {
            // Simulate Popup logic roughly via View structure
        }
    }
}

// PAGE 15: Ratings
struct RatingsView: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("Give us a rating").font(.headline).padding()
            FiveStars().padding()
            Text("The app was designed for men like you.").padding(.bottom)
            
            ScrollView {
                VStack(spacing: 16) {
                    TestimonialCard(name: "David Goggins-ish", handle: "@davidg", text: "Husband Ops gave me the structure I was missing. I treat my marriage with the same discipline I treat my training now.", stars: 5)
                    TestimonialCard(name: "Professional Man", handle: "@tcoleman23", text: "I was skeptical, but the 'Daily Briefing' feature helped me anticipate my wife's needs. Game changer.", stars: 5)
                }.padding()
            }
            Button(action: onNext) {
                Text("Next").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 16: Commitment (Signature)
struct CommitmentView: View {
    var onNext: () -> Void
    @State private var lines: [Line] = []
    
    var body: some View {
        VStack {
            Text("Sign your commitment").font(.title2).fontWeight(.bold).padding()
            Text("Finally, promise yourself that you will lead your marriage with intent.").foregroundColor(.gray).padding(.bottom)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(Color.white).frame(height: 300)
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(.black), lineWidth: 2)
                    }
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                    let newPoint = value.location
                    if value.translation.width + value.translation.height == 0 {
                        lines.append(Line(points: [newPoint]))
                    } else {
                        let index = lines.count - 1
                        lines[index].points.append(newPoint)
                    }
                }))
                .frame(height: 300)
            }.padding()
            
            HStack { Button("Clear") { lines = [] }.foregroundColor(.white); Spacer() }.padding(.horizontal)
            Text("Draw on the open space above").font(.caption).foregroundColor(.gray)
            
            Spacer()
            Button(action: onNext) {
                Text("Finish").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(lines.isEmpty ? Color.gray : Color.white).foregroundColor(.black).cornerRadius(30)
            }.disabled(lines.isEmpty).padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 17: Intro
struct PlanIntroView: View {
    var onNext: () -> Void
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Hi, David").font(.largeTitle).fontWeight(.heavy)
            Text("Welcome to HUSBAND OPS, your command center").font(.title2).multilineTextAlignment(.center)
            Text("Based on your answers, we’ve built a Mission Plan just for you").foregroundColor(.gray).multilineTextAlignment(.center)
            Spacer()
            Button(action: onNext) {
                Text("Access Mission Plan").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30)
            }.padding(.horizontal, 30).padding(.bottom, 20)
        }
    }
}

// PAGE 18: Operations Order (Long Scroll)
struct OperationsOrderView: View {
    var onNext: () -> Void
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill").font(.largeTitle).foregroundColor(.green)
                    Text("David, we've generated your Operations Order.").font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                    Text("You will transform your marriage by:").foregroundColor(.gray)
                    Text("Jan 15, 2026").font(.headline).padding(8).background(Color.white).foregroundColor(.black).cornerRadius(20)
                    FiveStars()
                }.padding(.top, 40)
                
                Divider().background(Color.gray)
                
                // Vanguard Section
                VStack {
                    Text("Become the Vanguard of your Home").font(.title3).fontWeight(.bold)
                    Text("Stronger. Loving. Capable.").foregroundColor(.gray)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Pill(t: "Increased Respect", c: .blue)
                            Pill(t: "Resolve Conflict", c: .yellow)
                            Pill(t: "Better Sex Life", c: .green)
                            Pill(t: "Situational Awareness", c: .purple)
                        }.padding()
                    }
                }
                
                // Conquer Drift
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "sunset.fill").font(.largeTitle).foregroundColor(.orange)
                    Text("Conquer the drift").font(.title2).fontWeight(.bold)
                    Label("Build unshakable trust", systemImage: "lock.fill")
                    Label("Become more desirable", systemImage: "person.2.fill")
                    Label("Boost family vision", systemImage: "leaf.fill")
                    QuoteBlock(text: "I thought my wife had just checked out... This app reminded me how to hunt.")
                }.padding().background(Color.white.opacity(0.05)).cornerRadius(16).padding(.horizontal)
                
                // Build Fortress
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "shield.fill").font(.largeTitle).foregroundColor(.blue)
                    Text("Build a fortress").font(.title2).fontWeight(.bold)
                    Label("Enhance situational awareness", systemImage: "eye.fill")
                    Label("Be more stoic and reliable", systemImage: "figure.stand")
                    QuoteBlock(text: "My anger used to be my default... This taught me to pause, assess, and respond like a leader.")
                }.padding().background(Color.white.opacity(0.05)).cornerRadius(16).padding(.horizontal)
                
                // Daily Protocols Card
                VStack(alignment: .leading) {
                    HStack { Image(systemName: "hand.wave.fill"); Text("Simple, daily protocols").fontWeight(.bold) }
                    Text("You should stabilize your marriage by:").font(.caption).padding(.top, 4)
                    Text("Jan 15, 2026").fontWeight(.bold).padding(6).background(Color.black).cornerRadius(8).padding(.bottom, 8)
                    Label("Read Daily Intel Briefing", systemImage: "book.fill")
                    Label("Use Conflict De-escalation", systemImage: "mic.fill")
                }.padding().background(Color.blue).cornerRadius(16).padding(.horizontal)
                
                // Special Offer
                VStack {
                    Text("Special Deployment Offer!").fontWeight(.bold).foregroundColor(.yellow)
                    Text("Get 80% off on HUSBAND OPS Premium!").font(.title3).fontWeight(.heavy)
                    Button(action: onNext) {
                        Text("Claim Now").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
                    }
                }.padding().background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)).cornerRadius(16).padding()
                
                Spacer().frame(height: 50)
            }
        }
    }
}

// PAGE 19: One Time Offer
struct OneTimeOfferView: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            HStack { Spacer(); Image(systemName: "xmark").padding() }
            Text("ONE TIME OFFER").font(.title).fontWeight(.heavy).foregroundColor(.red)
            Text("You will never see this again").foregroundColor(.gray)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(height: 200)
                VStack {
                    Text("80%").font(.system(size: 80, weight: .bold))
                    Text("DISCOUNT").font(.headline).tracking(4)
                }
            }.padding()
            
            Text("This offer will expire in 4:59").font(.system(size: 24, weight: .bold, design: .monospaced))
            
            VStack {
                Text("LOWEST PRICE EVER").font(.caption).fontWeight(.bold).padding(4).background(Color.blue).cornerRadius(4)
                HStack {
                    VStack(alignment: .leading) { Text("Yearly").fontWeight(.bold); Text("12mo • $19.99").font(.caption).foregroundColor(.gray) }
                    Spacer()
                    Text("$1.67/mo").fontWeight(.bold)
                }.padding()
            }.background(Color.white.opacity(0.1)).cornerRadius(12).padding()
            
            Button(action: onNext) {
                Text("CLAIM YOUR OFFER NOW").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
            }.padding()
            
            Button("Cancel anytime - Rebuild your legacy") {}.font(.caption).foregroundColor(.gray)
        }
    }
}

// PAGE 20: Break Stagnation
struct BreakStagnationView: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("Break the stagnation today").font(.title).fontWeight(.bold)
            Spacer()
            HStack {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 100, height: 200).overlay(Text("Daily Brief"))
                Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 100, height: 200).overlay(Text("Intel Library"))
                Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 100, height: 200).overlay(Text("Progress Map"))
            }
            Spacer()
            Button(action: onNext) {
                Text("Continue").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30)
            }.padding()
        }
    }
}

// PAGE 21: All In One
struct AllInOneView: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("All in one place").font(.title).fontWeight(.bold)
            Text("Date planning, conflict tools, and leadership drills to maintain course.").multilineTextAlignment(.center).padding()
            Spacer()
            RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.2)).padding()
            Spacer()
            Button(action: onNext) {
                Text("Continue").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30)
            }.padding()
        }
    }
}

// PAGE 22: Subscription
struct SubscriptionView: View {
    @State private var selectedPlan = 0 // 0 = Vanguard, 1 = Standard
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("HUSBAND OPS").font(.headline).monospaced()
                Text("Join thousands who stepped up").font(.title2).fontWeight(.bold)
                HStack { Image(systemName: "star.fill"); Text("100k+ 5-Star Reviews") }.foregroundColor(.yellow)
                
                // Review Carousel (Simplified)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        TestimonialCard(name: "Alex Nguyen", handle: "@Alex_n", text: "Turned our dynamic around. Easy sub, game on.", stars: 5)
                        TestimonialCard(name: "Ryan Patel", handle: "@patelryan", text: "No more silent treatments. Subbed for life.", stars: 5)
                    }.padding()
                }
                
                Button(action: {}) {
                    Text("Start my mission today").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(30)
                }.padding(.horizontal)
                
                Text("Choose Your Loadout").font(.headline).padding(.top)
                
                // Vanguard Plan
                Button(action: { selectedPlan = 0 }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Vanguard (Annual)").fontWeight(.bold)
                            Text("$149.99").strikethrough().font(.caption) + Text(" $2.50 / mo").foregroundColor(.green)
                            Text("Billed as $29.99/yr").font(.caption2).foregroundColor(.gray)
                        }
                        Spacer()
                        if selectedPlan == 0 { Image(systemName: "checkmark.circle.fill").foregroundColor(.blue) } else { Image(systemName: "circle").foregroundColor(.gray) }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedPlan == 0 ? Color.blue : Color.clear, lineWidth: 2))
                }.padding(.horizontal)
                
                // Standard Plan
                Button(action: { selectedPlan = 1 }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Standard (Monthly)").fontWeight(.bold)
                            Text("$14.99 / mo")
                        }
                        Spacer()
                        if selectedPlan == 1 { Image(systemName: "checkmark.circle.fill").foregroundColor(.blue) } else { Image(systemName: "circle").foregroundColor(.gray) }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedPlan == 1 ? Color.blue : Color.clear, lineWidth: 2))
                }.padding(.horizontal)
                
                HStack { Image(systemName: "shield"); Text("No commitment, cancel anytime") }.font(.caption).foregroundColor(.gray)
                
                Button(action: {}) {
                    Text("Start my mission today").fontWeight(.bold).frame(maxWidth: .infinity).padding().background(Color.white).foregroundColor(.black).cornerRadius(30)
                }.padding()
                
                Spacer().frame(height: 50)
            }
        }
    }
}

// MARK: - Reusable Components

struct StarryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.05, blue: 0.1), Color.black], startPoint: .top, endPoint: .bottom)
            GeometryReader { proxy in
                ForEach(0..<80) { _ in
                    Circle().fill(Color.white.opacity(Double.random(in: 0.1...0.6)))
                        .frame(width: Double.random(in: 1...2), height: Double.random(in: 1...2))
                        .position(x: CGFloat.random(in: 0...proxy.size.width), y: CGFloat.random(in: 0...proxy.size.height))
                }
            }
        }
    }
}

struct FiveStars: View {
    var body: some View {
        HStack(spacing: 4) { ForEach(0..<5) { _ in Image(systemName: "star.fill").foregroundColor(.yellow) } }
    }
}

struct TestimonialCard: View {
    var name: String; var handle: String; var text: String; var stars: Int
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle().fill(Color.gray).frame(width: 30, height: 30)
                VStack(alignment: .leading) { Text(name).fontWeight(.bold).font(.caption); Text(handle).font(.caption2).foregroundColor(.gray) }
                Spacer()
                HStack(spacing: 1) { ForEach(0..<stars) { _ in Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption2) } }
            }
            Text(text).font(.caption).padding(.top, 4).lineLimit(4)
        }.padding().background(Color.white.opacity(0.1)).cornerRadius(12).frame(width: 250)
    }
}

struct Pill: View { var t: String; var c: Color; var body: some View { Text(t).font(.caption).padding(8).background(c.opacity(0.2)).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(c, lineWidth: 1)) } }

struct QuoteBlock: View { var text: String; var body: some View { VStack(alignment: .leading) { Text(text).italic().font(.caption).padding(.vertical, 4); Text("- Anonymous").font(.caption2).foregroundColor(.gray) } } }

// Helper
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity; var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path { let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)); return Path(path.cgPath) }
}
extension View { func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View { clipShape(RoundedCorner(radius: radius, corners: corners)) } }

#Preview {
    NewOnboardingView()
}
