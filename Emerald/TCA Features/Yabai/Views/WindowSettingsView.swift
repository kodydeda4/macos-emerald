//
//  WindowSettingsView.swift
//  Emerald
//
//  Created by Kody Deda on 3/5/21.
//

import SwiftUI
import ComposableArchitecture
import KeyboardShortcuts

struct WindowSettingsView: View {
  let store: Store<Yabai.State, Yabai.Action>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        VStack(alignment: .leading) {
          Text("Window")
            .font(.largeTitle)
            .bold()
          Divider()
          HStack {
            SectionView("Active") {
              WindowSettings(
                text: "Active",
                color: viewStore.binding(keyPath: \.activeWindowBorderColor.color, send: Yabai.Action.keyPath),
                opacity: viewStore.binding(keyPath: \.activeWindowOpacity, send: Yabai.Action.keyPath),
                width: CGFloat(viewStore.windowBorderWidth)
              )
            }
            SectionView("Normal") {
              WindowSettings(
                text: "Normal",
                color: viewStore.binding(keyPath: \.normalWindowBorderColor.color, send: Yabai.Action.keyPath),
                opacity: viewStore.binding(keyPath: \.normalWindowOpacity, send: Yabai.Action.keyPath),
                width: CGFloat(viewStore.windowBorderWidth)
              )
            }
          }
        }
        SectionView("Misc") {
          VStack(alignment: .leading) {
            HStack {
              Text("Border Width")
              Slider(value: viewStore.binding(get: \.windowBorderWidth, send: Yabai.Action.updateWindowBorderWidth), in: 0...30)
            }
            Divider()
            HStack {
              Toggle("", isOn: viewStore.binding(keyPath: \.disableShadows, send: Yabai.Action.keyPath))
                .labelsHidden()
              
              Text("Disable Shadows")
                .bold().font(.title3)
            }
            HStack {
              Picker("", selection: viewStore.binding(keyPath: \.windowShadow, send: Yabai.Action.keyPath)) {
                ForEach(Yabai.State.WindowShadow.allCases) {
                  Text($0.labelDescription.lowercased())
                }
              }
              .labelsHidden()
              .pickerStyle(SegmentedPickerStyle())
              .frame(width: 150)
              .disabled(!viewStore.disableShadows)
            }
            .disabled(!viewStore.disableShadows || viewStore.sipEnabled)
            .opacity( !viewStore.disableShadows || viewStore.sipEnabled ? 0.5 : 1.0)
            
            Text(viewStore.windowShadow.caseDescription)
              .foregroundColor(Color(.gray))
              .disabled(!viewStore.disableShadows || viewStore.sipEnabled)
              .opacity( !viewStore.disableShadows || viewStore.sipEnabled ? 0.5 : 1.0)
            
            Divider()
            HStack {
              Group {
                Toggle("", isOn: viewStore.binding(keyPath: \.windowTopmost, send: Yabai.Action.keyPath))
                  .labelsHidden()
                
                Text("Float-On-Top")
                  .bold().font(.title3)
              }
              Spacer()
            }
            Text("Force floating windows to stay ontop of tiled/stacked windows")
              .foregroundColor(Color(.gray))
            
          }
          
        }
        PlacementSettingsView(store: store)
        
      }
      .frame(maxWidth: 900)
      .padding()
    }
  }
}



private struct WindowSettings: View {
  var text: String
  @Binding var color: Color
  @Binding var opacity: Double
  var width: CGFloat
  
  let colors: [Color] = [.blue, .purple, .pink, .red, .orange, .yellow, .green, .gray]
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 6)
        .opacity(opacity)
        .foregroundColor(
          Color(.controlBackgroundColor)
        )
        .overlay(
          Text(text)
            .foregroundColor(.gray)
            .opacity(opacity)
        )
        .shadow(radius: 6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.gray, lineWidth: 0.75)
            .opacity(opacity)
        )
        .overlay(
          Rectangle()
            .stroke(color, lineWidth: width/2)
        )
        .padding()
        
        .frame(height: 200)
      
      HStack {
        Text("Border")
        ColorPicker("", selection: $color)
          .labelsHidden()
        
        ForEach(colors, id: \.self) { color in
          Button(action: {}) {
            Circle()
              .overlay(
                Circle()
                  .foregroundColor(.white)
                  .frame(width: 6)
                  .opacity(opacity)
              )
          }
          .buttonStyle(PlainButtonStyle())
          .frame(width: 16)
          .foregroundColor(color)
        }
      }
      HStack {
        Text("Opacity")
        Slider(value: $opacity, in: 0.1...1.0)
      }
    }
  }
}


struct PlacementSettingsView: View {
  let store: Store<Yabai.State, Yabai.Action>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        SectionView("Placement") {
          // Placement
          VStack(alignment: .leading) {
            Text("Placement")
              .bold().font(.title3)
            
            Picker("", selection: viewStore.binding(keyPath: \.windowPlacement, send: Yabai.Action.keyPath)) {
              ForEach(Yabai.State.WindowPlacement.allCases) {
                Text($0.labelDescription.lowercased())
              }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            
            Text(viewStore.windowPlacement.caseDescription)
              .foregroundColor(Color(.gray))
          }
          // Split Ratio
          VStack(alignment: .leading) {
            Divider()
            
            Text("Split Ratio")
              .bold().font(.title3)
            
            Picker("", selection: viewStore.binding(keyPath: \.windowBalance, send: Yabai.Action.keyPath)) {
              ForEach(Yabai.State.WindowBalance.allCases) {
                Text($0.labelDescription.lowercased())
              }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            
            Slider(value: viewStore.binding(keyPath: \.splitRatio, send: Yabai.Action.keyPath))
              .disabled(viewStore.windowBalance != .custom)
              .opacity(viewStore.windowBalance != .custom ? 0.5 : 1.0)
            
            Text(viewStore.windowBalance.caseDescription)
              .foregroundColor(Color(.gray))
          }
        }
      }
    }
  }
}

// MARK:- SwiftUI_Previews
struct WindowSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    WindowSettingsView(store: Yabai.defaultStore)
  }
}






