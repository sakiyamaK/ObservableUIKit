//
//  ViewController.swift
//  ObservableUIKitDemo
//
//  Created by sakiyamaK on 2023/10/05.
//

import UIKit
import ObservableUIKit

// 監視対象のデータ
@Observable
class TestData {
    var color: UIColor = .green
    var rotate: CGFloat = 0
    var cornerRadius: CGFloat = 0
    
    var title: String?
}

class ViewController: UIViewController {
    
    let testData = TestData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIView(frame: .zero)
        
        self.view.addSubview(testView)
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testView.widthAnchor.constraint(equalToConstant: 100),
            testView.heightAnchor.constraint(equalToConstant: 100),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])

        let testLabel = UILabel(frame: .zero)
        
        self.view.addSubview(testLabel)
        
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testLabel.heightAnchor.constraint(equalToConstant: 100),
            testLabel.centerXAnchor.constraint(equalTo: testView.centerXAnchor),
            testLabel.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: 20)
        ])

        track()
        update()
    }
    
    func track() {
        
        let testView: UIView = self.view.subviews.first!
        let testLabel: UILabel = self.view.subviews.first(where: { $0 is UILabel}) as! UILabel

        // UIViewの各パラメータを監視
        testView.observation(keyPath: \.backgroundColor) { [weak self] in
            self?.testData.color
        }.observation(keyPath: \.layer.cornerRadius) { [weak self] in
            self?.testData.cornerRadius ?? 0
        }.observation(keyPath: \.transform) { [weak self] in
            let angle = self?.testData.rotate ?? 0
            return .init(rotationAngle: angle)
        }
        
        // UILabelの各パラメータを監視
        testLabel.observation(keyPath: \.text) { [weak self] in
            self?.testData.title ?? "default"
        }.observation(keyPath: \.textColor) { [weak self] in
            self?.testData.color
        }
    }
    
    // 監視対象のデータを更新
    func update() {
        Task {
            try await Task.sleep(for: .seconds(1.0))
            testData.color = .red
            testData.title = "change 1"

            try await Task.sleep(for: .seconds(1.0))
            testData.color = .blue
            testData.rotate = 10.0 * 180.0 / Double.pi
            testData.cornerRadius = 20
            testData.title = "change 2"
            
            try await Task.sleep(for: .seconds(1.0))
            testData.color = .black
            testData.rotate = 20.0 * 180.0 / Double.pi
            testData.cornerRadius = 30
            testData.title = "change 3"

            try await Task.sleep(for: .seconds(1.0))
            testData.color = .red
            testData.cornerRadius = 50
            testData.title = "change 4"

        }

    }
}

