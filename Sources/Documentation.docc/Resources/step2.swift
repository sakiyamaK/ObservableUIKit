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
    }
}
