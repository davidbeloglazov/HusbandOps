//
//  ContentView.swift
//  Mission Husband
//
//  Created by David Beloglazov on 10/29/25.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

import SwiftUI

@main
struct ContentView: App {
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

  var body: some Scene {
    WindowGroup {
      if hasSeenOnboarding {
        MainTabView()
      } else {
        NewOnboardingView()
      }
    }
  }
}


//#Preview {
//    ContentView()
//}
