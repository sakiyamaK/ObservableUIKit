rm -rf ./docs

xcrun docc process-archive transform-for-static-hosting \
    ObservableUIKit.doccarchive \
    --output-path docs/ \
    --hosting-base-path ObservableUIKit/

touch ./docs/.nojekyll