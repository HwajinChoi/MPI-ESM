'reinit'

'open fedten.1001-1500b.ctl'

'setxyz'
'set loopdim z'

'set gxout fwrite'
'set fwrite fedten.1001-1500.gdat'
it=4800
while(it<6000)
it=it+1
'set t 'it
'd fedten'
endwhile
'disable fwrite'
