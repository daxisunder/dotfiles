# restore.yazi

<!--toc:start-->

- [restore.yazi](#restoreyazi)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Linux](#linux)
  - [Usage](#usage)
  <!--toc:end-->

[Yazi](https://github.com/sxyazi/yazi) plugin to restore/recover latest deleted files/folders.

## Requirements

- [yazi >= v25.5.31](https://github.com/sxyazi/yazi)
- [trash-cli](https://github.com/andreafrancia/trash-cli)
  - If you have `Can't Get Trash Directory` error and running `trash-cli --volumes`
    in terminal throw `AttributeError: 'PrintVolumesList' object has no attribute 'run_action'`.
    Remove the old version of trash-cli and install newer version [How to install](https://github.com/andreafrancia/trash-cli?tab=readme-ov-file#the-easy-way).

## Installation

### Linux

```sh
git clone https://github.com/boydaihungst/restore.yazi ~/.config/yazi/plugins/restore.yazi
```

or

```sh
ya pkg add boydaihungst/restore
```

## Usage

> [!IMPORTANT]
> This plugin restores files and folders based on their deletion date and time.
> However, since Yazi deletes files in batches of approximately 1000\~2000, not all files in a large selection will have the same deletion timestamp.
> For example, if you select and delete 10,000 files, each batch of 1000\~2000 may have a different deletion time. This can result in only a partial restoration of your files (in the worst case, only the last 1000\~2000 files deleted).
> To resolve this, you may need to run the "restore" command multiple times until all desired files are recovered. For instance, to restore 10,000 files, you might have to execute the command up to 10 times.

1. Key binding

   - Add this to your `keymap.toml` (replace `keymap` with `prepend_keymap` if you don't want to replace all other keys. [Read more about keymap](https://yazi-rs.github.io/docs/configuration/keymap)):

     ```toml
     [mgr]
       keymap = [
         { on = "u", run = "plugin restore", desc = "Restore last deleted files/folders" },
         # or use "d + u" like me
         { on = ["d", "u"], run = "plugin restore", desc = "Restore last deleted files/folders" },

         # Select files/folders to restore. Input item index or range separated by comma:
         # - Restore a trashed file:
         #      What file to restore [0..4]: 4
         # - Restore multiple trashed files separated by comma, also support range:
         #      What file to restore [0..3]: 0-2, 3

         # Remove --overwrite if you don't want to overwrite existed files and this will abort restoring when there is existed file.
         { on = [ "d", "U" ], run = "shell --block -- clear && trash-restore --overwrite", desc = "Restore deleted file (Interactive)" },
         # ... Other keymaps
       ]
     ```

2. Configuration (Optional)

   - Default:

     ```lua
     require("restore"):setup({
         -- Set the position for confirm and overwrite dialogs.
         -- don't forget to set height: `h = xx`
         -- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
         position = { "center", w = 70, h = 40 }, -- Optional

         -- Show confirm dialog before restore.
         -- NOTE: even if set this to false, overwrite dialog still pop up
         show_confirm = true,  -- Optional

         -- colors for confirm and overwrite dialogs
         theme = { -- Optional
           -- Default using style from your flavor or theme.lua -> [confirm] -> title.
           -- If you edit flavor or theme.lua you can add more style than just color.
           -- Example in theme.lua -> [confirm]: title = { fg = "blue", bg = "green"  }
           title = "blue", -- Optional. This valid has higher priority than flavor/theme.lua

           -- Default using style from your flavor or theme.lua -> [confirm] -> content
           -- Sample logic as title above
           header = "green", -- Optional. This valid has higher priority than flavor/theme.lua

           -- header color for overwrite dialog
           -- Default using color "yellow"
           header_warning = "yellow", -- Optional
           -- Default using style from your flavor or theme.lua -> [confirm] -> list
           -- Sample logic as title and header above
           list_item = { odd = "blue", even = "blue" }, -- Optional. This valid has higher priority than flavor/theme.lua
         },
     })
     ```
