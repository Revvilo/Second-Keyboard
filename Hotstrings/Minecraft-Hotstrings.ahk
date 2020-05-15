#IfWinActive, Minecraft
; Hotstrings
::#sel::{#}selection
::#set::{#}selection set
::#killitems::kill @e[type=item]
::#sp::{#}fill reccomplex:generic_space air
::#y::{#}confirm
::#n::{#}cancel
::#cl::{#}fill air
::#d::{#}selection clear
::#tree::{#}selection wand log|log2|leaves|leaves2
::#deltree::{#}fill air log|log2|leaves|leaves2

::#testplatform::{#}selection set 699 4 -734 589 15 -848 --first --second
::#testplatair::{#}selection set 699 16 -734 589 255 -848 --first --second

::#ex::{#}selection expand
::#exh::{#}selection expand -z 1 -x 1
::#shh::{#}selection expand -z -1 -x -1

::#solid::{#}fill reccomplex:generic_solid air
::#delsolid::{#}fill air reccomplex:generic_solid
::#space::{#}fill reccomplex:generic_space air
::#dsp::{#}fill air reccomplex:generic_space
::#delspace::{#}fill air reccomplex:generic_space

::#w::{#}selection wand
::#up1::{#}selection set ~ ~1 ~
::#dn1::{#}selection set ~ ~-1 ~
:O:#p1::{#}selection set ~ ~ ~ --first{left 10}
:O:#p2::{#}selection set ~ ~ ~ --second{left 11}
Return