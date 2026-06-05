'reinit'
it='1'
et='3'
*it='7'
*et='9'
*it='18'
*et='24'
*it='30'
*et='33'
*it='25'
*et='60'

*lev1='100'
*lev2='50'
lev1='25'
lev2='25'

var.3='zadv';var.4='zadv';var.5='madv';var.6='madv';var.7='vadv';var.8='vadv'
var.9='vdif';var.10='vdif';var.11='bio';var.12='bio'
p.1=1;p.2=2;p.3=4;p.4=5;p.5=7;p.6=8;;p.7=10;p.8=11;p.9=13;p.10=14;p.11=16;p.12=17;

t.1='dno3/dt (CTRL)';t.2='dno3/dt (3Drlx.5dy)';t.3='X_adv (CTRL)';t.4='X_adv (3Drlx.5dy)';
t.5='Y_adv (CTRL)';t.6='Y_adv (3Drlx.5dy)';t.7='Z_adv (CTRL)';t.8='Z_adv (3Drlx.5dy)';
t.9='Z_dif (CTRL)';t.10='Z_dif (3Drlx.5dy)';t.11='BIO (CTRL)';t.12='BIO (3Drlx.5dy)';

'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/no3.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/no3.core.3Drelax.5dy.1962-1966.ctl'

'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/zadv.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/zadv.core.3Drelax.5dy.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/madv.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/madv.core.3Drelax.5dy.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/vadv.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/vadv.core.3Drelax.5dy.1962-1966.ctl'

'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/vdif.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/vdif.core.3Drelax.5dy.1962-1966.ctl'

'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/bio.core.1962-1966.ctl'
'open /net2/jyp/MOM5_SIS_COBALT/Budget_all/bio.core.3Drelax.5dy.1962-1966.ctl'


i=0
while(i<2)
i=i+1
'set dfile 'i
'set x 1 360'
*'set y 1 180'
'set lat -30 30'
'set lev 15'
'set t 'it' 'et
*'define a=no3'
'define a=ave(no3,lev='lev1',lev='lev2')'

*'ltrend no3.'i' trd'i
'ltrend a trd'i

*'set t 'it
*'define tend'i'=(1/(86400*30))*(trd'i'(t='et')-trd'i'(t='et-1'))'

'set t 'et
'define a=trd'i
'set t 'et-1
'define b=trd'i
'define tend'i'=(1/(86400*30))*(a-b)'

endwhile


i=0
while(i<12)
i=i+1
*a=math_mod(i,2)
*b=math_fmod(i,2)
'set dfile 'i
'set t 'it' 'et
'set t 'it
if(i<3)
*'define eq'i'=ave(ave(tend'i',lat=-2,lat=2),t='it',t='et')'
*'define eq'i'=ave(tend'i',t='it',t='et')'
'define eq'i'=tend'i
else
*'define eq'i'=ave('var.i',t='it',t='et')'
'define eq'i'=ave(ave('var.i',lev='lev1',lev='lev2'),t='it',t='et')'
endif
'subplot 37 "'t.i'" 'p.i' 0.4 0.12'
'set xlopts 1 1 0.07'
'set ylopts 1 1 0.07'
'set gxout shaded'
'clevs 0.2'
'set ylint 50'
'd 1e12*eq'i

if(math_fmod(i,2)=0)
'subplot 37 "Difference" 'p.i+1' 0.4 0.12'
'set gxout shaded'
'clevs 0.2'
'set ylint 50'
'd 1e12*(eq'i'-eq'i-1')'
endif


endwhile

*'subplot 37 "Tot_adv (CTRL)" 19 0.4 0.12'
'subplot 37 "Total (CTRL)" 19 0.4 0.12'
'set gxout shaded'
'clevs 0.2'
'set ylint 50'
'd 1e12*(eq3+eq5+eq7+eq9+eq11)'
*'d 1e12*(eq3+eq5+eq7)'

*'subplot 37 "Tot_adv (3Drlx.5dy)" 20 0.4 0.12'
'subplot 37 "Total (3Drlx.5dy)" 20 0.4 0.12'
'set gxout shaded'
'clevs 0.2'
'set ylint 50'
'd 1e12*(eq4+eq6+eq8+eq10+eq12)'
*'d 1e12*(eq4+eq6+eq8)'

'subplot 37 "Difference" 21 0.4 0.12'
'set gxout shaded'
'clevs 0.2'
'set ylint 50'
'd 1e12*((eq4+eq6+eq8+eq10+eq12)-(eq3+eq5+eq7+eq9+eq11))'
*'d 1e12*((eq4+eq6+eq8+eq12)-(eq3+eq5+eq7+eq11))'
*'d 1e12*((eq4+eq6+eq8)-(eq3+eq5+eq7))'


*'printim ../../Figures/no3.budget.total.eq.1-3mo.png x1920 y1080 white'
*'printim ../../Figures/no3.budget.total.eq.7-12mo.png x1920 y1080 white'
*'printim ../../Figures/no3.budget.total.eq.13-24mo.png x1920 y1080 white'
*'printim ../../Figures/no3.budget.total.eq.3-5yr.png x1920 y1080 white'
