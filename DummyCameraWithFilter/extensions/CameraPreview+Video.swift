//
//  CameraPreview+Extension.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 03/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

extension CameraPreviewController {
    
    open func startRecordingVideo(completion: (() -> Void)? = nil) {
        
        if !isRecordingVideo {
            
            let formatDescription = camera.inputCamera.activeFormat.formatDescription
            
            findOrientation(completion: { (orientation) in
                
                let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
                let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(UUID().uuidString).m4v")
                let url = URL(fileURLWithPath: path)
                let videoWidth = CGFloat(min(dimensions.width, dimensions.height))
                let videoHeight = CGFloat(max(dimensions.width, dimensions.height))
                
                if let writer = GPUImageMovieWriter(movieURL: url, size: CGSize(width: videoWidth, height: videoHeight)) {
                    self.lastFilter.addTarget(writer)
                    self.videoWriter = writer
                    self.videoUrl = url
                    writer.delegate = self
                    
                    let radian: ((CGFloat) -> CGFloat) = { degree in
                        return CGFloat(Double.pi) * degree / CGFloat(180)
                    }
                    
                    var transform: CGAffineTransform?
                    switch orientation {
                    case .landscapeLeft:
                        transform = CGAffineTransform(rotationAngle: radian(90))
                    case .landscapeRight:
                        transform = CGAffineTransform(rotationAngle: radian(-90))
                    case .portraitUpsideDown:
                        transform = CGAffineTransform(rotationAngle: radian(180))
                    default:
                        break
                    }
                    
                    if self.cameraPosition == .front, orientation.isLandscape {
                        transform = transform?.scaledBy(x: -1, y: 1)
                    }
                    
                    DispatchQueue.main.async {
                        if let transform = transform {
                            writer.startRecording(inOrientation: transform)
                        } else {
                            writer.startRecording()
                        }
                        completion?()
                    }
                }
            })
        }
    }
    
    open func finishRecordingVideo(completion: (() -> Void)? = nil) {
        print("RECORDING STATE \(isRecordingVideo)")
        if isRecordingVideo {
            if let writer = self.videoWriter {
                DispatchQueue.main.async {
                    if let completion = completion {
                        writer.finishRecording(completionHandler: completion)
                    } else {
                        writer.finishRecording()
                    }
                    self.lastFilter.removeTarget(writer)
                }
            } else {
                print("Invalid status error.")
            }
        }
    }
    
    func clearRecordingVideo() {
        videoWriter = nil
        videoUrl = nil
    }
}

// MARK: - GPUImageMovieWriterDelegate
extension CameraPreviewController: GPUImageMovieWriterDelegate {
    
    public func movieRecordingCompleted() {
        if let videoUrl = self.videoUrl, isRecordingVideo {
            clearRecordingVideo()
            DispatchQueue.main.async {
                print("RECORDING URL \(videoUrl)")
                self.delegate?.cameraPreview(self, didSaveVideoAt: videoUrl)
            }
        }
    }
    
    public func movieRecordingFailedWithError(_ error: Error!) {
        print("\(error?.localizedDescription ?? "")")
        if isRecordingVideo {
            clearRecordingVideo()
            DispatchQueue.main.async {
                self.delegate?.cameraPreview(self, didFailSaveVideoWithError: error)
            }
        }
    }
}
