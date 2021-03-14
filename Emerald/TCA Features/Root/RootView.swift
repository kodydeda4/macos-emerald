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
                SpaceSettingsView(store: store.scope(state: \.yabai, action: Root.Action.yabai))
                
                TabView {
                    DebugConfigFileView(text: viewStore.yabai.asConfig)
                        .tabItem { Label("Yabai", systemImage: "square.and.pencil") }
                    
                    DebugConfigFileView(text: viewStore.skhd.asConfig)
                        .tabItem { Label("SKHD", systemImage: "square.and.pencil") }
                    
                    DebugConfigFileView(text: viewStore.macOSAnimations.asConfig)
                        .tabItem { Label("Animations", systemImage: "square.and.pencil") }
                }
                .padding()
            }
            .onAppear {
                viewStore.send(.load(.yabai))
                viewStore.send(.load(.skhd))
                viewStore.send(.load(.macOSAnimations))
            }
            .sheet(
                isPresented:
                    viewStore.binding(
                        get: \.onboarding.isOnboaring,
                        send: Root.Action.onboarding(.toggleIsOnboaring))
            ) {
                OnboardingView(
                    store: store.scope(state: \.onboarding, action: Root.Action.onboarding)
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }
                //                ToolbarItem {
                //                    Button("Toggle OnboardingView") {
                //                        viewStore.send(.onboarding(.toggleIsOnboaring))
                //                    }
                //                }
                //                ToolbarItem {
                //                    Button("Apply Animation Changes") {
                //                        viewStore.send(.export(.macOSAnimations))
                //                        let _ = AppleScript.applyAnimationSettings.execute()
                //                    }
                //                }
                ToolbarItem {
                    Toggle("Toggle SIP", isOn: viewStore.binding(get: \.yabai.sipEnabled, send: Root.Action.yabai(.toggleSIP)))
                    //Text("SIP Enabled: \(viewStore.yabai.sipEnabled.description)")
                }
                
                ToolbarItem {
                    Button(action: {
                        viewStore.send(.reset(.yabai))
                        viewStore.send(.reset(.skhd))
                        viewStore.send(.reset(.macOSAnimations))
                    }) {
                        Text("Reset (cmd+shift+r)")
                    }
                    .keyboardShortcut("r", modifiers: [.command, .shift])
                }
                ToolbarItem {
                    Button(action: {
                        viewStore.send(.export(.yabai))
                        viewStore.send(.export(.skhd))
                        viewStore.send(.appleScript(.restartYabai))
                    }) {
                        Text("Apply Changes (cmd+shift+a)")
                    }
                    .keyboardShortcut("a", modifiers: [.command, .shift])
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
