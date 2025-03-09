-- 基本的な設定
local M = {}

M.setup = function()
  -- 行番号を表示
  vim.opt.number = true
  -- 相対行番号を有効化（必要なら）
  -- vim.opt.relativenumber = true

  -- マウスモードを有効化（スプリットのリサイズなどに便利）
  vim.opt.mouse = 'a'

  -- ステータスラインのモード表示を無効化（既にステータスラインに表示されるため）
  vim.opt.showmode = false

  -- クリップボードをOSと同期
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)

  -- 自動インデント
  vim.opt.breakindent = true

  -- アンドゥ履歴を保存
  vim.opt.undofile = true

  -- 大文字を含む検索時はケースセンシティブ
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- サインカラム（Git変更マークなど）を常に表示
  vim.opt.signcolumn = 'yes'

  -- 更新時間を短縮
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300

  -- スプリットのデフォルト動作を設定
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- 特定の不可視文字を表示
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- 置換プレビューをリアルタイムで表示
  vim.opt.inccommand = 'split'

  -- カーソル行をハイライト
  vim.opt.cursorline = true

  -- カーソルの上下に最低10行の余白を確保
  vim.opt.scrolloff = 10
end

return M
