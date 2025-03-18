'reinit'
'set grads off'
*'colortable load rgb'
*'colortable 120 red yellow blue -n 20'

*var='temp'
*var='salt'
*var='chl'
var='no3'
*var='wt'
*var='o2'

*t.1="CORE";t.2="T/S_sfc";t.3="T/S_3D";t.4="ECDA"
*t.1="T/S_3D_180dy";t.2="T/S_3D_360dy";t.3="T/S_3D_540dy";t.4="ECDA"
*t.1="T/S_3D_360dy";t.2="T/S_3D_5dy360dy";t.3="T/S_3D_30dy360dy";t.4="ECDA"
*t.1="T/S_3D_30dy";t.2="T/S_3D_180dy";t.3="T/S_3D_360dy";t.4="ECDA"
*t.1="CORE";t.2="T&S_3D_5dy";t.3="T&S_3D_360dy";t.4="T&S_3D_5-2052dy"
t.1="X_adv (CTRL)";t.2="Y_adv (CTRL)";t.3="Z_adv (CTRL)";
t.4="X_adv (3Drelax.5dy)";t.5="Y_adv (3Drelax.5dy)";t.6="Z_adv (3Drelax.5dy)"

*'open zadv.core.ctl'
*'open madv.core.ctl'
*'open vadv.core.ctl'
*'open zadv.core.3Drelax.5dy.ctl'
*'open madv.core.3Drelax.5dy.ctl'
*'open vadv.core.3Drelax.5dy.ctl'

'open zadv.core2.ctl'
'open madv.core2.ctl'
'open vadv.core2.ctl'
'open zadv.core2.3Drelax.5dy.ctl'
'open madv.core2.3Drelax.5dy.ctl'
'open vadv.core2.3Drelax.5dy.ctl'


'set x 1 360'
'set y 91'
*'set lev 5'
*'set lev 15'
'set lev 300 5'
*'set lev 50'
*'set lev 100'
*'set lev 250'
i=0
while(i<6)
i=i+1
'set dfile 'i
'getvar'
'define adv'i'=ave(var,lat=-2,lat=2)'

'subplot 33v  "'t.i'" 'i' 0.6 0.12'
'set xlopts 1 1 0.09'
'set ylopts 1 1 0.09'
'set gxout shaded'
'clevs 0.2'
'd 1e12*adv'i
endwhile


*'subplot 33v  "Zonal.adv (3Drelax-CTRL)" 7 0.6 0.12'
'subplot 33v  "Diff. X_adv (3Drelax-CTRL)" 7 0.6 0.12'
'set xlopts 1 1 0.09'
'set ylopts 1 1 0.09'
'set gxout shaded'
'clevs 0.2'
'd 1e12*(adv4-adv1)'

'subplot 33v  "Diff. Y_adv (3Drelax-CTRL)" 8 0.6 0.12'
'set xlopts 1 1 0.09'
'set ylopts 1 1 0.09'
'set gxout shaded'
'clevs 0.2'
'd 1e12*(adv5-adv2)'

'subplot 33v  "Diff. Z_adv (3Drelax-CTRL)" 9 0.6 0.12'
'set xlopts 1 1 0.09'
'set ylopts 1 1 0.09'
'set gxout shaded'
'clevs 0.2'
'd 1e12*(adv6-adv3)'


'cbarm 1 0 0.0 -0.1 0.4 0.8'

*'printim ../Figures/no3.XYZadv.mean.diff.eq.png x1920 y1080 white'
*'printim ../Figures/no3.XYZadv.mean.diff.2year.png x1920 y1080 white'

