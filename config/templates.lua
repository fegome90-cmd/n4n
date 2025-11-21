-- =============================================================================
-- Clinical Templates for N4N
-- =============================================================================

local M = {}

-- Load template
function M.load_template()
  local template_choice = vim.fn.input("Select template: ")
  
  if template_choice == "1" then
    M.patient_note()
  elseif template_choice == "2" then
    M.care_plan()
  elseif template_choice == "3" then
    M.assessment()
  end
end

-- Show available templates
function M.show_templates()
  print("\n=== Clinical Templates ===")
  print("1. Patient Note Template")
  print("2. Care Plan Template") 
  print("3. Assessment Template")
  print("4. Discharge Summary")
  print("5. Medication Record")
  print("\nUsage: :lua require('config.templates').load_template()")
end

-- Patient note template
function M.patient_note()
  local template = string.format([[
=== PATIENT NOTE ===
Date: %s

Patient Information:
- Patient ID: 
- Full Name: 
- Room: 
- Age: 
- MRN: 

Chief Complaint:

History of Present Illness:

Vital Signs:
- Blood Pressure: / mmHg
- Heart Rate: bpm
- Temperature: °F
- O2 Saturation: %% on 
- Respiratory Rate: breaths/min
- Pain Level: /10
- Weight: lbs/kg
- Height: inches/cm

Physical Assessment:
- General Appearance: 
- Neurological: 
- Cardiovascular: 
- Respiratory: 
- Gastrointestinal: 
- Genitourinary: 
- Extremities: 

Assessment:

Plan of Care:

Medications:
- Medication: 
  Dosage: 
  Route: 
  Frequency: 
  Reason: 

Nursing Interventions:

Patient/Family Education:

Next Assessment Due: 

Nurse Signature: 
]],
    require('config.utils').format_time())
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, '\n'))
  vim.api.nvim_win_set_cursor(0, {1, 0})
end

-- Care plan template
function M.care_plan()
  local template = [[
=== NURSING CARE PLAN ===
Date: 

Patient: 
Room: 
Primary Diagnosis: 

=== NURSING DIAGNOSES ===
1. [NANDA-I Diagnosis Statement]
   Related to: 
   As evidenced by: 

=== OUTCOMES ===
Goal: 
Time frame: 
Expected outcomes:
- 
- 
- 
- 

=== INTERVENTIONS ===
Nursing interventions:
1. 
2. 
3. 
4. 

=== EVALUATION ===
Date: 
Goal met: Yes / Partial / No
Evaluation notes:

===

]]
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, '\n'))
end

-- Assessment template
function M.assessment()
  local template = [[
=== PATIENT ASSESSMENT ===
Date: 
Time: 
Nurse: 

=== PATIENT OVERVIEW ===
Patient ID: 
Room: 
Age: 
Primary Diagnosis: 
Code Status: 
Diet: 
Activity: 

=== SYSTEMS ASSESSMENT ===

Neurological:
- Level of Consciousness: 
- Orientation: 
- Pupils: 
- Motor Function: 
- Speech: 
- Pain: /10

Cardiovascular:
- Heart Sounds: 
- Heart Rate: bpm
- Blood Pressure: / mmHg
- Peripheral Pulses: 
- Edema: 
- Capillary Refill: 

Respiratory:
- Breath Sounds: 
- Respiratory Rate: breaths/min
- O2 Saturation: %% on 
- O2 Method: 
- Cough: 
- Sputum: 

Gastrointestinal:
- Abdomen: 
- Bowel Sounds: 
- Last BM: 
- Nausea/Vomiting: 
- Appetite: 
- Dietary Intake: 

Genitourinary:
- Urine Output: 
- Urine Color/Character: 
- Incontinence: 
- Dialysis: 

Musculoskeletal:
- Mobility: 
- Gait: 
- Range of Motion: 
- Strength: 

Skin:
- Skin Color: 
- Temperature: 
- Integrity: 
- Wounds: 
- Pressure Areas: 

=== PRIORITY CONCERNS ===
1. 
2. 
3. 

=== PLAN ===
Next Assessment: 
Notify Provider for: 

Nurse Signature: 

===
]]
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, '\n'))
end

return M