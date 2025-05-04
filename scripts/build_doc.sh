rm -rf ./docs

xcrun docc convert ./ObservableUIKit.docc \
  --output-path ./docs \
  --transform-for-static-hosting \
  --hosting-base-path ObservableUIKit

touch ./docs/.nojekyll