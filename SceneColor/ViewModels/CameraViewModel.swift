import Combine
import Foundation
import Observation
import SwiftUI
import UIKit

/// View model for camera functionality
@MainActor
class CameraViewModel: ObservableObject {
  @Published var isRunning = false
  @Published var currentColors: [ColorInfo] = []

  func startCamera() {
    // TODO: Implement camera session
    isRunning = true
  }

  func stopCamera() {
    // TODO: Stop camera session
    isRunning = false
  }

  func captureFrame() -> UIImage? {
    // TODO: Capture current camera frame
    return nil
  }
}
