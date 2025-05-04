import UIKit
import ObservableUIKit

final class ViewController: UIViewController {

    // 監視対象のデータ
    private var testData: TestData
    // 監視対象のプリミティブ型
    @UIKitState private var isLoading: Bool = true

    init(testData: TestData = TestData()) {
        self.testData = testData
        super.init(nibName: nil, bundle: nil)
    }

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewをaddsubviewしておきます

        /*
         ここから追記
         */

        // UIViewの各パラメータを監視します
        testView.tracking {[weak self] in
            self?.testData.cornerRadius
        } onChange: { view, cornerRadius in
            view.layer.cornerRadius = cornerRadius
        }.tracking {[weak self] in
            self?.testData.rotate
        } onChange: { view, angle in
            view.transform = .init(rotationAngle: angle)
        }.trackingOptional {[weak self] in
            self?.testData.color
        } onChange: { view, color in
            view.backgroundColor = color
        }

        // UILabelの各パラメータを監視
        testLabel.tracking {[weak self] in
            self?.testData.title ?? "default"
        } onChange: { label, title in
            label.text = title
        }.tracking {[weak self] in
            self?.testData.color
        } onChange: { label, textColor in
            label.textColor = textColor
        }

        // UIActivityIndicatorのパラメータを監視
        indicator.tracking {[weak self] in
            self!.isLoading
        } onChange: { indicator, loading in
            if loading {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
}
