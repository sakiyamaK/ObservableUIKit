//
//  EnvironmentViewController.swift
//  ObservableUIKitDemo
//
//  Created by sakiyamaK on 2025/08/06.
//

import UIKit
import ObservableUIKit

// SwiftUIのオリジナルの環境変数を普通に用意
import SwiftUI
extension EnvironmentValues {
    @Entry var fontColor: UIColor = .systemRed
}

// 環境変数から値を取得するカスタムビュー
final class CustomView: UIView {

    private let label: UILabel = {
        let label = UILabel(frame: .null)
        label.text = "カスタムビューの中の文字列だよ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setValue() {
        // 環境変数から値を取得
        self.label.read(environment: \.fontColor, to: \.textColor)
    }

    deinit {
        print("CustomView deinit")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init () {
        super.init(frame: .null)

        layout()
        setValue()
    }

    private func layout() {

        self.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.label.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.label.bottomAnchor),
        ])

        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}

final class EnvironmentViewController: UIViewController {

    // 環境変数に登録する値
    @UIKitState private var fontColorValue: UIColor = EnvironmentValues().fontColor
    @UIKitState private var colorScheme: ColorScheme = EnvironmentValues().colorScheme

    private func setValue() {

        // 環境変数とUIKitState属性のパラメータを連結
        // @UIKitState var fontColorValue なら _fontColorValue と指定することに注意
        self.view
            .environment(\.fontColor, state: _fontColorValue)
            .environment(\.colorScheme, state: _colorScheme)

        // 環境変数から値を読み込む
        // クロージャ形式で自由に記述できる
        self.view.read(environment: \.colorScheme) { view, colorScheme in
            view.backgroundColor = colorScheme == .dark ? .darkGray : .systemBackground
        }
        // 値を代入するだけならkeyPathで指定できる
        self.label.read(environment: \.fontColor, to: \.textColor)
    }

    deinit {
        print("EnvironmentViewController deinit")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    private let label: UILabel = {
        let label = UILabel(frame: .null)
        label.text = "EnvironmentViewControllerの中の文字列だよ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 内部のLabelが環境変数から値を取得するCustomView
    private let customView: CustomView = {
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    private lazy var fontColorChangeButton: UIButton = {
        UIButton(configuration: .plain(), primaryAction: .init(title: "タップして文字色を変える", handler: {[weak self] _ in

            self!.fontColorValue = switch self!.fontColorValue {
            case .systemRed:
                    .systemCyan
            case .systemCyan:
                    .systemGreen
            case .systemGreen:
                    .systemRed
            default:
                    .systemRed
            }
        }))
    }()

    private lazy var colorSchemeChangeButton: UIButton = {
        UIButton(configuration: .plain(), primaryAction: .init(title: "タップしてColor Schemeを変える", handler: {[weak self] _ in
            // 監視対象のデータを更新
            self!.colorScheme = self!.colorScheme == .light ? .dark : .light
        }))
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setValue()
    }

    private func layout() {
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(customView)
        stackView.setCustomSpacing(30, after: customView)
        stackView.addArrangedSubview(fontColorChangeButton)
        stackView.addArrangedSubview(colorSchemeChangeButton)
    }


}


#Preview {
    EnvironmentViewController()
//        .environment(\.fontColor, .systemBlue)
//        .environment(\.colorScheme, value: .light)
}
