//
//  ViewController.swift
//  IDScanner
//
//  Created by Lee on 24/6/2021.
//

import AVFoundation
import UIKit
import SwiftyTesseract
import libtesseract

class ScannerViewController: BaseViewController, AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var btnScan: UIButton!
    
    @IBOutlet weak var ivDebugImage: UIImageView! // for debug only
    
    let scannerRepository = ScannerRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
            self.ivDebugImage.isHidden = false
        #else
            self.ivDebugImage.isHidden = true
        #endif
        self.setScanBtn(isEnabled: true)
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.previewView.videoPreviewLayer.session?.stopRunning()
        LoadingIndicator.instance.startAnimating(title: "",style: .large, view: self.view)
        self.setScanBtn(isEnabled: false)
        
        if let image = UIImage(data: imageData) {
            self.previewView.cropImage(image: image.fixedOrientation(), completion: { image -> Void in
                // during to demo it wouldn't submit to server
                // only use offline ocr function
                DispatchQueue.main.async {
                    // during to demo it would using server
                    if false /*ReachabilityManager.instance.isReachable()*/ {
                        if let imagaData = image.jpegData(compressionQuality: 0.8) {
                            let filename = UUID().uuidString + ".jpeg"
                            let mimeType = "image/jpeg"
                            
                            #if DEBUG
                            let compressedImage = UIImage.init(data: imagaData)
                            self.ivDebugImage.image = compressedImage
                            #endif
                            // TODO
                            // call server api
                        }
                    }  else {
                        // offline mode
                        if let imagaData = image.jpegData(compressionQuality: 1.0) {
                            #if DEBUG
                            let compressedImage = UIImage.init(data: imagaData)
                            self.ivDebugImage.image = compressedImage
                            #endif
                            let tesseract = Tesseract(languages:  [.english,.chineseTraditional, .chineseSimplified])
                            tesseract.pageSegmentationMode = .sparseText
                            let result: Result<String, Tesseract.Error> = tesseract.performOCR(on: imagaData)
                            print(result)
                            switch result {
                            case .success(let content):
                                var imageInfoList: [[String: Any]]? = []
                                imageInfoList?.append(["Result" : content])
                                FlowControlManager.instance.presentScannerDetailViewPage(self, imageInfoList, resultImage: compressedImage)
                            default:
                                break;
                            }
                        }
                        DispatchQueue.global(qos: .background).async {
                            self.previewView.videoPreviewLayer.session?.startRunning()
                        }
                        LoadingIndicator.instance.stopAnimating(navigationItem: self.navigationItem)
                        self.setScanBtn(isEnabled: true)
                    }
                }
            })
        }
    }
    @IBAction func btnScanClicked(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        previewView.capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }
    func setScanBtn(isEnabled: Bool) {
        self.btnScan.isEnabled = isEnabled
        if isEnabled {
            self.btnScan.setTitle(NSLocalizedString("LBL_SCAN".localized(), comment: ""), for: UIControl.State.normal)
            self.btnScan.alpha = 1.0
        } else {
            self.btnScan.setTitle("LBL_IN_PROGRESS".localized(), for: UIControl.State.normal)
            self.btnScan.alpha = 0.5
        }
    }
}
