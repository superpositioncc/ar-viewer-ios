import Foundation
import ARKit
import SwiftUI

struct ARViewIndicator: UIViewControllerRepresentable {
	typealias UIViewControllerType = ARView
	
	@Binding public var nObjects: Int
	static var arView: ARView?
	
	func makeUIViewController(context: Context) -> ARView {
		ARViewIndicator.arView = ARView()
		return ARViewIndicator.arView!
	}
	
	func updateUIViewController(_ uiViewController: ARView, context: UIViewControllerRepresentableContext<ARViewIndicator>) {
		uiViewController.populateScene(nObjects: nObjects)
	}
}

class ARView: UIViewController {
	public var nodes: [SCNNode] = []
	
	var arView: ARSCNView {
		return self.view as! ARSCNView
	}
	
	override func loadView() {
		self.view = ARSCNView(frame: .zero)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		arView.scene = SCNScene()
		
		// Ambient light
		let ambientLight = SCNLight()
		ambientLight.type = .ambient
		ambientLight.color = UIColor(white: 0.5, alpha: 1.0)

		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight
		arView.scene.rootNode.addChildNode(ambientLightNode)

		// Directional light
		let directionalLight = SCNLight()
		directionalLight.type = .directional
		directionalLight.color = UIColor(white: 1.0, alpha: 1.0)
		directionalLight.castsShadow = true
		directionalLight.shadowMode = .deferred
		directionalLight.shadowRadius = 5.0
		directionalLight.shadowSampleCount = 16

		let directionalLightNode = SCNNode()
		directionalLightNode.light = directionalLight
		directionalLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
		directionalLightNode.eulerAngles = SCNVector3(x: -Float.pi / 4, y: Float.pi / 4, z: 0)

		arView.scene.rootNode.addChildNode(directionalLightNode)
	}
	
	func populateScene(nObjects: Int) {
		let scene = arView.scene
		
		nodes.forEach() { node in
			node.removeFromParentNode()
		}
		
		nodes.removeAll()
		
		
		for _ in 0..<nObjects {
			let geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
			
			let material = SCNMaterial()
			material.lightingModel = .physicallyBased
			material.isDoubleSided = true
			
			geometry.materials = [material]
			
			let node = SCNNode(geometry: geometry)
			node.position = SCNVector3(x: Float.random(in: -5...5), y: Float.random(in: -5...5), z: Float.random(in: -5...5))
			node.eulerAngles = SCNVector3(x: Float.random(in: 0...Float.pi * 2), y: Float.random(in: 0...Float.pi * 2), z: Float.random(in: 0...Float.pi * 2))
			node.scale = SCNVector3(x: 1, y: 1, z: 1)
			
			scene.rootNode.addChildNode(node)
			
			nodes.append(node)
		}
	}
	
	@objc func loop() {
		let time = Date.timeIntervalSinceReferenceDate
		
		nodes.enumerated().forEach { index, node in
			let scale = 0.5 + 0.1 * sin(time + Double(index) * 0.1)
			node.scale = SCNVector3(x: Float(scale), y: Float(scale), z: Float(scale))
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let configuration = ARWorldTrackingConfiguration()
		configuration.worldAlignment = .gravity
		
		arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
		
		arView.automaticallyUpdatesLighting = true
		arView.rendersCameraGrain = true
		arView.rendersMotionBlur = true
		
		let updater = CADisplayLink(target: self, selector: #selector(self.loop))
		updater.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 60, preferred: 60)
		updater.add(to: .current, forMode: .common)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		arView.session.pause()
	}
}
