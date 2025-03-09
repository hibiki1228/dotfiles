# ---------------------------
# Oh My Zsh 基本設定
# ---------------------------
# Oh My Zshのインストールパスを設定
export ZSH="$HOME/.oh-my-zsh"

# テーマの設定 - agnosterはカラフルでGit情報なども表示する高機能テーマ
ZSH_THEME="agnoster"

# 使用するプラグインの設定 - gitプラグインのみ有効
# gitプラグインはGitコマンドの補完や便利なエイリアスを提供
plugins=(git)

# Oh My Zshを読み込んで有効化
source $ZSH/oh-my-zsh.sh

