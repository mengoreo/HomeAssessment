//
//  ARMeasureView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
import ARKit

struct ARMeasureView: View {
    var doneAction: (Double) -> Void = {_ in}
    var body: some View {
        ARView(doneAction: doneAction)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARView: UIViewRepresentable {

    let centerPoint = UIImageView(image: UIImage(systemName: "scope", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 17), scale: .large)))
    let statusLabel = UILabel(frame: .zero)
    let statusView = UIVisualEffectView(frame: .zero)
    let flashButtonView = UIVisualEffectView(frame: .zero)
    let undoButtonView = UIVisualEffectView(frame: .zero)
    
    let flashButton = UIButton(type: .detailDisclosure)
    let addButton = UIButton(type: .system)
    let undoButton = UIButton(type: .detailDisclosure)
    let doneButton = UIButton(type: .detailDisclosure)
    
    let sceneView = ARSCNView(frame: .zero)
    
    var flashStatus = false {
        didSet {
            print("flashStatus did set")
            toggleFlashlightView(on: flashStatus)
        }
    }
    
    var doneAction: (Double) -> Void
    init(doneAction: @escaping (Double) -> Void = {_ in }) {
        self.doneAction = doneAction
    }
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> ARSCNView {
        statusView.layer.opacity = 0
        doneButton.layer.opacity = 0
        flashButtonView.layer.opacity = 0
        undoButtonView.layer.opacity = 0
        setup(sceneView)
        sceneView.automaticallyUpdatesLighting = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.delegate = context.coordinator
        
        
        addButton.addTarget(context.coordinator, action: #selector(context.coordinator.addPoint), for: .touchUpInside)
        flashButton.addTarget(context.coordinator, action: #selector(context.coordinator.flashButtonTapped(_:)), for: .touchUpInside)
        undoButton.addTarget(context.coordinator, action: #selector(context.coordinator.undoButtonTapped(_:)), for: .touchUpInside)
        doneButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        doneButton.tintColor = .tintColor
        doneButton.addTarget(context.coordinator, action: #selector(context.coordinator.doneButtonTapped(_:)), for: .touchUpInside)
        
        return sceneView
    }
    
    func setup(_ sceneView: ARSCNView) {
        centerPoint.translatesAutoresizingMaskIntoConstraints = false
        centerPoint.tintColor = .white
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.tintColor = .white
        statusView.contentView.addSubview(statusLabel)
        statusView.effect = UIBlurEffect(style: .dark)
        statusView.layer.cornerRadius = 10
        statusView.clipsToBounds = true
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        statusView.contentView.addSubview(doneButton)
        
        flashButton.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButtonView.effect = UIBlurEffect(style: .dark)
        flashButtonView.contentView.addSubview(flashButton)
        flashButtonView.layer.cornerRadius = 17
        flashButtonView.clipsToBounds = true
        flashButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 23), scale: .large)), for: .normal)
        addButton.tintColor = .white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        undoButtonView.effect = UIBlurEffect(style: .dark)
        undoButton.setImage(UIImage(systemName: "arrow.uturn.left", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 13), scale: .medium)), for: .normal)
        undoButton.tintColor = .white
        undoButtonView.contentView.addSubview(undoButton)
        undoButtonView.layer.cornerRadius = 17
        undoButtonView.clipsToBounds = true
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        sceneView.addSubview(centerPoint)
        sceneView.addSubview(statusView)
//        sceneView.addSubview(clearButtonView)
        sceneView.addSubview(addButton)
        sceneView.addSubview(undoButtonView)
        sceneView.addSubview(flashButtonView)
        
        NSLayoutConstraint.activate([
            centerPoint.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            centerPoint.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor),
            
            statusView.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            statusView.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 40),
            statusView.widthAnchor.constraint(equalTo: sceneView.widthAnchor, multiplier: 0.8),
            statusView.heightAnchor.constraint(equalToConstant: 60),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusView.contentView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.contentView.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalTo: statusView.contentView.widthAnchor, multiplier: 0.8),
            statusLabel.heightAnchor.constraint(equalTo: statusView.contentView.heightAnchor, multiplier: 0.8),
            
            doneButton.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -20),
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 30),

            
            flashButton.centerXAnchor.constraint(equalTo: flashButtonView.centerXAnchor),
            flashButton.centerYAnchor.constraint(equalTo: flashButtonView.centerYAnchor),
            flashButtonView.widthAnchor.constraint(equalToConstant: 40),
            flashButtonView.heightAnchor.constraint(equalToConstant: 40),
            flashButtonView.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            flashButtonView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20),
            
            undoButtonView.leadingAnchor.constraint(equalTo: sceneView.leadingAnchor, constant: 20),
            undoButtonView.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -40),
            undoButtonView.widthAnchor.constraint(equalToConstant: 50),
            undoButtonView.heightAnchor.constraint(equalToConstant: 40),
            undoButton.centerXAnchor.constraint(equalTo: undoButtonView.centerXAnchor),
            undoButton.centerYAnchor.constraint(equalTo: undoButtonView.centerYAnchor),
            
            
            addButton.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: undoButton.topAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            
        ])
        
    }
    
    func updateUIView(_ uiView: ARSCNView, context: UIViewRepresentableContext<ARView>) {
    }
    func showFlashlight() {
        defer {
            flashButton.isEnabled = true
        }
        flashButton.tintColor = flashStatus ? .black : .white
        flashButton.show()
    }
    func hideFlashlight() {
        if !flashStatus {
            flashButton.isEnabled = false
            flashButton.hide()
        }
    }
    
    func toggleFlashlightView(on: Bool) {
        if on {
            flashButtonView.effect = UIBlurEffect(style: .extraLight)
            flashButton.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        } else {
            flashButtonView.effect = UIBlurEffect(style: .dark)
            flashButton.setImage(UIImage(systemName: "flashlight.off.fill"), for: .normal)
        }
        toggleTorch(on: on)
    }
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
        else {return}

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                device.torchMode = on ? .on : .off

                device.unlockForConfiguration()
            } catch {
                print("*** Torch could not be used")
            }
        } else {
            print("*** Torch is not available")
        }
    }
    
    func updateStatusLabe(text: String) {
        statusView.show()
        statusLabel.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARView
        init(_ parent: ARView) {
            self.parent = parent
        }
        lazy var screenCenterPoint: CGPoint = {
            return parent.centerPoint.center
        }()
        
        let lineWidth = CGFloat(0.003)
        let nodeRadius = CGFloat(0.007)
        let nodeColor = UIColor.white.withAlphaComponent(0.9)
        let realTimeLineName = "realTimeLine"
        var realTimeLineNode: LineNode?
        var distanceNodes = NSMutableArray()
        var lineNodes = NSMutableArray()
        var flashStatus = false
        var resultDistance: Double = 0
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            // light estimation
            guard let lightEstimate = parent.sceneView.session.currentFrame?.lightEstimate else {return}
            let ambientLigthEstimate = lightEstimate.ambientIntensity
            DispatchQueue.main.async {
                ambientLigthEstimate < 100
                    ? self.parent.showFlashlight()
                    : self.parent.hideFlashlight()
            }
            
            let dotNodes = distanceNodes as! [SCNNode]
            if dotNodes.count > 0, let currentCameraPosition = parent.sceneView.pointOfView {
                updateScaleFromCameraForNodes(dotNodes, fromPointOfView: currentCameraPosition)
            }
            
            //Update realtime line node
//            print("** parent:", realTimeLineNode?.parent)
            if realTimeLineNode?.parent != nil, // hideed or not
                let realTimeLineNode = realTimeLineNode,
                let hitResultPosition = parent.sceneView.hitResult(forPoint: screenCenterPoint),
                let startNode = distanceNodes.firstObject as? SCNNode {
                realTimeLineNode.updateNode(vectorA: startNode.position, vectorB: hitResultPosition, color: nil)
                
                let distance = parent.sceneView.distance(betweenPoints: startNode.position, point2: hitResultPosition)
                
                DispatchQueue.main.async {
                    self.parent.updateStatusLabe(text: String(format: "测量结果： %.3f cm", distance*100.0))
                }
            }
        }
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            switch camera.trackingState {
            case .normal:
                print("*** Normal")
                break
            case .limited(.initializing):
                print("*** initializing")
//                afterDelay(3, run: {self.warningView.isHidden = true})
                break
            case .limited(.insufficientFeatures):
                print("*** insufficient")
                break
            case .limited(.excessiveMotion):
                print("*** excessive motion")
                break
            case .limited(.relocalizing):
                print("*** limited")
                break
            case .notAvailable:
                print("*** Not available")
                break
            default:
                break
            }
        }
        private func updateScaleFromCameraForNodes(_ nodes: [SCNNode], fromPointOfView pointOfView: SCNNode) {
            nodes.forEach { (node) in
                
                // current position of the node
                let positionOfNode = SCNVector3ToGLKVector3(node.worldPosition)
                
                // current position of the camera
                let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.worldPosition)
                
                // calculate the distance from the node to the camera
                let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
                
                // animate the scaling and set the scale based on the distance from the camera
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                switch distanceBetweenNodeAndCamera {
                case 0...0.5:
                    node.simdScale = simd_float3(0.25, 0.25, 0.25)
                case 0.5...1.5:
                    node.simdScale = simd_float3(0.5, 0.5, 0.5)
                case 1.5 ... 2.5:
                    node.simdScale = simd_float3(1, 1, 1)
                case 2.5 ... 3:
                    node.simdScale = simd_float3(1.5, 1.5, 1.5)
                case 3 ... 3.5:
                    node.simdScale = simd_float3(2, 2, 2)
                case 3.5 ... 5:
                    node.simdScale = simd_float3(2.5, 2.5, 2.5)
                default:
                    node.simdScale = simd_float3(3, 3, 3)
                }
                SCNTransaction.commit()
                
            }
        }
        
        private func addRealtimeNode() {
            print("** addRealtimeNode")
            guard let hitResultPosition = parent.sceneView.hitResult(forPoint: screenCenterPoint) else {
                return
            }
            realTimeLineNode = LineNode(from: hitResultPosition, to: hitResultPosition, lineColor: nodeColor, lineWidth: lineWidth)
            realTimeLineNode?.name = realTimeLineName
            parent
                .sceneView
                .scene
                .rootNode
                .addChildNode(realTimeLineNode!)
        }
        private func hideRealtimeLine() {
            print("** hideRealtimeLine")
            realTimeLineNode?.removeFromParentNode()
        }
        private func showRealtimeLine() {
            print("** showRealtimeLine")
            if let real = realTimeLineNode {
                parent
                    .sceneView
                    .scene
                    .rootNode
                    .addChildNode(real)
            }
        }
        private func addMeasuredNode() -> CGFloat {
            guard let hitResultPosition = parent.sceneView.hitResult(forPoint: screenCenterPoint) else {
                return 0
            }
            let nodes = distanceNodes
            let sphere = SCNSphere(radius: nodeRadius)
            sphere.firstMaterial?.diffuse.contents = nodeColor
            let node = SCNNode(geometry: sphere)
            node.position = hitResultPosition
            parent.sceneView.scene.rootNode.addChildNode(node)
            nodes.add(node)
            
            if nodes.count == 2 {
                let startNode = nodes[0] as! SCNNode
                let endNode = nodes[1] as! SCNNode
                let measureLine = LineNode(from: startNode.position, to: endNode.position, lineColor: nodeColor, lineWidth: lineWidth)
                parent.sceneView.scene.rootNode.addChildNode(measureLine)
                lineNodes.add(measureLine)
                hideRealtimeLine()
                return parent.sceneView.distance(betweenPoints: startNode.position, point2: endNode.position)
            } else {
                addRealtimeNode()
            }
            return 0
        }
        
        
        @objc func addPoint(_ sender: UIButton) {
            
            // prevent multiple taps
            sender.isUserInteractionEnabled = false
            defer {
                sender.isUserInteractionEnabled = true
            }
            if distanceNodes.count == 0 {
                _ = addMeasuredNode()
                
                if realTimeLineNode != nil {
                    DispatchQueue.main.async(execute: parent.undoButtonView.show)
                }
            } else {
                resultDistance = Double(addMeasuredNode())
                DispatchQueue.main.async {
                    self.parent.doneButton.show()
                    self.parent.addButton.hide()
                }
                
            }
            
        }
        
        @objc func doneButtonTapped(_ sender: UIButton) {
            sender.isUserInteractionEnabled = false
            defer {
                sender.isUserInteractionEnabled = true
            }
            parent.doneAction(resultDistance * 100)
        }
        @objc func undoButtonTapped(_ sender: UIButton) {
            print("*** undo")
            // prevent multiple taps
            sender.isUserInteractionEnabled = false
            defer {
                sender.isUserInteractionEnabled = true
            }
//            removeNodes(fromNodeList: self.distanceNodes)
//            realTimeLineNode?.removeFromParentNode()
            if distanceNodes.count == 1 {
                removeNodes(fromNodeList: distanceNodes)
                realTimeLineNode?.removeFromParentNode()
                realTimeLineNode = nil
                DispatchQueue.main.async {
                    self.parent.undoButtonView.hide()
                    self.parent.statusView.hide()
                }
            } else {
                if let node = distanceNodes.lastObject as? SCNNode {
                    print("removing last distance node")
                    node.removeFromParentNode()
                    distanceNodes.remove(node)
                }
                removeNodes(fromNodeList: lineNodes)
                showRealtimeLine()
            }
            
            DispatchQueue.main.async {
                self.parent.doneButton.hide()
                self.parent.addButton.show()
            }
        }
        @objc func flashButtonTapped(_ sender: UIButton) {
            sender.isUserInteractionEnabled = false
            defer {
                sender.isUserInteractionEnabled = true
            }
            parent.flashStatus.toggle()
            print("flashButtonTapped")
        }
        
        
        private func removeNodes(fromNodeList nodes: NSMutableArray) {
            for node in nodes {
                if let node = node as? SCNNode {
                    node.removeFromParentNode()
                    nodes.remove(node)
                }
            }
        }
    }
}

class LineNode: SCNNode {
    
    let lineThickness = CGFloat(0.001)
    let radius = CGFloat(0.01)
    private var boxGeometry: SCNBox!
    private var nodeLine: SCNNode!

    init(from vectorA: SCNVector3, to vectorB: SCNVector3, lineColor color: UIColor, lineWidth width: CGFloat) {
        super.init()
        
        self.position = vectorA
        
        let nodeZAlign = SCNNode()
        nodeZAlign.eulerAngles.x = Float.pi/2
        
        let height = self.distance(from: vectorA, to: vectorB)
        boxGeometry = SCNBox(width: width, height: height, length: lineThickness, chamferRadius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        boxGeometry.materials = [material]
        
        nodeLine = SCNNode(geometry: boxGeometry)
        nodeLine.position.y = Float(-height/2) + 0.001
        nodeZAlign.addChildNode(nodeLine)
        
        self.addChildNode(nodeZAlign)
        
        let orientationNode = SCNNode()
        orientationNode.position = vectorB
        self.constraints = [SCNLookAtConstraint(target: orientationNode)]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distance(from vectorA: SCNVector3, to vectorB: SCNVector3)-> CGFloat {
        return
            CGFloat (sqrt(
                (vectorA.x - vectorB.x) * (vectorA.x - vectorB.x) +
                    (vectorA.y - vectorB.y) * (vectorA.y - vectorB.y) +
                    (vectorA.z - vectorB.z) * (vectorA.z - vectorB.z)))
    }
    
    func updateNode(vectorA: SCNVector3? = nil, vectorB: SCNVector3? = nil, color: UIColor?) {
        if let vectorA = vectorA, let vectorB = vectorB {
            let height = self.distance(from: vectorA, to: vectorB)
            boxGeometry.height = height
            nodeLine.position.y = Float(-height/2) + 0.001
            
            let orientationNode = SCNNode()
            orientationNode.position = vectorB
            self.constraints = [SCNLookAtConstraint(target: orientationNode)]
        }
        if let color = color {
            let material = SCNMaterial()
            material.diffuse.contents = color
            boxGeometry.materials = [material]
        }
    }
}

