//
//  CameraPreviewController+Extension.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import GPUImage

extension CameraPreviewController {
    
    @objc func applicationWillResignActive(notification: Notification) {
        if isRecordingVideo {
            finishRecordingVideo()
            clearRecordingVideo()
        }
    }
    
    func fetchMetaInfo(_ sampleBuffer: CMSampleBuffer) {
        if captureSequence == 0 {
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            resolution = CGSize(width: width, height: height)
        }
    }
    
    open func findOrientation(completion: @escaping ((UIDeviceOrientation) -> ())) {
        
        guard motionManager.isAccelerometerAvailable else { return }
        
        let queue = OperationQueue()
        var isFound: Bool = false
        motionManager.startAccelerometerUpdates(to: queue) { (data, error) in
            
            guard let data = data, !isFound else { return }
            
            let angle = (atan2(data.acceleration.y,data.acceleration.x)) * 180 / Double.pi;
            
            self.motionManager.stopAccelerometerUpdates()
            isFound = true
            
            if fabs(angle) <= 45 {
                completion(.landscapeLeft)
            } else if fabs(angle) > 45 && fabs(angle) < 135 {
                if angle > 0 {
                    completion(.portraitUpsideDown)
                } else {
                    completion(.portrait)
                }
            } else {
                completion(.landscapeRight)
            }
        }
    }
}
