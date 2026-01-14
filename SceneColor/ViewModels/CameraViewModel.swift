import Combine
import CoreMedia
import Foundation
import Observation
import SwiftUI
import UIKit

/// View model for camera functionality
@MainActor
class CameraViewModel: ObservableObject {
  enum AppMode {
    case live, freeze, dragging
  }

  @Published var mode: AppMode = .live
  @Published var isRunning = false
  @Published var currentColors: [ColorInfo] = []
  @Published var extractedColors: [ExtractedColor] = []
  @Published var cameraService = CameraService()
  @Published var isSimulator: Bool = false

  @Published var lastCapturedImage: UIImage?
  @Published var activeFreeze: Freeze?

  private var cancellables = Set<AnyCancellable>()
  private var currentBuffer: CMSampleBuffer?

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

    cameraService.framePublisher
      .throttle(for: .milliseconds(100), scheduler: RunLoop.main, latest: true)
      .sink { [weak self] sampleBuffer in
        guard let self = self, self.mode == .live else { return }
        self.currentBuffer = sampleBuffer
        self.processFrame(sampleBuffer)
      }
      .store(in: &cancellables)
  }

  private func processFrame(_ buffer: CMSampleBuffer) {
    let results = ColorExtractor.shared.extractPalette(from: buffer)
    self.extractedColors = results
    self.currentColors = results.map { ColorInfo(color: $0.color) }
  }

  func freeze() {
    guard mode == .live else { return }

    if isSimulator {
      lastCapturedImage = UIImage(systemName: "photo")
    } else if let buffer = currentBuffer {
      lastCapturedImage = imageFromBuffer(buffer)
    }

    activeFreeze = Freeze(
      image: lastCapturedImage ?? UIImage(),
      palette: currentColors
    )

    withAnimation {
      mode = .freeze
    }
  }

  func unfreeze() {
    activeFreeze = nil
    lastCapturedImage = nil
    withAnimation {
      mode = .live
    }
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

  private func imageFromBuffer(_ buffer: CMSampleBuffer) -> UIImage? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let context = CIContext()
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }

  private func simulateColors() {
    let mockResults: [ExtractedColor] = [
      ExtractedColor(color: .systemRed, location: CGPoint(x: 0.2, y: 0.2)),
      ExtractedColor(color: .systemGreen, location: CGPoint(x: 0.8, y: 0.2)),
      ExtractedColor(color: .systemBlue, location: CGPoint(x: 0.5, y: 0.5)),
      ExtractedColor(color: .systemPink, location: CGPoint(x: 0.2, y: 0.8)),
      ExtractedColor(color: .systemTeal, location: CGPoint(x: 0.8, y: 0.8)),
    ]

    self.extractedColors = mockResults
    self.currentColors = mockResults.map { ColorInfo(color: $0.color) }
  }
}
