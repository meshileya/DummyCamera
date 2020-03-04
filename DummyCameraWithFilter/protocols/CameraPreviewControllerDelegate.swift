//
//  CameraPreviewControllerDelegate.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import GPUImage
// MARK: - Declaration for CameraPreviewControllerDelegate
protocol CameraPreviewControllerDelegate: class {
    func cameraPreview(_ controller: CameraPreviewController, didSaveVideoAt url: URL)
    func cameraPreview(_ controller: CameraPreviewController, didFailSaveVideoWithError error: Error)
    func cameraPreview(_ controller: CameraPreviewController, willOutput sampleBuffer: CMSampleBuffer, with sequence: UInt64)
}
