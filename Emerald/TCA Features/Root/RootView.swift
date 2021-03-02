//
//  RootView.swift
//  Emerald
//
//  Created by Kody Deda on 2/12/21.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                SidebarView(store: store)
                Text("Welcome Page")
                    .font(.largeTitle)
                    .foregroundColor(Color(NSColor.placeholderTextColor))
            }
            
            .onAppear {
                viewStore.send(.dataManager(.loadYabaiSettings))
                viewStore.send(.dataManager(.loadSKHDSettings))
                viewStore.send(.dataManager(.loadAnimationSettings))
                
            }
            .sheet(isPresented:
                    viewStore.binding(
                        get: \.onboarding.isOnboaring,
                        send: Root.Action.onboarding(.toggleIsOnboaring))
            ) {
                OnboardingView(
                    store: store.scope(
                        state: \.onboarding,
                        action: Root.Action.onboarding
                    )
                )
            }
            .toolbar {
                ToolbarItem {
                    Button("Toggle OnboardingView") {
                        viewStore.send(.onboarding(.toggleIsOnboaring))
                    }
                }
                ToolbarItem {
                    Button("Apply Animation Changes") {
                        viewStore.send(.dataManager(.exportAnimationConfig))
                        let _ = AppleScript.applyAnimationSettings.execute()
                    }
                }
//                ToolbarItem {
//                    Button("brew services start Yabai -v") {
//                        viewStore.send(.dataManager(.exportYabaiConfig))
//                        viewStore.send(.dataManager(.exportSKHDConfig))
//
//                        let _ = AppleScript.restartYabai.execute()
//                    }
//                }
                ToolbarItem {
                    Button("Update/Restart Yabai & SKHD") {
                        viewStore.send(.dataManager(.exportYabaiConfig))
                        viewStore.send(.dataManager(.exportSKHDConfig))
                        
                        let _ = AppleScript.restartYabai.execute()
                    }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}