//
//  CameraPreviewController.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

extension CameraPreviewController: UIGestureRecognizerDelegate {
    
    func setupPreview() {
        
        // layout
        layoutSource?.cameraPreviewNeedsLayout(self, preview: preview)
        if let _ = preview.superview {
            self.customConstraints = true
        } else {
            view.addSubview(preview)
        }
        
        // config fill mode
        preview.fillMode = fillMode
        
        // transform preview by camera position
        switch cameraPosition {
        case .back:
            preview.transform = CGAffineTransform.identity
        default:
            preview.transform = preview.transform.scaledBy(x: -1, y: 1)
        }
        
    }
    
    func setupCamera() {
        clearCamera()
        camera = GPUImageStillCamera(sessionPreset: capturePreset, cameraPosition: cameraPosition)
        switch cameraPosition {
        case .back:
            camera.outputImageOrientation = .portrait
        default:
            camera.outputImageOrientation = .portrait
        }
        camera.delegate = self
        camera.addTarget(defaultFilter)
        defaultFilter.addTarget(preview)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    open func startCapture() {
        if !camera.captureSession.isRunning {
            camera.startCapture()
        }
    }
    
    open func stopCapture() {
        if camera.captureSession.isRunning {
            camera.stopCapture()
        }
    }
    
    open func clearCamera() {
        if let camera = self.camera {
            if camera.captureSession.isRunning {
                camera.stopCapture()
            }
            camera.removeAllTargets()
            camera.removeInputsAndOutputs()
            camera.removeAudioInputsAndOutputs()
            camera.removeFramebuffer()
        }
        captureSequence = 0
    }
    
    open func clearNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}
