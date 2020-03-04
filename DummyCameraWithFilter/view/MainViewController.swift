//
//  MainViewController.swift
//  DummyCameraWithFilter
//
//  Created by Israel Meshileya on 03/03/2020.
//  Copyright © 2020 Israel. All rights reserved.
//

import Foundation
import UIKit
import GPUImage
import Firebase
import FirebaseStorage

class MainViewController : CameraPreviewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(stackView)
        
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    override func loadView() {
        super.loadView()
        cameraPosition = .back
        delegate = self
    }
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(startVideoCameraButton)
        stackView.addArrangedSubview(historyButton)
        stackView.addArrangedSubview(addFilterButton)
        stackView.addArrangedSubview(clearFilterButton)
        return stackView
    }()
    
    
    
    lazy var startVideoCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Video", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startStopRecordingCall), for: .touchUpInside)
        return button
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("History", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onHistoryCall), for: .touchUpInside)
        return button
    }()
    
    lazy var addFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Filter", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(addFilterCall), for: .touchUpInside)
        return button
    }()
    
    lazy var clearFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear Filter", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearFilterCall), for: .touchUpInside)
        return button
    }()
}

extension MainViewController {
    
    @objc public func onHistoryCall(sender: UIButton){
        
    }
    @objc public func startStopRecordingCall(sender: UIButton) {
        DispatchQueue.main.async {
            if self.isRecordingVideo {
                print("STARTTTT")
                sender.setTitle("Start Recording", for: .normal)
              self.finishRecordingVideo(completion: {
              })
          } else {
                print("STOPPPPP")
                sender.setTitle("Stop Recording", for: .normal)
              self.startRecordingVideo(completion: {
              })
          }
        }
    }
    
    
    @objc public func addFilterCall(sender: UIButton) {
        let sepiaFilter = GPUImageSepiaFilter()
        sepiaFilter.intensity = 1
        add(filter: sepiaFilter)
    }
    @objc public func clearFilterCall(sender: UIButton) {
        removeFilters()
    }
}

// MARK: - Implementation for CameraPreviewControllerDelegate
extension MainViewController: CameraPreviewControllerDelegate {
    
    func cameraPreview(_ controller: CameraPreviewController, didSaveVideoAt url: URL) {
        print("DONE WITH VIDEO")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(finishedWriteVideoToSavedPhotosAlbum), nil)
        } else {
            print("Given path: \(url.absoluteString) is not compatible with \"Saved Photos Album\"")
        }
    }
    
    func cameraPreview(_ controller: CameraPreviewController, didFailSaveVideoWithError error: Error) {
//        btnTakeVideo.hideLoading()
    }
    
    func cameraPreview(_ controller: CameraPreviewController, willOutput sampleBuffer: CMSampleBuffer, with sequence: UInt64) {
        
    }
    
    func cameraPreview(_ controller: CameraPreviewController, willFocusInto locationInView: CGPoint, tappedLocationInImage locationInImage: CGPoint) {
        print("Focusing location in view: \(locationInView)")
        print("Focusing location(ratio) in image: \(locationInImage)")
    }
}

// MARK: Handles Video Capture
extension MainViewController {
    @objc func finishedWriteVideoToSavedPhotosAlbum(_ videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            if let videoUrl = URL(string: videoPath) {
                let ref = Storage.storage().reference()
                       let meta = StorageMetadata()
                       meta.contentType = "video/quicktime"
                
//
//            let uploadTask = ref.putFile(from: URL(string: "file://\(videoPath)")!, metadata: nil) { metadata, error in
//                  if let error = error
//                  {
//                    print("ERROR \(error)")
//                    //do error handle
//                  }
//                }
                
                
                
                       
                       if let videoData = NSData(contentsOf: videoUrl) as Data? {
                                   let uploadTask = ref.putData(videoData, metadata: meta){ meta, error in
                                     if let error = error
                                     {
                                         print("I AM HERERERER")
                                       print(error)
                                     }
                                   }
                       }
            }
            
            CacheHelper().cacheData(data: videoPath, key: "vidFileUrl")
            print("Successfully saved a video file in Photo Library: \(videoPath)")
        }
        DispatchQueue.main.async {
//            self.btnTakeVideo.setTitle("Take Video", for: .normal)
//            self.btnTakeVideo.hideLoading()
        }
    }
}

// MARK: - Implementation for CameraPreviewControllerLayoutSource
extension  MainViewController: CameraPreviewControllerLayoutSource {
    func cameraPreviewNeedsLayout(_ controller: CameraPreviewController, preview: GPUImageView) {
        view.addSubview(preview)
        preview.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        preview.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
    }
}
