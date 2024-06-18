" vim: set tabstop=8 shiftwidth=8:

command! -range -bang -nargs=0 Shortlinkify <line1>,<line2>call shortlinkify#Shortlinkify("<bang>")
