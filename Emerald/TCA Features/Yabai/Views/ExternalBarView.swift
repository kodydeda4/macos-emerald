//
//  ExternalBarSettingsView.swift
//  Emerald
//
//  Created by Kody Deda on 3/5/21.
//

import SwiftUI
import ComposableArchitecture

struct ExternalBarSettingsView: View {
    let store: Store<Yabai.State, Yabai.Action>
    let k = Yabai.Action.keyPath
    
    var body: some View {
        WithViewStore(store) { vs in
            HStack {
                settings
                    .padding()
                    .navigationSubtitle("External Bar")
                
                Rectangle()
                    .foregroundColor(.black)
            }
        }
    }
}

extension ExternalBarSettingsView {
    var settings: some View {
        WithViewStore(store) { vs in
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Toggle("", isOn: vs.binding(keyPath: \.externalBarEnabled, send: k)).labelsHidden()
                        Text("External Bar").bold()
                    }
                    
                    Picker("", selection: vs.binding(keyPath: \.externalBar, send: k)) {
                        ForEach(Yabai.State.ExternalBar.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100)
                    .disabled(!vs.externalBarEnabled)
                    
                    Text("Repellendus est dicta facere aut. Et quisquam dicta voluptatum laboriosam amet reiciendis earum. Quaerat autem tenetur dolores optio consequatur.")
                        .foregroundColor(Color(.gray))
                    
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Padding").bold()
                    HStack {
                        StepperView(
                            text: "Top",
                            value: vs.binding(keyPath: \.externalBarPaddingTop, send: k),
                            isEnabled: vs.externalBarEnabled
                        )
                        StepperView(
                            text: "Bottom",
                            value: vs.binding(keyPath: \.externalBarPaddingBottom, send: k),
                            isEnabled: vs.externalBarEnabled
                        )
                    }
                }
                
                Spacer()
            }
        }
    }
}


// MARK:- SwiftUI_Previews
struct ExternalBarSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalBarSettingsView(store: Yabai.defaultStore)
    }
}
