--------------------------------------------------
-- 基本設定
--------------------------------------------------
-- リーダーキーを<space>に設定
-- See `:help mapleader`
-- 注意: プラグインがロードされる前に設定する必要があります（そうしないと間違ったリーダーキーが使用される）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Fontがインストールされ、ターミナルで選択されている場合はtrueに設定
vim.g.have_nerd_font = false

--------------------------------------------------
-- オプション設定
--------------------------------------------------
-- See `:help vim.opt`
-- 注意: これらのオプションは好みに応じて変更できます！
-- より多くのオプションについては `:help option-list` を参照してください

-- 基本設定を適用
require('config.basic_config').setup()

--------------------------------------------------
-- キーマッピング
--------------------------------------------------
-- 基本的なキーマッピング設定
require('config.alias').setup()

--------------------------------------------------
-- 自動コマンド設定
--------------------------------------------------
-- `:help lua-guide-autocommands` を参照

-- ヤンク（コピー）時にハイライト表示
-- 通常モードで `yap` で試してみてください
-- `:help vim.highlight.on_yank()` を参照
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'ヤンク（コピー）時にテキストをハイライト',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--------------------------------------------------
-- プラグイン管理設定
--------------------------------------------------
-- `lazy.nvim` プラグインマネージャのインストール
-- 詳細は `:help lazy.nvim.txt` または https://github.com/folke/lazy.nvim を参照
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- プラグイン定義とセットアップ
--------------------------------------------------
require('lazy').setup({
  --------------------------------------------------
  -- 基本的なユーティリティプラグイン
  --------------------------------------------------

  -- タブストップとシフト幅を自動的に検出
  'tpope/vim-sleuth',

  -- Gitサインと変更管理ユーティリティを追加
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  --------------------------------------------------
  -- キーバインド表示プラグイン
  --------------------------------------------------
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- VimEnterイベントでロード
    opts = {
      -- キーを押してからwhich-keyが開くまでの遅延（ミリ秒）
      -- この設定はvim.opt.timeoutlenとは独立しています
      delay = 0,
      icons = {
        -- Nerd Fontがある場合はアイコンマッピングをtrueに設定
        mappings = vim.g.have_nerd_font,
        -- Nerd Fontを使用している場合: icons.keysを空のテーブルに設定すると、
        -- which-key.nvimのデフォルトNerd Fontアイコンが使用されます。
        -- そうでない場合は、文字列テーブルを定義します。
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- 既存のキーチェーンをドキュメント化
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  --------------------------------------------------
  -- ファジーファインダー (Telescope)
  --------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- プラグインがインストール/更新されたときに実行するコマンド
        build = 'make',
        -- プラグインをインストールするかどうかを決定する条件
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- きれいなアイコン用（Nerd Fontが必要）
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescopeの設定
      -- `:help telescope` と `:help telescope.setup()` を参照
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Telescope拡張機能のロード
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- キーマッピングの設定
      -- `:help telescope.builtin` を参照
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- デフォルトの動作とテーマをオーバーライドする例
      vim.keymap.set('n', '<leader>/', function()
        -- テーマ、レイアウトなどを変更するための追加設定をTelescopeに渡せます
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- 追加の設定オプションを渡すこともできます
      -- 特定のキーについては `:help telescope.builtin.live_grep()` を参照
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Neovim設定ファイルを検索するためのショートカット
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  --------------------------------------------------
  -- Lua LSP開発支援
  --------------------------------------------------
  {
    -- `lazydev` はNeovim設定、ランタイム、プラグイン用にLua LSPを設定
    -- Neovim APIの補完、アノテーション、シグネチャに使用
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- `vim.uv` という単語が見つかったときにluvitタイプをロード
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  --------------------------------------------------
  -- LSP設定
  --------------------------------------------------
  {
    -- メインLSP設定
    'neovim/nvim-lspconfig',
    dependencies = {
      -- LSPと関連ツールをNeovimのstdpathに自動的にインストール
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- LSPの便利なステータス更新
      { 'j-hui/fidget.nvim', opts = {} },

      -- nvim-cmpによって提供される追加機能
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- LSPがバッファにアタッチされたときに実行される関数
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- LSP固有のマッピングを簡単に定義するためのヘルパー関数
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- カーソル下の単語の定義にジャンプ
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- カーソル下の単語の参照を検索
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- カーソル下の単語の実装にジャンプ
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- カーソル下の単語の型定義にジャンプ
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- 現在のドキュメント内のすべてのシンボルをファジー検索
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- 現在のワークスペース内のすべてのシンボルをファジー検索
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- カーソル下の変数の名前を変更
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- コードアクションを実行
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- 宣言にジャンプ（定義とは異なる）
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Neovimのナイトリーとステーブルバージョンの違いを解決する関数
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- カーソル下の単語の参照をハイライト表示する自動コマンド
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- インレイヒントを切り替えるキーマップを作成（言語サーバーがサポートしている場合）
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- 診断設定
      -- `:help vim.diagnostic.Opts` を参照
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSPサーバーとクライアントが互いにサポートする機能を通信できるようにする
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- 言語サーバーの有効化
      -- 必要に応じて自由にLSPを追加/削除できます
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- 騒がしい `missing-fields` 警告を無視するには以下をトグルできます
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- 上記のサーバーとツールがインストールされていることを確認
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Luaコードのフォーマットに使用
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- mason-lspconfigのセットアップ
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- 明示的に空のテーブルを設定
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  --------------------------------------------------
  -- コードフォーマット
  --------------------------------------------------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- 標準化されたコーディングスタイルがない言語に対して
        -- "format_on_save lsp_fallback"を無効化
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- 複数のフォーマッタを順番に実行することも可能
        -- python = { "isort", "black" },
        --
        -- リストから利用可能な最初のフォーマッタを実行するには 'stop_after_first' を使用
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  --------------------------------------------------
  -- 自動補完
  --------------------------------------------------
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- スニペットエンジンと関連nvim-cmpソース
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- スニペットの正規表現サポートにはビルドステップが必要
          -- このステップは多くのWindows環境ではサポートされていません
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` には様々な定義済みスニペットが含まれています
          -- 個別の言語/フレームワーク/プラグインスニペットについては
          -- READMEを参照: https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- その他の補完機能を追加
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      -- `:help cmp` を参照
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- これらのマッピングが選ばれた理由を理解するには
        -- `:help ins-completion` を読む必要があります
        mapping = cmp.mapping.preset.insert {
          -- [n]ext項目を選択
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- [p]revious項目を選択
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- ドキュメントウィンドウを[b]ack / [f]orwardにスクロール
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- 補完を承認([y]es)
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- より伝統的な補完キーマップを好む場合は
          -- 以下の行をコメント解除できます
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- nvim-cmpから手動で補完をトリガー
          ['<C-Space>'] = cmp.mapping.complete {},

          -- スニペット展開内を移動するためのキーマップ
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            -- lazydevが推奨するようにLuaLSの補完をスキップするためにgroup_indexを0に設定
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },

  --------------------------------------------------
  -- カラースキーム設定
  --------------------------------------------------
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- 他のスタートプラグインより先にロードするために高い優先度を設定
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- コメントのイタリック無効化
        },
      }

      -- カラースキームをロード
      -- 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'など
      -- 他のスタイルもロード可能
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  --------------------------------------------------
  -- コメント内のTODOなどをハイライト
  --------------------------------------------------
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  --------------------------------------------------
  -- mini.nvim（小さな独立したプラグイン/モジュールのコレクション）
  --------------------------------------------------
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      -- 例:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- 囲み（括弧、引用符など）の追加/削除/置換
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- シンプルで使いやすいステータスライン
      local statusline = require 'mini.statusline'
      -- Nerd Fontがある場合はuse_iconsをtrueに設定
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- デフォルトの動作をオーバーライドしてステータスラインのセクションを設定できます
      -- 例えば、カーソル位置のセクションをLINE:COLUMNに設定
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- その他の機能については https://github.com/echasnovski/mini.nvim を参照
    end,
  },

  --------------------------------------------------
  -- Treesitter設定
  --------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- プラグインのインストール時/更新時にTreesitterをアップデート
    main = 'nvim-treesitter.configs', -- optsで設定するメインモジュールを指定
    -- Treesitterの設定 (`:help nvim-treesitter`参照)
    opts = {
      -- インストールする言語パーサーの指定
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- 未インストールの言語を自動的にインストール
      auto_install = true,
      -- 構文強調表示の有効化
      highlight = {
        enable = true,
        -- 一部の言語（Rubyなど）はVimの正規表現ハイライトシステムに依存しているため、
        -- インデントの問題が発生した場合はこのリストに言語を追加
        additional_vim_regex_highlighting = { 'ruby' },
      },
      -- インデントの有効化と特定言語での無効化
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- 注意: Treesitterには他にも便利なモジュールがあります:
    -- - インクリメンタル選択: 標準搭載 (`:help nvim-treesitter-incremental-selection-mod`参照)
    -- - コンテキスト表示: https://github.com/nvim-treesitter/nvim-treesitter-context
    -- - テキストオブジェクト: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  --------------------------------------------------
  -- Kickstartプラグイン（追加機能）
  --------------------------------------------------
  -- デバッグ機能を追加（DAP - Debug Adapter Protocol）
  require 'kickstart.plugins.debug',

  -- インデントガイドラインの表示
  require 'kickstart.plugins.indent_line',

  -- コードリンター（静的解析ツール）の設定
  require 'kickstart.plugins.lint',

  -- 自動で括弧を閉じる機能
  require 'kickstart.plugins.autopairs',

  -- ファイルエクスプローラーツリービュー
  require 'kickstart.plugins.neo-tree',

  -- Gitの変更表示（行の追加、変更、削除などを示す）
  require 'kickstart.plugins.gitsigns',

  --------------------------------------------------
  -- カスタムプラグイン
  --------------------------------------------------
  -- `lua/custom/plugins/*.lua`から独自のプラグインや設定を自動的に追加
  -- モジュール化された設定を容易に管理するための方法
  { import = 'custom.plugins' },

  -- プラグイン仕様の詳細情報は `:help lazy.nvim-🔌-plugin-spec` を参照
  -- または、Telescopeを使用して検索:
  -- ノーマルモードで `<space>sh` を入力し、`lazy.nvim-plugin` と入力
  -- `<space>sr` で直前のTelescope検索を続行できます
}, {
  --------------------------------------------------
  -- Lazy.nvim UI設定
  --------------------------------------------------
  ui = {
    -- Nerd Fontを使用している場合は空のテーブルを設定し、
    -- デフォルトのlazy.nvimで定義されたNerd Fontアイコンを使用
    -- そうでない場合はユニコードアイコンのテーブルを定義
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
