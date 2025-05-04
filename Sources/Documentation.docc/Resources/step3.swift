import UIKit
import ObservableUIKit

final class ViewController: UIViewController {

    /*
     前回と同じ
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewをaddsubviewしておきます


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
