import Foundation

func environment(_ name: String) -> String? {
  return ProcessInfo.processInfo.environment[name]
}
