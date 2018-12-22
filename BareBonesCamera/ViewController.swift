//
//  ViewController.swift
//  BareBonesCamera
//
//  Created by Wilson Gramer on 12/22/18.
//  Copyright © 2018 Neef.co. All rights reserved.
//

import UIKit
import AVFoundation

import AVFoundation
import UIKit

/// https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code

class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            self.failed()
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            self.failed()
            return
        }
        
        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)
        } else {
            self.failed()
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = self.view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        
        self.captureSession.startRunning()
    }
    
    func failed() {
        let alert = UIAlertController(title: "Error",
                                      message: "Your device does not support the camera. Please check permissions and try again.",
                                      preferredStyle: .alert)
        
        self.present(alert, animated: true)
        self.captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.captureSession?.isRunning == false) {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.captureSession?.isRunning == true) {
            self.captureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

