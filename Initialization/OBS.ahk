; -- These files are to separate out the initial variables needed into their own locations
; -- They're all loaded in near the top of the script

return_mode = 2 ; 1 = Exit program after execution, 2 = return and await input
gui_enabled = False ; Enables a gui that opens on start for control (exits app on gui close)

global offsets_offset_x
global offsets_offset_y

global topleft_origin_x := 1913
global topleft_origin_y := -1

global chat_x := topleft_origin_x
global chat_y := topleft_origin_y
global chat_w := 262
global chat_h := 1003

global events_x := topleft_origin_x + 246
global events_y := topleft_origin_y + 502
global events_w := 1050
global events_h := 501
global events_x_state2 := events_x 
global events_y_state2 := events_y - 502
global events_w_state2 := events_w
global events_h_state2 := events_h + 502

global obs_x := topleft_origin_x + 246
global obs_y := topleft_origin_y
global obs_w := 1050
global obs_h := 511

global obs_x_state2 := topleft_origin_x
global obs_y_state2 := topleft_origin_y
global obs_w_state2 := 1296
global obs_h_state2 := 1004

global obs_x_dual1 := topleft_origin_x
global obs_y_dual1 := topleft_origin_y
global obs_w_dual1 := 1293
global obs_h_dual1 := 504

global obs_x_dual2 := topleft_origin_x
global obs_y_dual2 := topleft_origin_y + obs_h_dual1 - 7 ; idfk, but it fixes the stupid gap
global obs_w_dual2 := obs_w_dual1
global obs_h_dual2 := obs_h_dual1

initializeini() ; Refer to https://autohotkey.com/board/topic/19650-auto-readload-and-save-an-ini-file-updated/
loadini() ; Ditto

Gui, Add, Slider, voffsets_offset_x altsubmit gSliderUpdate range-65-65, %offsets_offset_x%
Gui, Add, text, w50