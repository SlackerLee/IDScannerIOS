//
//  PreviewView.swift
//  IDScanner
//
//  Created by Lee on 25/6/2021.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    
    public var lineWidth: CGFloat = 6
    public var lineColor: UIColor = .white
    public var lineCap: CAShapeLayerLineCap = .round
    private var viewRect: CGRect?
    
    public var maskContainer: CGRect {
        CGRect(x: (UIScreen.main.bounds.width / 2) - (maskSize.width / 2) ,
               y: (UIScreen.main.bounds.height / 2) - (maskSize.height / 2),
               width: maskSize.width, height: maskSize.height)
    }
    public var cornerLength: CGFloat = 30
    
    public var maskSize: CGSize = CGSize(width: UIScreen.main.bounds.width / 1.05, height: UIScreen.main.bounds.height / 3)
    
    // a capture output for use in workflows related to still photography.
    var capturePhotoOutput = AVCapturePhotoOutput()
    
    // Init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(frame: frame)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Does the initial setup for captureSession
    private func setup(frame: CGRect) {
        self.viewRect = frame
        clipsToBounds = true
        session = AVCaptureSession()
        
        capturePhotoOutput = AVCapturePhotoOutput()
        //        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if (session?.canAddInput(videoInput) ?? false) {
                session?.addInput(videoInput)
                session?.addOutput(capturePhotoOutput)
            } else {
                scanningDidFail()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            if (session?.canAddOutput(metadataOutput) ?? false) {
                session?.addOutput(metadataOutput)
            } else {
                scanningDidFail()
                return
            }
            
            self.videoPreviewLayer.session = session
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
            
            self.videoPreviewLayer.addSublayer(createMaskLayer(videoPreviewLayer: self.videoPreviewLayer))
            self.videoPreviewLayer.addSublayer(createEdgedCornersLayer(videoPreviewLayer: self.videoPreviewLayer))
            
            session?.startRunning()
        } catch let error {
            print(error)
            scanningDidFail()
            session = nil
            return
        }
    }
    func scanningDidFail() {
        session = nil
    }
}

// MARK: create overlay preview layer
extension PreviewView {
    
    func createMaskLayer(videoPreviewLayer: AVCaptureVideoPreviewLayer) -> CAShapeLayer {
        
        // MARK: - Background Mask
        
        let cornerRadius = videoPreviewLayer.cornerRadius
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRoundedRect(in: maskContainer, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.6).cgColor
        maskLayer.fillRule = .evenOdd
        
        self.videoPreviewLayer.addSublayer(maskLayer)
        return maskLayer
    }
    func createEdgedCornersLayer(videoPreviewLayer: AVCaptureVideoPreviewLayer) -> CAShapeLayer {
        
        // MARK: - Edged Corners
        
        var cornerRadius = videoPreviewLayer.cornerRadius
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > maskContainer.width / 2 { cornerLength = maskContainer.width / 2 }
        
        let upperLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.minY)
        let upperRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.minY)
        let lowerRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.maxY)
        let lowerLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.maxY)
        
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                                radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        
        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap
        return shapeLayer
    }
    
    func cropImage(image: UIImage,completion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            let aspectRatioHeight = image.size.height / UIScreen.main.bounds.height
            let aspectRatioWidth = image.size.width / UIScreen.main.bounds.width
            
            var newSize = image.size
            
            newSize.height = self.maskContainer.height * aspectRatioHeight
            newSize.width = self.maskContainer.width * aspectRatioWidth
            
            
            let center = CGPoint(x: image.size.width/2, y: image.size.height/2)
            let origin = CGPoint(x: center.x - newSize.width/2, y: center.y - newSize.height/2)
            
            
            let cgCroppedImage = image.cgImage!.cropping(to: CGRect(origin: origin, size: CGSize(width: newSize.width, height: newSize.height)))!
            let croppedImage = UIImage(cgImage: cgCroppedImage, scale: image.scale, orientation: image.imageOrientation)
            
            completion(croppedImage)
        }
    }
    
}
internal extension CGPoint {
    
    // MARK: - CGPoint+offsetBy

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
