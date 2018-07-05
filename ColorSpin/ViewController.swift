//
//  ViewController.swift
//  ColorSpin
//
//  Created by Thuy Truong Quang on 7/5/18.
//  Copyright © 2018 Thuy Truong Quang. All rights reserved.
//

import UIKit
import SpriteKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }


}

