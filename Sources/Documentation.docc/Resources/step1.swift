import UIKit
import ObservableUIKit

// 監視対象のデータ
@Observable
final class TestData {
    var color: UIColor = .green
    var rotate: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var title: String?
}
