//
//  CameraPreviewController.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 03/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import PureLayout
import GPUImage

class CameraPreviewController: UIViewController {
    
    // MARK: Delegates
    open weak var delegate: CameraPreviewControllerDelegate?
    open weak var layoutSource: CameraPreviewControllerLayoutSource?
    
    // MARK: Layout
    fileprivate var didSetupConstraints = false
    var customConstraints = false
    
    // MARK: AVFoundation
    open var cameraPosition: AVCaptureDevice.Position = .front
    open var capturePreset: String = AVCaptureSession.Preset.high.rawValue
    open var captureSequence: UInt64 = 0
    open var fillMode: GPUImageFillModeType = kGPUImageFillModePreserveAspectRatioAndFill
    open var resolution: CGSize = .zero
    
    // MARK: GPUImage
    let preview: GPUImageView = { return GPUImageView.newAutoLayout() }()
    var camera: GPUImageStillCamera!
    
    // MARK: Filter
    var defaultFilter = GPUImageFilter()
    var filters = [GPUImageFilter]()
    var lastFilter: GPUImageOutput { return filters.last ?? defaultFilter }
    
    // MARK: Video
    var motionManager = CMMotionManager()
    var videoWriter: GPUImageMovieWriter?
    var videoUrl: URL?
    
    open var isRecordingVideo: Bool {
        if let videoWriter = self.videoWriter, let _ = self.videoUrl, !videoWriter.isPaused {
            return true
        } else {
            return false
        }
    }
    
    override open func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .white
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews(){
        setupPreview()
        setupCamera()
        setupNotification()
        startCapture()
        view.setNeedsUpdateConstraints()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override open func updateViewConstraints() {
        if !didSetupConstraints {
            if !customConstraints {
                preview.autoPinEdgesToSuperviewEdges()
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        clearCamera()
        clearNotification()
    }
}
