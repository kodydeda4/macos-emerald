//
//  SpaceSettings.swift
//  Emerald
//
//  Created by Kody Deda on 2/10/21.
//

import SwiftUI
import ComposableArchitecture
import DynamicColor
import SwiftShell
import KeyboardShortcuts

struct Yabai {
  struct State: Equatable, Codable {
    var stateURL                 = URL(fileURLWithPath: "YabaiState.json", relativeTo: .HomeDirectory)
    var configURL                = URL(fileURLWithPath: ".yabairc", relativeTo: .HomeDirectory)
    var version                  = run("/usr/local/bin/yabai", "-v").stdout
    var sipEnabled               : Bool              = false
    var debugOutput              : Bool              = false
    var externalBar              : ExternalBar       = .all
    var externalBarEnabled       : Bool              = false
    var externalBarPaddingTop    : Int               = 0
    var externalBarPaddingBottom : Int               = 0
    var mouseFollowsFocus        : Bool              = false
    var focusFollowsMouse        : FocusFollowsMouse = .off
    var windowPlacement          : WindowPlacement   = .second_child
    var windowTopmost            : Bool              = false
    var disableShadows           : Bool              = false
    var windowShadow             : WindowShadow      = .off
    var windowOpacityDuration    : Double            = 1
    var activeWindowOpacity      : Double            = 1
    var normalWindowOpacity      : Double            = 1
    var windowBalance            : WindowBalance     = .normal
    var splitRatio               : Float             = 50
    var autoBalance              : Bool              = false
    var windowBorderWidth        : Float             = 0
    var activeWindowBorderColor  : CodableColor      = .init(color: .accentColor)
    var normalWindowBorderColor  : CodableColor      = .init(color: .gray)
    var mouseModifier            : MouseModifier     = .fn
    var mouseAction1             : MouseAction       = .move
    var mouseAction2             : MouseAction       = .resize
    var mouseDropAction          : MouseDropAction   = .swap
    var layout                   : Layout            = .float
    var padding                  : Int               = 30
    var windowGap                : Int               = 30
    
    enum ExternalBar: String, Codable, CaseIterable, Identifiable {
      var id: ExternalBar { self }
      case off
      case all
      case main
      
      var caseDescription: String {
        switch self {
        case .off  : return "Disabled."
        case .all  : return "Use an external statusbar on all screens"
        case .main : return "Only use an external statusbar on the main screen"
        }
      }
    }
    enum WindowShadow: String, Codable, CaseIterable, Identifiable {
      var id: WindowShadow { self }
      case off
      case float
      
      var labelDescription: String {
        switch self {
        case .off   : return "All"
        case .float : return "Non-Floating"
        }
      }
      var caseDescription: String {
        switch self {
        case .off   : return "Disable shadows for all windows"
        case .float : return "Disable shadows for non-floating windows"
        }
      }
    }
    enum FocusFollowsMouse: String, Codable, CaseIterable, Identifiable {
      var id: FocusFollowsMouse { self }
      case off
      case autofocus
      case autoraise
      
      var labelDescription: String {
        switch self {
        case .off : return "Default"
        case .autofocus : return "AutoFocus"
        case .autoraise : return "AutoRaise"
        }
      }
      
      var caseDescription: String {
        switch self {
        case .off : return "Default"
        case .autofocus : return "Focus windows on hover"
        case .autoraise : return "Focus & raise windows on hover"
        }
      }
    }
    enum WindowPlacement: String, Codable, CaseIterable, Identifiable {
      var id: WindowPlacement { self }
      case first_child
      case second_child
      
      var labelDescription: String {
        switch self {
        case .first_child  : return "First Child"
        case .second_child : return "Second Child"
        }
      }
      var caseDescription: String {
        switch self {
        case .first_child  : return "Split horizontally on new window split"
        case .second_child : return "Split vertically on new window split"
        }
      }
    }
    enum MouseModifier: String, Codable, CaseIterable, Identifiable {
      var id: MouseModifier { self }
      case fn
      case shift
      case ctrl
      case alt
      case cmd
      
      var labelDescription: String {
        switch self {
        case .fn    : return "Fn"
        case .shift : return "⇧ Shift"
        case .ctrl  : return "⌃ Control"
        case .alt   : return "⌥ Option"
        case .cmd   : return "⌘ Command"
        }
      }
    }
    enum MouseAction: String, Codable, CaseIterable, Identifiable {
      var id: MouseAction { self }
      case move
      case resize
      
      var caseDescription: String {
        switch self {
        case .move   : return "Move windows with mouse button & modifier"
        case .resize : return "Resize windows with mouse button & modifier"
        }
      }
    }
    enum MouseDropAction: String, Codable, CaseIterable, Identifiable {
      var id: MouseDropAction { self }
      case swap
      case stack
      
      var caseDescription: String {
        switch self {
        case .swap  : return "Swap windows when dropping ontop of one another"
        case .stack : return "Stack windows when dropping ontop of one another"
        }
      }
    }
    enum Layout: String, Codable, CaseIterable, Identifiable {
      var id: Layout { self }
      case float
      case bsp
      case stack
      
      var labelDescription: String {
        switch self {
        case .float : return "Normal"
        case .bsp   : return "Tile"
        case .stack : return "Stack"
        }
      }
      var caseDescription: String {
        switch self {
        case .float : return "Default macOS window behavior"
        case .bsp   : return "Automatically resize & organize"
        case .stack : return "Full-screen focus"
        }
      }
    }
    enum WindowBalance: String, Codable, CaseIterable, Identifiable {
      var id: WindowBalance { self }
      case normal
      case auto
      case custom
      
      var labelDescription: String {
        switch self {
        case .normal : return "Normal"
        case .auto   : return "Auto"
        case .custom : return "Custom"
        }
      }
      var caseDescription: String {
        switch self {
        case .normal : return "New window occupies 50% of total space"
        case .auto   : return "All windows will occuopy the same amount of space"
        case .custom : return "New windows will occupy a specific percentage of the total space"
        }
      }
    }
  }
  
  enum Action: Equatable {
    case keyPath(BindingAction<Yabai.State>)
    case toggleSIP
    case updateActiveWindowBorderColor(Color)
    case updateNormalWindowBorderColor(Color)
    case updateWindowBorderWidth(Float)
    case updateLayout(Yabai.State.Layout)
  }
}

extension Yabai {
  static let reducer = Reducer<State, Action, Void> {
    state, action, _ in
    switch action {
    case .keyPath:
      return .none
      
    case .toggleSIP:
      state.sipEnabled.toggle()
      return .none
      
    case let .updateActiveWindowBorderColor(color):
      state.activeWindowBorderColor.color = color
      return .none
      
    case let .updateNormalWindowBorderColor(color):
      state.normalWindowBorderColor.color = color
      return .none
      
    case let .updateWindowBorderWidth(num):
      state.windowBorderWidth = num
      return .none
      
    case let .updateLayout(layout):
      state.layout = layout
      return .none
      
    }
  }
  .binding(action: /Action.keyPath)
}

extension Yabai {
  static let defaultStore = Store(
    initialState: .init(),
    reducer: reducer,
    environment: ()
  )
}

