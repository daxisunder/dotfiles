return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Disable and enable cursors.
    set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle Cursors" })

    -- Add or skip cursor above/below the main cursor.
    set({ "n", "x" }, "<up>", function()
      mc.lineAddCursor(-1)
    end, { desc = "Add Cursor Above" })
    set({ "n", "x" }, "<down>", function()
      mc.lineAddCursor(1)
    end, { desc = "Add Cursor Below" })
    set({ "n", "x" }, "<localleader><up>", function()
      mc.lineSkipCursor(-1)
    end, { desc = "Skip Cursor Above" })
    set({ "n", "x" }, "<localleader><down>", function()
      mc.lineSkipCursor(1)
    end, { desc = "Skip Cursor Below" })

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<localleader>n", function()
      mc.matchAddCursor(1)
    end, { desc = "Add Cursor Next Match" })
    set({ "n", "x" }, "<localleader>s", function()
      mc.matchSkipCursor(1)
    end, { desc = "Skip Cursor Next Match" })
    set({ "n", "x" }, "<localleader>N", function()
      mc.matchAddCursor(-1)
    end, { desc = "Add Cursor Previous Match" })
    set({ "n", "x" }, "<localleader>S", function()
      mc.matchSkipCursor(-1)
    end, { desc = "Skip Cursor Previous Match" })

    -- Add a cursor for all matches of cursor word/selection in the document.
    set({ "n", "x" }, "<localleader>A", mc.matchAllAddCursors, { desc = "Add Cursors To All Matches" })

    -- Add a cursor and jump to the next/previous search result.
    set("n", "<localleader>/n", function()
      mc.searchAddCursor(1)
    end, { desc = "Add Cursor To Next Search Result" })
    set("n", "<localleader>/N", function()
      mc.searchAddCursor(-1)
    end, { desc = "Add Cursor To Previous Search Result" })

    -- Jump to the next/previous search result without adding a cursor.
    set("n", "<localleader>/s", function()
      mc.searchSkipCursor(1)
    end, { desc = "Skip To Next Search Result" })
    set("n", "<localleader>/S", function()
      mc.searchSkipCursor(-1)
    end, { desc = "Skip To Previous Search Result" })

    -- Add a cursor to every search result in the buffer.
    set("n", "<localleader>/A", mc.searchAllAddCursors, { desc = "Add Cursors To All Search Results" })

    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add Cursor With Mouse" })
    set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Add Cursors With Mouse Drag" })
    set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Clear Cursors With Mouse Release" })

    -- bring back cursors if you accidentally clear them
    set("n", "<localleader>gv", mc.restoreCursors, { desc = "Restore Cursors" })

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Select Previous Cursor" })
      layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "SelectNext Cursor" })

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<localleader>x", mc.deleteCursor, { desc = "Delete Main Cursor" })

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Enable/Clear Cursors" })
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
