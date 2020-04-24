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
        let start
    }
 
}
