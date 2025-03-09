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

