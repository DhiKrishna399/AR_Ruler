//
//  ViewController.swift
//  AR_Ruler
//
//  Created by Dhiva Krishna on 4/23/20.
//  Copyright © 2020 Dhiva Krishna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //Array to keep track of all the dotNodes
    var dotNodesArr = [SCNNode]()
    
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //Visually present the points when scanning for a surface
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    //Keeps track of touches occuring on the application
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodesArr.count >= 2 {
            for dot in dotNodesArr {
                dot.removeFromParentNode()
            }
            
            dotNodesArr = [SCNNode]()
        }
        
        //touches is the set of UI touches we get when the screen is touched
        if let touchLocation = touches.first?.location(in: sceneView){
            //Feature point gives us the 3D location of a continuous function if it exists
            let hitTestresults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestresults.first{
                addDot(at: hitResult) //Add a dot at the hit locaiton
            }
        }
    }
    
    //The external parameter
    func addDot(at hitResult: ARHitTestResult){
        
    
        let material = SCNMaterial()
        let nodeGeo = SCNSphere(radius: 0.005)
        material.diffuse.contents = UIColor.red
        nodeGeo.materials = [material]
        
        let dotNode = SCNNode(geometry: nodeGeo)
        
        dotNode.position = SCNVector3(x:hitResult.worldTransform.columns.3.x, y:hitResult.worldTransform.columns.3.y, z:hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodesArr.append(dotNode)
        
        if dotNodesArr.count >= 2 {
            calculate()
        }
        
    }
    
    func calculate(){
        let start = dotNodesArr[0]
        let end = dotNodesArr[1]
        
        print(start.position)
        print(end.position)
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = abs(sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2)))
        let formatDist = String(format: "%.2f", distance)
        print(formatDist)
        
        updateText(text: formatDist, lastPosition: end.position)
        
    }
    
    func updateText(text: String, lastPosition: SCNVector3){

        textNode.removeFromParentNode()
        let textGeo = SCNText(string: text + "m", extrusionDepth: 1.0)
        textGeo.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeo)
        textNode.position = SCNVector3(lastPosition.x, lastPosition.y + 0.01, lastPosition.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode((textNode))
    }
    
    
 
}
