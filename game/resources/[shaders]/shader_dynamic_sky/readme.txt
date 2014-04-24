resource: Shader Dynamic Sky v0.82
author: Ren712
contact: knoblauch700@o2.pl
video: http://www.youtube.com/watch?v=uvlYMtxLSQk
Update 0.82:
- Added the isFogEnabled bool to switch the horizon blending
- Reconfigured the fade distance 
- Reworked some possible alpha issues
Update 0.81:
-Fixed potential drawing moon bug (for some GFX cards)
-Changed the fading method to prevent flickering

Update 0.79:
-Applied IgorRodriguesCo's suggestions:
 -Slowed down cloud movement
 -The effects fades gradually and blends with horizon
-The effect is not visible below the camera pos.

Description:
This resource adds a dynamic sky for your MTA.
The sun and moon positions depend on the ingame time.
Current (based on server time) moon phase is counted
on resource start.
The night sky created with spacescape-0.3.