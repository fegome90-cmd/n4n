-- =============================================================================
-- Medical Abbreviations and Auto-expansion for N4N
-- =============================================================================

local M = {}

-- Medical abbreviations dictionary
local abbreviations = {
  -- Common nursing abbreviations
  ["pt"] = "patient",
  ["pts"] = "patients",
  ["rx"] = "prescription",
  ["dx"] = "diagnosis",
  ["tx"] = "treatment",
  ["hx"] = "history",
  ["sxs"] = "symptoms",
  ["vs"] = "vital signs",
  ["vss"] = "vital signs stable",
  
  -- Vital signs
  ["bp"] = "blood pressure",
  ["hr"] = "heart rate",
  ["pulse"] = "heart rate",
  ["temp"] = "temperature",
  ["o2"] = "oxygen",
  ["sat"] = "saturation",
  ["spo2"] = "oxygen saturation",
  ["rr"] = "respiratory rate",
  ["resp"] = "respiratory",
  
  -- Routes of administration
  ["po"] = "by mouth",
  ["pr"] = "per rectum",
  ["iv"] = "intravenous",
  ["im"] = "intramuscular",
  ["sc"] = "subcutaneous",
  ["sl"] = "sublingual",
  ["sliding"] = "sliding scale",
  
  -- Time indicators
  ["am"] = "morning",
  ["pm"] = "evening",
  ["noc"] = "night",
  ["bid"] = "twice daily",
  ["tid"] = "three times daily",
  ["qid"] = "four times daily",
  ["q"] = "every",
  ["qd"] = "daily",
  ["prn"] = "as needed",
  ["stat"] = "immediately",
  ["ac"] = "before meals",
  ["pc"] = "after meals",
  
  -- Common medical terms
  ["med"] = "medication",
  ["meds"] = "medications",
  ["adm"] = "admission",
  ["dis"] = "discharge",
  ["d/c"] = "discharge",
  ["elop"] = "elopement",
  ["fall"] = "patient fall",
  ["f/c"] = "foley catheter",
  ["npo"] = "nothing by mouth",
  ["nsg"] = "nursing",
  
  -- Patient care
  ["adl"] = "activities of daily living",
  ["i&o"] = "intake and output",
  ["cna"] = "certified nursing assistant",
  ["rn"] = "registered nurse",
  ["lpn"] = "licensed practical nurse",
  ["np"] = "nurse practitioner",
  ["md"] = "physician",
  ["do"] = "doctor of osteopathy",
  
  -- Assessments
  ["neg"] = "negative",
  ["pos"] = "positive",
  ["normal"] = "within normal limits",
  ["wnl"] = "within normal limits",
  ["abd"] = "abdomen",
  ["cardiac"] = "cardiovascular",
  ["neuro"] = "neurological",
  ["resp"] = "respiratory",
  
  -- Care measures
  ["vs q"] = "vital signs every",
  ["i&o"] = "intake and output",
  ["dress"] = "dressing change",
  ["wound"] = "wound care",
  ["foley"] = "foley catheter",
  ["ivf"] = "intravenous fluids"
}

-- Expand abbreviation
function M.expand()
  local current_line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_part = current_line:sub(1, cursor_pos[2])
  
  -- Find the last word
  local last_word = line_part:match("(%S+)$")
  if last_word and abbreviations[last_word] then
    -- Get the position to replace
    local start_pos = #line_part - #last_word
    
    -- Replace the word
    local new_line = current_line:sub(1, start_pos) .. abbreviations[last_word] .. current_line:sub(#line_part + 1)
    vim.api.nvim_set_current_line(new_line)
    
    -- Move cursor to end of expanded word
    vim.api.nvim_win_set_cursor(0, { cursor_pos[1], start_pos + #abbreviations[last_word] })
  end
end

-- Setup auto-abbreviations for insert mode
function M.setup_abbreviations()
  for abbr, expansion in pairs(abbreviations) do
    vim.cmd(string.format('iabbrev <buffer> %s %s', abbr, expansion))
  end
end

return M