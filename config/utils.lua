-- =============================================================================
-- Utility Functions for N4N
-- =============================================================================

local M = {}

-- Setup key bindings
function M.setup_keybindings()
  -- Leader key mappings
  vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>e', ':e!<CR>', { noremap = true, silent = true })
  
  -- Clinical shortcuts
  vim.api.nvim_set_keymap('n', '<leader>cn', ':lua require("config.clinical").new_note()<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>ct', ':lua require("config.templates").show_templates()<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>ca', ':lua require("config.abbreviations").expand()<CR>', { noremap = true })
  
  -- Navigation
  vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })
  
  -- Quick save
  vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', { noremap = true, silent = true })
  
  -- Split windows
  vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>h', ':split<CR>', { noremap = true, silent = true })
end

-- Format clinical time
function M.format_time()
  return os.date("%Y-%m-%d %H:%M")
end

-- Format patient info
function M.format_patient_info(patient_id, name, room)
  return string.format("Patient: %s | Name: %s | Room: %s | Time: %s", 
    patient_id or "N/A", name or "N/A", room or "N/A", M.format_time())
end

return M