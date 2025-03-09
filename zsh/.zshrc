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

# ---------------------------
# Docker関連エイリアス
# ---------------------------
# Docker Composeコマンドの短縮エイリアス
alias dc='docker-compose'          # docker-compose
alias dcu='docker-compose up -d'   # デタッチモードでコンテナを起動
alias dcd='docker-compose down'    # コンテナを停止・削除
alias dsh='docker-compose exec'    # 実行中のコンテナでコマンドを実行

# ---------------------------
# エディタ関連エイリアス
# ---------------------------
alias v='vim'     # Vimエディタを起動
alias n='nvim'    # Neovimエディタを起動

# ---------------------------
# 設定ファイル関連エイリアス
# ---------------------------
alias sz='source ~/.zshrc'  # .zshrcファイルを再読み込み

# ---------------------------
# プロンプト表示設定
# ---------------------------
# agnosterテーマのユーザー名/ホスト名表示を無効化
prompt_context() { }

# ---------------------------
# PATH設定
# ---------------------------
# nodebrewでインストールしたNode.jsのバイナリをPATHに追加
export PATH=$HOME/.nodebrew/current/bin:$PATH

# ---------------------------
# コマンド実行時の自動改行設定
# ---------------------------
# コマンド実行後に改行を追加する関数
add_newline() {
  if [[ -z $PS1_NEWLINE_LOGIN ]]; then
    PS1_NEWLINE_LOGIN=true  # 初回ログイン時はフラグを設定
  else
    printf '\n'             # 2回目以降は改行を出力
  fi
}

# コマンド実行前に毎回呼ばれるフック関数で改行を追加
precmd() {
  add_newline
}

# ---------------------------
# コマンド履歴検索設定（peco）
# ---------------------------
# pecoを使ったインタラクティブなコマンド履歴検索機能
function peco-select-history() {
  local tac
  # システムによってリバース表示コマンドを選択
  if which tac > /dev/null; then
    tac="tac"  # GNU系
  else
    tac="tail -r"  # BSD系
  fi
  
  # 履歴を逆順に取得してpecoで検索
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  
  # カーソルを行末に移動
  CURSOR=$#BUFFER
  zle clear-screen
}

# Zshのラインエディタに機能を登録
zle -N peco-select-history
# Ctrl+rキーに履歴検索機能をバインド
bindkey '^r' peco-select-history

# ---------------------------
# 追加プラグイン
# ---------------------------
# コマンド履歴のサブストリング検索機能（上下キーで部分一致検索）
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# 高度な自動補完機能
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

