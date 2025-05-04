
# Xcode > Product > Build Documentationでローカルに生成して確認
# DocumentからExportしてプロジェクトルートにObservableUIKit.doccarchiveに保存
# それからmakeを実行する

.PHONY: docc
docc:
	./scripts/build_docs.sh
