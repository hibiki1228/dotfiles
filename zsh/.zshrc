# メイン.zshrcファイル
# 分割された設定ファイルを読み込む構造

# .zshディレクトリの設定
# 実際のファイルパスを指定
ZSH_CONFIG_DIR="$HOME/dotfiles/zsh/.zsh"

# 存在するすべての設定ファイルを読み込む
for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
  if [ -f "$config_file" ]; then
    source "$config_file"
  fi
done

# 追加の設定やカスタマイズがあればここに記述

