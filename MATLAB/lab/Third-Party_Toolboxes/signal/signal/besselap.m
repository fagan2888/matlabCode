function [z,p,k] = besselap(n)
%BESSELAP  Bessel analog lowpass filter prototype.
%   [Z,P,K] = BESSELAP(N) returns the zeros, poles, and gain
%   for an N-th order normalized prototype Bessel analog
%   lowpass filter.  The cutoff or 3dB frequency is equal to 1 
%   for N = 1 and decreases as N increases.
%
%   See also BESSELF, BUTTAP, CHEB1AP, and CHEB2AP.

%   Author(s): T. Krauss, 3-23-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:41:55 $

    if (n>25),
        error('Bessel filter roots are not available for order N > 25.')
    end

    z = [];
    k = 1;

% table method
str = '';
if n == 0,
   p = []; return
elseif n == 1,
   str = '-1';
elseif n == 2,
   str      ='[-.8660254037844386467637229+.4999999999999999999999996*i]';
   str( 2,:)='[-.8660254037844386467637229-.4999999999999999999999996*i]';
elseif n == 3,
   str      ='[                             -.9416000265332067855971980]';
   str( 2,:)='[-.7456403858480766441810907-.7113666249728352680992154*i]';
   str( 3,:)='[-.7456403858480766441810907+.7113666249728352680992154*i]';
elseif n == 4,
   str      ='[-.6572111716718829545787781-.8301614350048733772399715*i]';
   str( 2,:)='[-.6572111716718829545787788+.8301614350048733772399715*i]';
   str( 3,:)='[-.9047587967882449459642637-.2709187330038746636700923*i]';
   str( 4,:)='[-.9047587967882449459642624+.2709187330038746636700926*i]';
elseif n == 5,
   str      ='[                             -.9264420773877602247196260]';
   str( 2,:)='[-.8515536193688395541722677-.4427174639443327209850002*i]';
   str( 3,:)='[-.8515536193688395541722677+.4427174639443327209850002*i]';
   str( 4,:)='[-.5905759446119191779319432-.9072067564574549539291747*i]';
   str( 5,:)='[-.5905759446119191779319432+.9072067564574549539291747*i]';
elseif n == 6,
   str      ='[-.9093906830472271808050953-.1856964396793046769246397*i]';
   str( 2,:)='[-.9093906830472271808050953+.1856964396793046769246397*i]';
   str( 3,:)='[-.7996541858328288520243325-.5621717346937317988594118*i]';
   str( 4,:)='[-.7996541858328288520243325+.5621717346937317988594118*i]';
   str( 5,:)='[-.5385526816693109683073792-.9616876881954277199245657*i]';
   str( 6,:)='[-.5385526816693109683073792+.9616876881954277199245657*i]';
elseif n == 7,
   str      ='[                             -.9194871556490290014311619]';
   str( 2,:)='[-.8800029341523374639772340-.3216652762307739398381830*i]';
   str( 3,:)='[-.8800029341523374639772340+.3216652762307739398381830*i]';
   str( 4,:)='[-.7527355434093214462291616-.6504696305522550699212995*i]';
   str( 5,:)='[-.7527355434093214462291616+.6504696305522550699212995*i]';
   str( 6,:)='[-.4966917256672316755024763-1.002508508454420401230220*i]';
   str( 7,:)='[-.4966917256672316755024763+1.002508508454420401230220*i]';
elseif n == 8,
   str      ='[-.9096831546652910216327629-.1412437976671422927888150*i]';
   str( 2,:)='[-.9096831546652910216327629+.1412437976671422927888150*i]';
   str( 3,:)='[-.8473250802359334320103023-.4259017538272934994996429*i]';
   str( 4,:)='[-.8473250802359334320103023+.4259017538272934994996429*i]';
   str( 5,:)='[-.7111381808485399250796172-.7186517314108401705762571*i]';
   str( 6,:)='[-.7111381808485399250796172+.7186517314108401705762571*i]';
   str( 7,:)='[-.4621740412532122027072175-1.034388681126901058116589*i]';
   str( 8,:)='[-.4621740412532122027072175+1.034388681126901058116589*i]';
elseif n == 9,
   str      ='[                             -.9154957797499037686769223]';
   str( 2,:)='[-.8911217017079759323183848-.2526580934582164192308115*i]';
   str( 3,:)='[-.8911217017079759323183848+.2526580934582164192308115*i]';
   str( 4,:)='[-.8148021112269012975514135-.5085815689631499483745341*i]';
   str( 5,:)='[-.8148021112269012975514135+.5085815689631499483745341*i]';
   str( 6,:)='[-.6743622686854761980403401-.7730546212691183706919682*i]';
   str( 7,:)='[-.6743622686854761980403401+.7730546212691183706919682*i]';
   str( 8,:)='[-.4331415561553618854685942-1.060073670135929666774323*i]';
   str( 9,:)='[-.4331415561553618854685942+1.060073670135929666774323*i]';
elseif n == 10,
   str      ='[-.9091347320900502436826431-.1139583137335511169927714*i]';
   str( 2,:)='[-.9091347320900502436826431+.1139583137335511169927714*i]';
   str( 3,:)='[-.8688459641284764527921864-.3430008233766309973110589*i]';
   str( 4,:)='[-.8688459641284764527921864+.3430008233766309973110589*i]';
   str( 5,:)='[-.7837694413101441082655890-.5759147538499947070009852*i]';
   str( 6,:)='[-.7837694413101441082655890+.5759147538499947070009852*i]';
   str( 7,:)='[-.6417513866988316136190854-.8175836167191017226233947*i]';
   str( 8,:)='[-.6417513866988316136190854+.8175836167191017226233947*i]';
   str( 9,:)='[-.4083220732868861566219785-1.081274842819124562037210*i]';
   str(10,:)='[-.4083220732868861566219785+1.081274842819124562037210*i]';
elseif n == 11,
   str      ='[                             -.9129067244518981934637318]';
   str( 2,:)='[-.8963656705721166099815744-.2080480375071031919692341*i]';
   str( 3,:)='[-.8963656705721166099815744+.2080480375071031919692341*i]';
   str( 4,:)='[-.8453044014712962954184557-.4178696917801248292797448*i]';
   str( 5,:)='[-.8453044014712962954184557+.4178696917801248292797448*i]';
   str( 6,:)='[-.7546938934722303128102142-.6319150050721846494520941*i]';
   str( 7,:)='[-.7546938934722303128102142+.6319150050721846494520941*i]';
   str( 8,:)='[-.6126871554915194054182909-.8547813893314764631518509*i]';
   str( 9,:)='[-.6126871554915194054182909+.8547813893314764631518509*i]';
   str(10,:)='[-.3868149510055090879155425-1.099117466763120928733632*i]';
   str(11,:)='[-.3868149510055090879155425+1.099117466763120928733632*i]';
elseif n == 12,
   str      ='[-.9084478234140682638817772-95506365213450398415258360.0E-27*i]';
   str( 2,:)='[-.9084478234140682638817772+95506365213450398415258360.0E-27*i]';
   str( 3,:)='[      -.8802534342016826507901575-.2871779503524226723615457*i]';
   str( 4,:)='[      -.8802534342016826507901575+.2871779503524226723615457*i]';
   str( 5,:)='[      -.8217296939939077285792834-.4810212115100676440620548*i]';
   str( 6,:)='[      -.8217296939939077285792834+.4810212115100676440620548*i]';
   str( 7,:)='[      -.7276681615395159454547013-.6792961178764694160048987*i]';
   str( 8,:)='[      -.7276681615395159454547013+.6792961178764694160048987*i]';
   str( 9,:)='[      -.5866369321861477207528215-.8863772751320727026622149*i]';
   str(10,:)='[      -.5866369321861477207528215+.8863772751320727026622149*i]';
   str(11,:)='[      -.3679640085526312839425808-1.114373575641546257595657*i]';
   str(12,:)='[      -.3679640085526312839425808+1.114373575641546257595657*i]';
elseif n == 13,
   str      ='[                             -.9110914665984182781070663]';
   str( 2,:)='[-.8991314665475196220910718-.1768342956161043620980863*i]';
   str( 3,:)='[-.8991314665475196220910718+.1768342956161043620980863*i]';
   str( 4,:)='[-.8625094198260548711573628-.3547413731172988997754038*i]';
   str( 5,:)='[-.8625094198260548711573628+.3547413731172988997754038*i]';
   str( 6,:)='[-.7987460692470972510394686-.5350752120696801938272504*i]';
   str( 7,:)='[-.7987460692470972510394686+.5350752120696801938272504*i]';
   str( 8,:)='[-.7026234675721275653944062-.7199611890171304131266374*i]';
   str( 9,:)='[-.7026234675721275653944062+.7199611890171304131266374*i]';
   str(10,:)='[-.5631559842430199266325818-.9135900338325109684927731*i]';
   str(11,:)='[-.5631559842430199266325818+.9135900338325109684927731*i]';
   str(12,:)='[-.3512792323389821669401925-1.127591548317705678613239*i]';
   str(13,:)='[-.3512792323389821669401925+1.127591548317705678613239*i]';
elseif n == 14,
   str      ='[-.9077932138396487614720659-82196399419401501888968130.0E-27*i]';
   str( 2,:)='[-.9077932138396487614720659+82196399419401501888968130.0E-27*i]';
   str( 3,:)='[      -.8869506674916445312089167-.2470079178765333183201435*i]';
   str( 4,:)='[      -.8869506674916445312089167+.2470079178765333183201435*i]';
   str( 5,:)='[      -.8441199160909851197897667-.4131653825102692595237260*i]';
   str( 6,:)='[      -.8441199160909851197897667+.4131653825102692595237260*i]';
   str( 7,:)='[      -.7766591387063623897344648-.5819170677377608590492434*i]';
   str( 8,:)='[      -.7766591387063623897344648+.5819170677377608590492434*i]';
   str( 9,:)='[      -.6794256425119233117869491-.7552857305042033418417492*i]';
   str(10,:)='[      -.6794256425119233117869491+.7552857305042033418417492*i]';
   str(11,:)='[      -.5418766775112297376541293-.9373043683516919569183099*i]';
   str(12,:)='[      -.5418766775112297376541293+.9373043683516919569183099*i]';
   str(13,:)='[      -.3363868224902037330610040-1.139172297839859991370924*i]';
   str(14,:)='[      -.3363868224902037330610040+1.139172297839859991370924*i]';
elseif n == 15,
   str      ='[                             -.9097482363849064167228581]';
   str( 2,:)='[-.9006981694176978324932918-.1537681197278439351298882*i]';
   str( 3,:)='[-.9006981694176978324932918+.1537681197278439351298882*i]';
   str( 4,:)='[-.8731264620834984978337843-.3082352470564267657715883*i]';
   str( 5,:)='[-.8731264620834984978337843+.3082352470564267657715883*i]';
   str( 6,:)='[-.8256631452587146506294553-.4642348752734325631275134*i]';
   str( 7,:)='[-.8256631452587146506294553+.4642348752734325631275134*i]';
   str( 8,:)='[-.7556027168970728127850416-.6229396358758267198938604*i]';
   str( 9,:)='[-.7556027168970728127850416+.6229396358758267198938604*i]';
   str(10,:)='[-.6579196593110998676999362-.7862895503722515897065645*i]';
   str(11,:)='[-.6579196593110998676999362+.7862895503722515897065645*i]';
   str(12,:)='[-.5224954069658330616875186-.9581787261092526478889345*i]';
   str(13,:)='[-.5224954069658330616875186+.9581787261092526478889345*i]';
   str(14,:)='[-.3229963059766444287113517-1.149416154583629539665297*i]';
   str(15,:)='[-.3229963059766444287113517+1.149416154583629539665297*i]';
elseif n == 16,
   str      ='[-.9072099595087001356491337-72142113041117326028823950.0E-27*i]';
   str( 2,:)='[-.9072099595087001356491337+72142113041117326028823950.0E-27*i]';
   str( 3,:)='[      -.8911723070323647674780132-.2167089659900576449410059*i]';
   str( 4,:)='[      -.8911723070323647674780132+.2167089659900576449410059*i]';
   str( 5,:)='[      -.8584264231521330481755780-.3621697271802065647661080*i]';
   str( 6,:)='[      -.8584264231521330481755780+.3621697271802065647661080*i]';
   str( 7,:)='[      -.8074790293236003885306146-.5092933751171800179676218*i]';
   str( 8,:)='[      -.8074790293236003885306146+.5092933751171800179676218*i]';
   str( 9,:)='[      -.7356166304713115980927279-.6591950877860393745845254*i]';
   str(10,:)='[      -.7356166304713115980927279+.6591950877860393745845254*i]';
   str(11,:)='[      -.6379502514039066715773828-.8137453537108761895522580*i]';
   str(12,:)='[      -.6379502514039066715773828+.8137453537108761895522580*i]';
   str(13,:)='[      -.5047606444424766743309967-.9767137477799090692947061*i]';
   str(14,:)='[      -.5047606444424766743309967+.9767137477799090692947061*i]';
   str(15,:)='[      -.3108782755645387813283867-1.158552841199330479412225*i]';
   str(16,:)='[      -.3108782755645387813283867+1.158552841199330479412225*i]';
elseif n == 17,
   str      ='[                             -.9087141161336397432860029]';
   str( 2,:)='[-.9016273850787285964692844-.1360267995173024591237303*i]';
   str( 3,:)='[-.9016273850787285964692844+.1360267995173024591237303*i]';
   str( 4,:)='[-.8801100704438627158492165-.2725347156478803885651973*i]';
   str( 5,:)='[-.8801100704438627158492165+.2725347156478803885651973*i]';
   str( 6,:)='[-.8433414495836129204455491-.4100759282910021624185986*i]';
   str( 7,:)='[-.8433414495836129204455491+.4100759282910021624185986*i]';
   str( 8,:)='[-.7897644147799708220288138-.5493724405281088674296232*i]';
   str( 9,:)='[-.7897644147799708220288138+.5493724405281088674296232*i]';
   str(10,:)='[-.7166893842372349049842743-.6914936286393609433305754*i]';
   str(11,:)='[-.7166893842372349049842743+.6914936286393609433305754*i]';
   str(12,:)='[-.6193710717342144521602448-.8382497252826992979368621*i]';
   str(13,:)='[-.6193710717342144521602448+.8382497252826992979368621*i]';
   str(14,:)='[-.4884629337672704194973683-.9932971956316781632345466*i]';
   str(15,:)='[-.4884629337672704194973683+.9932971956316781632345466*i]';
   str(16,:)='[-.2998489459990082015466971-1.166761272925668786676672*i]';
   str(17,:)='[-.2998489459990082015466971+1.166761272925668786676672*i]';
elseif n == 18,
   str      ='[-.9067004324162775554189031-64279241063930693839360680.0E-27*i]';
   str( 2,:)='[-.9067004324162775554189031+64279241063930693839360680.0E-27*i]';
   str( 3,:)='[      -.8939764278132455733032155-.1930374640894758606940586*i]';
   str( 4,:)='[      -.8939764278132455733032155+.1930374640894758606940586*i]';
   str( 5,:)='[      -.8681095503628830078317207-.3224204925163257604931634*i]';
   str( 6,:)='[      -.8681095503628830078317207+.3224204925163257604931634*i]';
   str( 7,:)='[      -.8281885016242836608829018-.4529385697815916950149364*i]';
   str( 8,:)='[      -.8281885016242836608829018+.4529385697815916950149364*i]';
   str( 9,:)='[      -.7726285030739558780127746-.5852778162086640620016316*i]';
   str(10,:)='[      -.7726285030739558780127746+.5852778162086640620016316*i]';
   str(11,:)='[      -.6987821445005273020051878-.7204696509726630531663123*i]';
   str(12,:)='[      -.6987821445005273020051878+.7204696509726630531663123*i]';
   str(13,:)='[      -.6020482668090644386627299-.8602708961893664447167418*i]';
   str(14,:)='[      -.6020482668090644386627299+.8602708961893664447167418*i]';
   str(15,:)='[      -.4734268069916151511140032-1.008234300314801077034158*i]';
   str(16,:)='[      -.4734268069916151511140032+1.008234300314801077034158*i]';
   str(17,:)='[      -.2897592029880489845789953-1.174183010600059128532230*i]';
   str(18,:)='[      -.2897592029880489845789953+1.174183010600059128532230*i]';
elseif n == 19,
   str      ='[                             -.9078934217899404528985092]';
   str( 2,:)='[-.9021937639390660668922536-.1219568381872026517578164*i]';
   str( 3,:)='[-.9021937639390660668922536+.1219568381872026517578164*i]';
   str( 4,:)='[-.8849290585034385274001112-.2442590757549818229026280*i]';
   str( 5,:)='[-.8849290585034385274001112+.2442590757549818229026280*i]';
   str( 6,:)='[-.8555768765618421591093993-.3672925896399872304734923*i]';
   str( 7,:)='[-.8555768765618421591093993+.3672925896399872304734923*i]';
   str( 8,:)='[-.8131725551578197705476160-.4915365035562459055630005*i]';
   str( 9,:)='[-.8131725551578197705476160+.4915365035562459055630005*i]';
   str(10,:)='[-.7561260971541629355231897-.6176483917970178919174173*i]';
   str(11,:)='[-.7561260971541629355231897+.6176483917970178919174173*i]';
   str(12,:)='[-.6818424412912442033411634-.7466272357947761283262338*i]';
   str(13,:)='[-.6818424412912442033411634+.7466272357947761283262338*i]';
   str(14,:)='[-.5858613321217832644813602-.8801817131014566284786759*i]';
   str(15,:)='[-.5858613321217832644813602+.8801817131014566284786759*i]';
   str(16,:)='[-.4595043449730988600785456-1.021768776912671221830298*i]';
   str(17,:)='[-.4595043449730988600785456+1.021768776912671221830298*i]';
   str(18,:)='[-.2804866851439370027628724-1.180931628453291873626003*i]';
   str(19,:)='[-.2804866851439370027628724+1.180931628453291873626003*i]';
elseif n == 20,
   str      ='[-.9062570115576771146523497-57961780277849516990208850.0E-27*i]';
   str( 2,:)='[-.9062570115576771146523497+57961780277849516990208850.0E-27*i]';
   str( 3,:)='[      -.8959150941925768608568248-.1740317175918705058595844*i]';
   str( 4,:)='[      -.8959150941925768608568248+.1740317175918705058595844*i]';
   str( 5,:)='[      -.8749560316673332850673214-.2905559296567908031706902*i]';
   str( 6,:)='[      -.8749560316673332850673214+.2905559296567908031706902*i]';
   str( 7,:)='[      -.8427907479956670633544106-.4078917326291934082132821*i]';
   str( 8,:)='[      -.8427907479956670633544106+.4078917326291934082132821*i]';
   str( 9,:)='[      -.7984251191290606875799876-.5264942388817132427317659*i]';
   str(10,:)='[      -.7984251191290606875799876+.5264942388817132427317659*i]';
   str(11,:)='[      -.7402780309646768991232610-.6469975237605228320268752*i]';
   str(12,:)='[      -.7402780309646768991232610+.6469975237605228320268752*i]';
   str(13,:)='[      -.6658120544829934193890626-.7703721701100763015154510*i]';
   str(14,:)='[      -.6658120544829934193890626+.7703721701100763015154510*i]';
   str(15,:)='[      -.5707026806915714094398061-.8982829066468255593407161*i]';
   str(16,:)='[      -.5707026806915714094398061+.8982829066468255593407161*i]';
   str(17,:)='[      -.4465700698205149555701841-1.034097702560842962315411*i]';
   str(18,:)='[      -.4465700698205149555701841+1.034097702560842962315411*i]';
   str(19,:)='[      -.2719299580251652601727704-1.187099379810885886139638*i]';
   str(20,:)='[      -.2719299580251652601727704+1.187099379810885886139638*i]';
elseif n == 21,
   str      ='[                             -.9072262653142957028884077]';
   str( 2,:)='[-.9025428073192696303995083-.1105252572789856480992275*i]';
   str( 3,:)='[-.9025428073192696303995083+.1105252572789856480992275*i]';
   str( 4,:)='[-.8883808106664449854431605-.2213069215084350419975358*i]';
   str( 5,:)='[-.8883808106664449854431605+.2213069215084350419975358*i]';
   str( 6,:)='[-.8643915813643204553970169-.3326258512522187083009453*i]';
   str( 7,:)='[-.8643915813643204553970169+.3326258512522187083009453*i]';
   str( 8,:)='[-.8299435470674444100273463-.4448177739407956609694059*i]';
   str( 9,:)='[-.8299435470674444100273463+.4448177739407956609694059*i]';
   str(10,:)='[-.7840287980408341576100581-.5583186348022854707564856*i]';
   str(11,:)='[-.7840287980408341576100581+.5583186348022854707564856*i]';
   str(12,:)='[-.7250839687106612822281339-.6737426063024382240549898*i]';
   str(13,:)='[-.7250839687106612822281339+.6737426063024382240549898*i]';
   str(14,:)='[-.6506315378609463397807996-.7920349342629491368548074*i]';
   str(15,:)='[-.6506315378609463397807996+.7920349342629491368548074*i]';
   str(16,:)='[-.5564766488918562465935297-.9148198405846724121600860*i]';
   str(17,:)='[-.5564766488918562465935297+.9148198405846724121600860*i]';
   str(18,:)='[-.4345168906815271799687308-1.045382255856986531461592*i]';
   str(19,:)='[-.4345168906815271799687308+1.045382255856986531461592*i]';
   str(20,:)='[-.2640041595834031147954813-1.192762031948052470183960*i]';
   str(21,:)='[-.2640041595834031147954813+1.192762031948052470183960*i]';
elseif n == 22,
   str      ='[-.9058702269930872551848625-52774908289999045189007100.0E-27*i]';
   str( 2,:)='[-.9058702269930872551848625+52774908289999045189007100.0E-27*i]';
   str( 3,:)='[      -.8972983138153530955952835-.1584351912289865608659759*i]';
   str( 4,:)='[      -.8972983138153530955952835+.1584351912289865608659759*i]';
   str( 5,:)='[      -.8799661455640176154025352-.2644363039201535049656450*i]';
   str( 6,:)='[      -.8799661455640176154025352+.2644363039201535049656450*i]';
   str( 7,:)='[      -.8534754036851687233084587-.3710389319482319823405321*i]';
   str( 8,:)='[      -.8534754036851687233084587+.3710389319482319823405321*i]';
   str( 9,:)='[      -.8171682088462720394344996-.4785619492202780899653575*i]';
   str(10,:)='[      -.8171682088462720394344996+.4785619492202780899653575*i]';
   str(11,:)='[      -.7700332930556816872932937-.5874255426351153211965601*i]';
   str(12,:)='[      -.7700332930556816872932937+.5874255426351153211965601*i]';
   str(13,:)='[      -.7105305456418785989070935-.6982266265924524000098548*i]';
   str(14,:)='[      -.7105305456418785989070935+.6982266265924524000098548*i]';
   str(15,:)='[      -.6362427683267827226840153-.8118875040246347267248508*i]';
   str(16,:)='[      -.6362427683267827226840153+.8118875040246347267248508*i]';
   str(17,:)='[      -.5430983056306302779658129-.9299947824439872998916657*i]';
   str(18,:)='[      -.5430983056306302779658129+.9299947824439872998916657*i]';
   str(19,:)='[      -.4232528745642628461715044-1.055755605227545931204656*i]';
   str(20,:)='[      -.4232528745642628461715044+1.055755605227545931204656*i]';
   str(21,:)='[      -.2566376987939318038016012-1.197982433555213008346532*i]';
   str(22,:)='[      -.2566376987939318038016012+1.197982433555213008346532*i]';
elseif n == 23,
   str      ='[                             -.9066732476324988168207439]';
   str( 2,:)='[-.9027564979912504609412993-.1010534335314045013252480*i]';
   str( 3,:)='[-.9027564979912504609412993+.1010534335314045013252480*i]';
   str( 4,:)='[-.8909283242471251458653994-.2023024699381223418195228*i]';
   str( 5,:)='[-.8909283242471251458653994+.2023024699381223418195228*i]';
   str( 6,:)='[-.8709469395587416239596874-.3039581993950041588888925*i]';
   str( 7,:)='[-.8709469395587416239596874+.3039581993950041588888925*i]';
   str( 8,:)='[-.8423805948021127057054288-.4062657948237602726779246*i]';
   str( 9,:)='[-.8423805948021127057054288+.4062657948237602726779246*i]';
   str(10,:)='[-.8045561642053176205623187-.5095305912227258268309528*i]';
   str(11,:)='[-.8045561642053176205623187+.5095305912227258268309528*i]';
   str(12,:)='[-.7564660146829880581478138-.6141594859476032127216463*i]';
   str(13,:)='[-.7564660146829880581478138+.6141594859476032127216463*i]';
   str(14,:)='[-.6965966033912705387505040-.7207341374753046970247055*i]';
   str(15,:)='[-.6965966033912705387505040+.7207341374753046970247055*i]';
   str(16,:)='[-.6225903228771341778273152-.8301558302812980678845563*i]';
   str(17,:)='[-.6225903228771341778273152+.8301558302812980678845563*i]';
   str(18,:)='[-.5304922463810191698502226-.9439760364018300083750242*i]';
   str(19,:)='[-.5304922463810191698502226+.9439760364018300083750242*i]';
   str(20,:)='[-.4126986617510148836149955-1.065328794475513585531053*i]';
   str(21,:)='[-.4126986617510148836149955+1.065328794475513585531053*i]';
   str(22,:)='[-.2497697202208956030229911-1.202813187870697831365338*i]';
   str(23,:)='[-.2497697202208956030229911+1.202813187870697831365338*i]';
elseif n == 24,
   str      ='[-.9055312363372773709269407-48440066540478700874836350.0E-27*i]';
   str( 2,:)='[-.9055312363372773709269407+48440066540478700874836350.0E-27*i]';
   str( 3,:)='[      -.8983105104397872954053307-.1454056133873610120105857*i]';
   str( 4,:)='[      -.8983105104397872954053307+.1454056133873610120105857*i]';
   str( 5,:)='[      -.8837358034555706623131950-.2426335234401383076544239*i]';
   str( 6,:)='[      -.8837358034555706623131950+.2426335234401383076544239*i]';
   str( 7,:)='[      -.8615278304016353651120610-.3403202112618624773397257*i]';
   str( 8,:)='[      -.8615278304016353651120610+.3403202112618624773397257*i]';
   str( 9,:)='[      -.8312326466813240652679563-.4386985933597305434577492*i]';
   str(10,:)='[      -.8312326466813240652679563+.4386985933597305434577492*i]';
   str(11,:)='[      -.7921695462343492518845446-.5380628490968016700338001*i]';
   str(12,:)='[      -.7921695462343492518845446+.5380628490968016700338001*i]';
   str(13,:)='[      -.7433392285088529449175873-.6388084216222567930378296*i]';
   str(14,:)='[      -.7433392285088529449175873+.6388084216222567930378296*i]';
   str(15,:)='[      -.6832565803536521302816011-.7415032695091650806797753*i]';
   str(16,:)='[      -.6832565803536521302816011+.7415032695091650806797753*i]';
   str(17,:)='[      -.6096221567378335562589532-.8470292433077202380020454*i]';
   str(18,:)='[      -.6096221567378335562589532+.8470292433077202380020454*i]';
   str(19,:)='[      -.5185914574820317343536707-.9569048385259054576937721*i]';
   str(20,:)='[      -.5185914574820317343536707+.9569048385259054576937721*i]';
   str(21,:)='[      -.4027853855197518014786978-1.074195196518674765143729*i]';
   str(22,:)='[      -.4027853855197518014786978+1.074195196518674765143729*i]';
   str(23,:)='[      -.2433481337524869675825448-1.207298683731972524975429*i]';
   str(24,:)='[      -.2433481337524869675825448+1.207298683731972524975429*i]';
elseif n == 25,
   str      ='[                                   -.9062073871811708652496104]';
   str( 2,:)='[-.9028833390228020537142561-93077131185102967450643820.0E-27*i]';
   str( 3,:)='[-.9028833390228020537142561+93077131185102967450643820.0E-27*i]';
   str( 4,:)='[      -.8928551459883548836774529-.1863068969804300712287138*i]';
   str( 5,:)='[      -.8928551459883548836774529+.1863068969804300712287138*i]';
   str( 6,:)='[      -.8759497989677857803656239-.2798521321771408719327250*i]';
   str( 7,:)='[      -.8759497989677857803656239+.2798521321771408719327250*i]';
   str( 8,:)='[      -.8518616886554019782346493-.3738977875907595009446142*i]';
   str( 9,:)='[      -.8518616886554019782346493+.3738977875907595009446142*i]';
   str(10,:)='[      -.8201226043936880253962552-.4686668574656966589020580*i]';
   str(11,:)='[      -.8201226043936880253962552+.4686668574656966589020580*i]';
   str(12,:)='[      -.7800496278186497225905443-.5644441210349710332887354*i]';
   str(13,:)='[      -.7800496278186497225905443+.5644441210349710332887354*i]';
   str(14,:)='[      -.7306549271849967721596735-.6616149647357748681460822*i]';
   str(15,:)='[      -.7306549271849967721596735+.6616149647357748681460822*i]';
   str(16,:)='[      -.6704827128029559528610523-.7607348858167839877987008*i]';
   str(17,:)='[      -.6704827128029559528610523+.7607348858167839877987008*i]';
   str(18,:)='[      -.5972898661335557242320528-.8626676330388028512598538*i]';
   str(19,:)='[      -.5972898661335557242320528+.8626676330388028512598538*i]';
   str(20,:)='[      -.5073362861078468845461362-.9689006305344868494672405*i]';
   str(21,:)='[      -.5073362861078468845461362+.9689006305344868494672405*i]';
   str(22,:)='[      -.3934529878191079606023847-1.082433927173831581956863*i]';
   str(23,:)='[      -.3934529878191079606023847+1.082433927173831581956863*i]';
   str(24,:)='[      -.2373280669322028974199184-1.211476658382565356579418*i]';
   str(25,:)='[      -.2373280669322028974199184+1.211476658382565356579418*i]';
end

for j=1:size(str,1),
   p(j,:) = eval(str(j,:));
end