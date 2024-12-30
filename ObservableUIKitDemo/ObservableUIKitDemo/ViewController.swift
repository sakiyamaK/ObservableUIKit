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
@MainActor
final class TestData {
    var color: UIColor = .green
    var rotate: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var title: String?
    var loading: Bool = false
    
    func fetch() {
        Task {
            loading = true
            // サブスレッドで2秒待つ
            await Task {
                try? await Task.sleep(for: .seconds(2))
            }.value
            loading = false
        }
    }
}

final class ViewController: UIViewController {
    
    private var testData: TestData!

    private let testView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let testLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()

    init(testData: TestData) {
        super.init(nibName: nil, bundle: nil)
        self.testData = testData
    }
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.widthAnchor.constraint(equalToConstant: 100),
            testView.heightAnchor.constraint(equalToConstant: 100),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.view.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.heightAnchor.constraint(equalToConstant: 100),
            testLabel.centerXAnchor.constraint(equalTo: testView.centerXAnchor),
            testLabel.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: 20)
        ])

        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: testView.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: 20)
        ])

        track()
        update()
    }
    
    func track() {
        // UIViewの各パラメータを監視
        testView.observation(tracking: {[weak self] in
            self!.testData.color
        }, onChange: { view, color in
            view.backgroundColor = color
        }).observation(tracking: {[weak self] in
            self!.testData.cornerRadius
        }, onChange: { view, cornerRadius in
            view.layer.cornerRadius = cornerRadius
        }).observation(tracking: {[weak self] in
            self!.testData.rotate
        }, onChange: { view, angle in
            view.transform = .init(rotationAngle: angle)
        })
        
        // UILabelの各パラメータを監視
        testLabel.observation(tracking: {[weak self] in
            self!.testData.title ?? "default"
        }, onChange: { label, title in
            label.text = title
        }).observation(tracking: {[weak self] in
            self!.testData.color
        }, onChange: { label, textColor in
            label.textColor = textColor
        })
        
        // UIActivityIndicatorのパラメータを監視
        indicator.observation {[weak self] in
            self!.testData.loading
        } onChange: { indicator, loading in
            if loading {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }

    }
    
    // 監視対象のデータを更新
    func update() {
        Task {
            
            testData.fetch()

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


#Preview {
    ViewController()
}
