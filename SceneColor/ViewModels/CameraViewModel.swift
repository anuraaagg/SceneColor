import Foundation
import Observation

/// View model for camera functionality
@Observable
@MainActor
class CameraViewModel {
    var isRunning = false
    var currentColors: [ColorInfo] = []
    
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
