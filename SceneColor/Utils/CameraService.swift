import AVFoundation
import Combine
import UIKit

/// Manages the AVFoundation camera session
class CameraService: NSObject, ObservableObject {
  @Published var session = AVCaptureSession()
  @Published var isRunning = false
  @Published var cameraPosition: AVCaptureDevice.Position = .back
  @Published var alert = false
  @Published var output = AVCaptureVideoDataOutput()

  // To handle frames for color extraction
  var framePublisher = PassthroughSubject<CMSampleBuffer, Never>()

  private var videoDeviceInput: AVCaptureDeviceInput?

  func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setupSession()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
        if status {
          self?.setupSession()
        }
      }
    case .denied, .restricted:
      alert = true
    @unknown default:
      break
    }
  }

  func setupSession() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      self.session.beginConfiguration()

      // Re-setup input
      self.setupInput()

      // Setup Output
      if self.session.canAddOutput(self.output) {
        self.output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        self.session.addOutput(self.output)
      }

      self.session.commitConfiguration()

      self.session.startRunning()
      DispatchQueue.main.async {
        self.isRunning = self.session.isRunning
      }
    }
  }

  private func setupInput() {
    // Remove existing input if any
    if let currentInput = videoDeviceInput {
      session.removeInput(currentInput)
    }

    do {
      guard
        let device = AVCaptureDevice.default(
          .builtInWideAngleCamera, for: .video, position: cameraPosition)
      else {
        return
      }

      let input = try AVCaptureDeviceInput(device: device)

      if session.canAddInput(input) {
        session.addInput(input)
        self.videoDeviceInput = input
      }
    } catch {
      print("Error setting up camera input: \(error.localizedDescription)")
    }
  }

  func switchCamera() {
    cameraPosition = (cameraPosition == .back) ? .front : .back

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      self.session.beginConfiguration()
      self.setupInput()
      self.session.commitConfiguration()
    }
  }

  func start() {
    if !session.isRunning {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.session.startRunning()
        DispatchQueue.main.async {
          self?.isRunning = true
        }
      }
    }
  }

  func stop() {
    if session.isRunning {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.session.stopRunning()
        DispatchQueue.main.async {
          self?.isRunning = false
        }
      }
    }
  }
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    framePublisher.send(sampleBuffer)
  }
}
