//
//  ScanViewController.swift
//  Gaia
//
//  Created by CoopStudent on 7/30/22.
//


import UIKit
import AVKit
import Vision

class ScanViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var belowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //camera starts
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        view.addSubview(belowView)
        
        belowView.clipsToBounds = true
        belowView.layer.cornerRadius = 15.0
        belowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
     
      //  VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("Camera was able to capture a frame", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return}
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            //perhaps check the err
            print(finishedReq.results!)
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}

            guard let firstObservation = results.first else {return}
            
            print(firstObservation.identifier, firstObservation.confidence)
            self.objectNameLabel.text = firstObservation.identifier
            self.accLabel.text = ("\(firstObservation.confidence)")
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
    /*override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var belowView: UIView!
    @IBOutlet weak var objectNameLabel: UILabel!
    
    //let config = MLModelConfiguration().self
    var model = Resnet50().model
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        // The camera is now created!
        
        view.addSubview(belowView)
        
        belowView.clipsToBounds = true
        belowView.layer.cornerRadius = 15.0
        belowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            var name: String = firstObservation.identifier
            var acc: Int = Int(firstObservation.confidence * 100)
            
            DispatchQueue.main.async {
                self.objectNameLabel.text = name
                self.accLabel.text = "Accuracy: \(acc)%"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    } */
}

