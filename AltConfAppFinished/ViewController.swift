//
//  ViewController.swift
//  AltConfAppFinished
//
//  Created by David Okun IBM on 6/6/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import Lumina

class ViewController: LuminaViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.streamingModels = [LuminaModel(model: AltConfLab().model, type: "AltConf")]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(label: String) {
        UserDefaults.standard.set(true, forKey: label)
        UserDefaults.standard.synchronize()
    }
    
    
    func clear() {
        UserDefaults.standard.set(false, forKey: "Apple")
        UserDefaults.standard.set(false, forKey: "Banana")
        UserDefaults.standard.set(false, forKey: "Beer")
        UserDefaults.standard.set(false, forKey: "Sunglasses")
        UserDefaults.standard.synchronize()
    }
    
    func alreadyFound(label: String) -> Bool {
        return UserDefaults.standard.bool(forKey: label)
    }
    
    func checkGameComplete() -> Bool {
        let apple = UserDefaults.standard.bool(forKey: "Apple")
        let banana = UserDefaults.standard.bool(forKey: "Banana")
        let beer = UserDefaults.standard.bool(forKey: "Beer")
        let sunglasses = UserDefaults.standard.bool(forKey: "Sunglasses")
        return apple && beer && banana && sunglasses
    }
}

extension ViewController: LuminaDelegate {
    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
        guard let bestPrediction = predictions?.first?.predictions?.first else {
            return
        }
        if bestPrediction.confidence > Float(0.8) {
            self.textPrompt = bestPrediction.name
            if !alreadyFound(label: bestPrediction.name) {
                save(label: bestPrediction.name)
                if checkGameComplete() {
                    Fireworks.show(for: self.view, at: self.view.center, with: .red)
                    // show fireworks
                }
            }
        } else {
            self.textPrompt = ""
        }
    }
    
    func dismissed(controller: LuminaViewController) {
        clear()
    }
}
