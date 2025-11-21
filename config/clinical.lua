-- =============================================================================
-- Clinical-specific settings and functions
-- =============================================================================

local M = {}

-- Setup clinical environment
function M.setup()
  -- Clinical text settings
  vim.opt.spell = true
  vim.opt.spelllang = { "en_us", "medical" }
  
  -- Clinical abbreviations
  vim.cmd([[
    " Common medical abbreviations
    iabbrev pt patient
    iabbrev rx prescription
    iabbrev vs vital signs
    iabbrev bp blood pressure
    iabbrev hr heart rate
    iabbrev temp temperature
    iabbrev o2 oxygen
    iabbrev sat saturation
    iabbrev med medication
    iabbrev adm admission
    iabbrev dis discharge
    iabbrev stat immediately
    iabbrev prn as needed
    iabbrev qd daily
    iabbrev bid twice daily
    iabbrev tid three times daily
    iabbrev qid four times daily
    iabbrev noc night
    iabbrev am morning
    iabbrev pm evening
  ]])
end

-- Create new patient note
function M.new_note()
  local template = string.format([[
=== PATIENT NOTE ===
Date: %s

Patient Information:
- ID: 
- Name: 
- Room: 
- Age: 
- MRN: 

Chief Complaint:

Vital Signs:
- BP: / mmHg
- HR: bpm
- Temp: °F
- O2 Sat: %% on 
- Resp: breaths/min
- Pain: /10

Assessment:

Plan:

Nurse Signature: 
]],
    require('config.utils').format_time())
  
  local new_buffer = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(new_buffer)
  vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, vim.split(template, '\n'))
  
  -- Move to start of file
  vim.api.nvim_win_set_cursor(0, {1, 0})
end

-- Quick vital signs entry
function M.vital_signs()
  local time = require('config.utils').format_time()
  print(string.format("Recording vitals at %s", time))
  -- Implementation would open vital signs template
end

return M