//
//  SidebarView.swift
//  YabaiUI
//
//  Created by Kody Deda on 2/11/21.
//

import ComposableArchitecture
import SwiftUI

struct SettingsSectionView: View {
    let store: Store<Settings.State, Settings.Action>
    
    var body: some View {
        Section(header: Text("Settings")) {
            
            NavigationLink(destination: ConfigView(store: store.scope(state: \.config, action: Settings.Action.config))) {
                Label("Config", systemImage: "rectangle.3.offgrid")
            }
            NavigationLink(destination: TemporaryTextView(text: "Display")) {
                Label("Display", systemImage: "display")
            }
            NavigationLink(destination: SpaceView(store: store.scope(state: \.space, action: Settings.Action.space))) {
                Label("Space", systemImage: "rectangle.3.offgrid")
            }
            NavigationLink(destination: TemporaryTextView(text: "Window")) {
                Label("Window", systemImage: "macwindow")
            }
            NavigationLink(destination: TemporaryTextView(text: "Query")) {
                Label("Query", systemImage: "terminal")
            }
            NavigationLink(destination: TemporaryTextView(text: "Rule")) {
                Label("Rule", systemImage: "keyboard")
            }
            NavigationLink(destination: TemporaryTextView(text: "Signal")) {
                Label("Signal", systemImage: "antenna.radiowaves.left.and.right")
            }
            
            
        }
        
    }
}
struct SidebarView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                SettingsSectionView(store: store.scope(state: \.settings, action: Root.Action.settings))
                Divider()
                NavigationLink(destination: AboutView(store: store)) {
                    Label("About", systemImage: "gear")
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}


func toggleSidebar() {
    NSApp.keyWindow?
        .firstResponder?
        .tryToPerform(
            #selector(NSSplitViewController.toggleSidebar),
            with: nil
        )
}

struct TemporaryTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundColor(Color(NSColor.placeholderTextColor))
    }
}

// MARK:- SwiftUI Previews

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(store: Root.defaultStore)
    }
}