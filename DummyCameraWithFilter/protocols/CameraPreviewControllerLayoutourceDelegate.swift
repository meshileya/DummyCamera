//
//  CameraPreviewControllerLayoutourceDelegate.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 04/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import GPUImage
// MARK: - Declaration for CameraPreviewControllerLayoutSource
protocol CameraPreviewControllerLayoutSource: class {
    func cameraPreviewNeedsLayout(_ controller: CameraPreviewController, preview: GPUImageView)
}
