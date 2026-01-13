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
  @Published var cameraService = CameraService()
  @Published var isSimulator: Bool = false

  private var cancellables = Set<AnyCancellable>()

  init() {
    #if targetEnvironment(simulator)
      isSimulator = true
    #endif

    setupBindings()
  }

  private func setupBindings() {
    cameraService.$isRunning
      .receive(on: RunLoop.main)
      .assign(to: &$isRunning)
  }

  func startCamera() {
    if isSimulator {
      isRunning = true
      simulateColors()
    } else {
      cameraService.checkPermissions()
    }
  }

  func stopCamera() {
    if isSimulator {
      isRunning = false
    } else {
      cameraService.stop()
    }
  }

  func switchCamera() {
    if !isSimulator {
      cameraService.switchCamera()
    }
  }

  func captureFrame() -> UIImage? {
    // TODO: Capture current camera frame
    return nil
  }

  private func simulateColors() {
    currentColors = [
      ColorInfo(hex: "#FF5733", name: "Vibrant Orange", r: 255, g: 87, b: 51),
      ColorInfo(hex: "#33FF57", name: "Neon Green", r: 51, g: 255, b: 87),
      ColorInfo(hex: "#3357FF", name: "Electric Blue", r: 51, g: 87, b: 255),
      ColorInfo(hex: "#F333FF", name: "Hot Pink", r: 243, g: 51, b: 255),
    ]
  }
}
