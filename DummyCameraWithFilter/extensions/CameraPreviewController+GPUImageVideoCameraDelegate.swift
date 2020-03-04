//
//  CameraPreviewController+GPUImage.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import GPUImage

extension CameraPreviewController: GPUImageVideoCameraDelegate {
    
    open func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        
        fetchMetaInfo(sampleBuffer)
        delegate?.cameraPreview(self, willOutput: sampleBuffer, with: captureSequence)
        captureSequence += 1
    }
}
