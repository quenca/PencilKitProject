//
//  PencilKitViewController.swift
//  PencilKitProject
//
//  Created by gustavo.quenca on 12/06/20.
//  Copyright © 2020 gustavo.quenca. All rights reserved.
//

import UIKit
import PencilKit
import CoreML

class PencilKitViewController: UIViewController {
    
    let canvasView = PKCanvasView(frame: .zero)
    
    let palletsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pallets", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let detectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Detect", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let predictedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let window = view.window, let toolPicker = PKToolPicker.shared(for: window)
            else { return }
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        setupCanvasView()
        
    }
    
    func setupNavigationBar() {
        view.addSubview(palletsButton)
        view.addSubview(clearButton)
        view.addSubview(saveButton)
        view.addSubview(predictedLabel)
        view.addSubview(detectButton)
        
        NSLayoutConstraint.activate([
            palletsButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            palletsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            palletsButton.widthAnchor.constraint(equalToConstant: 50),
            palletsButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            clearButton.trailingAnchor.constraint(equalTo: palletsButton.leadingAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalToConstant: 50),
            clearButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            predictedLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            predictedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            predictedLabel.widthAnchor.constraint(equalToConstant: 100),
            predictedLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            detectButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            detectButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: 20),
            detectButton.widthAnchor.constraint(equalToConstant: 100),
            detectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        palletsButton.addTarget(self, action:#selector(actionWithoutParam), for: .touchUpInside)
        
        clearButton.addTarget(self, action:#selector(clear), for: .touchUpInside)
        
        saveButton.addTarget(self, action:#selector(saveImage), for: .touchUpInside)
        
        detectButton.addTarget(self, action:#selector(detectImage), for: .touchUpInside)
        
    }
    
    func setupCanvasView() {
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: palletsButton.bottomAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func actionWithoutParam() {
        
        if canvasView.isFirstResponder{
            canvasView.resignFirstResponder()
        }else{
            canvasView.becomeFirstResponder()
        }
    }
    
    @objc func clear() {
        canvasView.drawing = PKDrawing()
    }
    
    @objc func saveImage() {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1.0)
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    // CORE ML
    
    func preprocessImage() -> UIImage
    {
        var image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 10.0)

        if let newImage = UIImage(color: .black, size: CGSize(width: view.frame.width, height: view.frame.height)){
            
            if let overlayedImage = newImage.image(byDrawingImage: image, inRect: CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.frame.height)){
                image = overlayedImage
            }
        }
        
        return image
    }
    
    @objc func detectImage() {
        
        let image = preprocessImage()
        predictImage(image: image)
        
    }
    
    private let trainedImageSize = CGSize(width: 28, height: 28)

    func predictImage(image: UIImage){
        if let resizedImage = image.resize(newSize: trainedImageSize), let pixelBuffer = resizedImage.toCVPixelBuffer(){

        guard let result = try? MNIST().prediction(image: pixelBuffer) else {
            print("error in image...")
            return
        }
            
            predictedLabel.text = "Predicted: \(result.classLabel)"
            print("result is \(result.classLabel)")
        }
    }
}
