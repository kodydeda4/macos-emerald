//
//  SidebarView.swift
//  Emerald
//
//  Created by Kody Deda on 2/11/21.
//

import SwiftUI
import ComposableArchitecture

struct SidebarView: View {
    let store: Store<Root.State, Root.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section(header: Text("Debug")) {
                    NavigationLink(destination: YabaiSettingsView(
                        store: store
                            .scope(state: \.dataManager, action: Root.Action.dataManager)
                            .scope(state: \.yabaiSettings, action: DataManager.Action.yabaiSettings)
                    )) {
                        Label("Debug Yabai", systemImage: "terminal")
                    }
                    NavigationLink(destination: SKHDSettingsView(
                        store: store
                            .scope(state: \.dataManager, action: Root.Action.dataManager)
                            .scope(state: \.skhdSettings, action: DataManager.Action.skhdSettings)
                    )) {
                        Label("Debug SKHD", systemImage: "keyboard")
                    }
                    NavigationLink(destination: AnimationSettingsView(
                        store: store
                            .scope(state: \.dataManager, action: Root.Action.dataManager)
                            .scope(state: \.animationSettings, action: DataManager.Action.animationSettings)
                    )) {
                        Label("Debug Animations", systemImage: "arrowtriangle.forward")
                    }
                    NavigationLink(destination: SystemIntegrityProtectionView()) {
                        Label("System Integrity Protection", systemImage: "lock.circle")
                    }
                }
                Divider()
                NavigationLink(destination: AboutView(
                    store: store
                        .scope(state: \.dataManager, action: Root.Action.dataManager)
                )) {
                    Label("About", systemImage: "gear")
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

// MARK:- SwiftUI Previews

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(store: Root.defaultStore)
    }
}
