#!/usr/bin/env perl

## This Script is free for all. Please feel free to distribute it to all of your friends! I do not warantee this program
## in any way or for any reason, if it blows up and ruins your entire business database, I accept no responsibility!
## Please email cronus@pcis.net with any problems or comments.

## NOTE: This is not meant to run on anything but linux with perl 5.0 or greater, if you need to to run on win32
## good luck!

use IO::Socket;
my $VERSION = '1.0';
my ( $peer, $port );

##look for server argument or display usage
( $peer = $ARGV[0] ) || &usage;

##assign port description hash
my %connected = split /:/,
    "tcpmux:1:compressnet:2:compressnet:3:rje:5:echo:7:discard:9:systat:11:daytime:13:qotd:17:msp:18:chargen:19:ftp-data:20:ftp:21:ssh:22:telnet:23:smtp:25:nsw-fe:27:msg-icp:29:msg-auth:31:dsp:33:time:37:rap:38:rlp:39:graphics:41:name:42:nameserver:42:nicname:43:mpm-flags:44:mpm:45:mpm-snd:46:ni-ftp:47:auditd:48:tacacs:49:re-mail-ck:50:la-maint:51:xns-time:52:domain:53:xns-ch:54:isi-gl:55:xns-auth:56:xns-mail:58:ni-mail:61:acas:62:whois++:63:covia:64:tacacs-ds:65:sql*net:66:bootps:67:bootpc:68:tftp:69:gopher:70:netrjs-1:71:netrjs-2:72:netrjs-3:73:netrjs-4:74:deos:76:vettcp:78:finger:79:http:80:www:80:www-http:80:hosts2-ns:81:xfer:82:mit-ml-dev:83:ctf:84:mit-ml-dev:85:mfcobol:86:kerberos:88:su-mit-tg:89:dnsix:90:mit-dov:91:npp:92:dcp:93:objcall:94:supdup:95:dixie:96:swift-rvf:97:tacnews:98:metagram:99:newacct:100:hostname:101:gppitnp:103:cso:105:csnet-ns:105:3com-tsmux:106:rtelnet:107:snagas:108:sunrpc:111:mcidas:112:ident:113:auth:113:audionews:114:sftp:115:ansanotify:116:uucp-path:117:sqlserv:118:nntp:119:cfdptkt:120:erpc:121:smakynet:122:ntp:123:ansatrader:124:locus-map:125:nxedit:126:locus-con:127:gss-xlicen:128:pwdgen:129:cisco-fna:130:cisco-tna:131:cisco-sys:132:statsrv:133:ingres-net:134:epmap:135:profile:136:netbios-ns:137:netbios-dgm:138:netbios-ssn:139:emfis-data:140:emfis-cntl:141:bl-idm:142:imap:143:uma:144:uaac:145:iso-ip:147:jargon:148:aed-512:149:sql-net:150:hems:151:bftp:152:sgmp:153:netsc-prod:154:netsc-dev:155:sqlsrv:156:knet-cmp:157:pcmail-srv:158:nss-routing:159:sgmp-traps:160:snmp:161:snmptrap:162:cmip-man:163:cmip-agent:164:xns-courier:165:s-net:166:namp:167:rsvd:168:send:169:print-srv:170:multiplex:171:xyplex-mux:173:mailq:174:vmnet:175:genrad-mux:176:xdmcp:177:nextstep:178:bgp:179:ris:180:unify:181:audit:182:ocbinder:183:ocserver:184:remote-kis:185:kis:186:aci:187:mumps:188:qft:189:gacp:190:prospero:191:osu-nms:192:srmp:193:irc:194:dn6-nlm-aud:195:dn6-smm-red:196:dls:197:dls-mon:198:smux:199:src:200:at-rtmp:201:at-nbp:202:at-3:203:at-echo:204:at-5:205:at-zis:206:at-7:207:at-8:208:qmtp:209:anet:212:ipx:213:vmpwscs:214:softpc:215:CAIlic:216:dbase:217:mpp:218:uarps:219:fln-spx:221:rsh-spx:222:cdc:223:masqdialer:224:direct:242:sur-meas:243:dayna:244:link:245:dsp3270:246:subntbcst_tftp:247:bhfhs:248:rap:256:set:257:yak-chat:258:esro-gen:259:openport:260:nsiiops:261:arcisdms:262:hdap:263:bgmp:264:http-mgmt:280:personal-link:281:cableport-ax:282:rescap:283:corerjd:284:novastorbakcup:308:entrusttime:309:bhmds:310:asip-webadmin:311:vslmp:312:magenta-logic:313:opalis-robot:314:dpsi:315:decauth:316:zannet:317:pkix-timestamp:318:ptp-event:319:ptp-general:320:pip:321:rtsps:322:pdap:344:pawserv:345:zserv:346:fatserv:347:csi-sgwp:348:mftp:349:matip-type-a:350:matip-type-b:351:bhoetty:351:dtag-ste-sb:352:bhoedap4:352:ndsauth:353:datex-asn:355:bhevent:357:shrinkwrap:358:tenebris_nts:359:scoi2odialog:360:semantix:361:srssend:362:rsvp_tunnel:363:aurora-cmgr:364:dtk:365:odmr:366:mortgageware:367:qbikgdp:368:rpc2portmap:369:clearcase:371:ulistproc:372:legent-1:373:legent-2:374:hassle:375:nip:376:tnETOS:377:dsETOS:378:is99c:379:is99s:380:hp-collector:381:hp-managed-node:382:hp-alarm-mgr:383:arns:384:ibm-app:385:asa:386:aurp:387:ldap:389:uis:390:synotics-relay:391:synotics-broker:392:dis:393:embl-ndt:394:netcp:395:netware-ip:396:mptn:397:kryptolan:398:iso-tsap-c2:399:work-sol:400:ups:401:genie:402:decap:403:nced:404:ncld:405:imsp:406:timbuktu:407:prm-sm:408:prm-nm:409:decladebug:410:rmt:411:synoptics-trap:412:smsp:413:infoseek:414:bnet:415:silverplatter:416:onmux:417:hyper-g:418:ariel1:419:smpte:420:ariel2:421:ariel3:422:opc-job-start:423:opc-job-track:424:icad-el:425:smartsdp:426:svrloc:427:ocs_cmu:428:ocs_amu:429:utmpsd:430:utmpcd:431:iasd:432:nnsp:433:mobileip-agent:434:mobilip-mn:435:dna-cml:436:comscm:437:dsfgw:438:dasp:439:sgcp:440:decvms-sysmgt:441:cvc_hostd:442:https:443:snpp:444:microsoft-ds:445:ddm-rdb:446:ddm-dfm:447:ddm-ssl:448:as-servermap:449:tserver:450:sfs-smp-net:451:sfs-config:452:creativeserver:453:contentserver:454:creativepartnr:455:macon-tcp:456:scohelp:457:appleqtc:458:ampr-rcmd:459:skronk:460:datasurfsrv:461:datasurfsrvsec:462:alpes:463:kpasswd:464:digital-vrc:466:mylex-mapd:467:photuris:468:rcp:469:scx-proxy:470:mondex:471:ljk-login:472:hybrid-pop:473:tcpnethaspsrv:475:ss7ns:477:spsc:478:iafserver:479:iafdbase:480:ph:481:bgs-nsi:482:ulpnet:483:integra-sme:484:powerburst:485:avian:486:saft:487:gss-http:488:nest-protocol:489:micom-pfs:490:go-login:491:ticf-1:492:ticf-2:493:pov-ray:494:intecourier:495:pim-rp-disc:496:dantz:497:siam:498:iso-ill:499:isakmp:500:stmf:501:asa-appl-proto:502:intrinsa:503:citadel:504:mailbox-lm:505:ohimsrv:506:crs:507:xvttp:508:snare:509:fcp:510:passgo:511:exec:512:login:513:shell:514:printer:515:videotex:516:talk:517:ntalk:518:utime:519:efs:520:ripng:521:ulp:522:ncp:524:timed:525:tempo:526:stx:527:custix:528:irc-serv:529:courier:530:conference:531:netnews:532:netwall:533:mm-admin:534:iiop:535:opalis-rdv:536:nmsp:537:gdomap:538:apertus-ldp:539:uucp:540:uucp-rlogin:541:commerce:542:klogin:543:kshell:544:appleqtcsrvr:545:dhcpv6-client:546:dhcpv6-server:547:afpovertcp:548:idfp:549:new-rwho:550:cybercash:551:deviceshare:552:pirp:553:rtsp:554:dsf:555:remotefs:556:openvms-sysipc:557:sdnskmp:558:teedtap:559:rmonitor:560:monitor:561:chshell:562:nntps:563:9pfs:564:whoami:565:streettalk:566:banyan-rpc:567:ms-shuttle:568:ms-rome:569:meter:570:meter:571:sonar:572:banyan-vip:573:ftp-agent:574:vemmi:575:ipcd:576:vnas:577:ipdd:578:decbsrv:579:sntp-heartbeat:580:bdp:581:scc-security:582:philips-vc:583:keyserver:584:imap4-ssl:585:password-chg:586:submission:587:cal:588:eyelink:589:tns-cml:590:http-alt:591:eudora-set:592:http-rpc-epmap:593:tpip:594:cab-protocol:595:smsd:596:ptcnameservice:597:acp:599:ipcserver:600:urm:606:nqs:607:sift-uft:608:npmp-trap:609:npmp-local:610:npmp-gui:611:hmmp-ind:612:hmmp-op:613:sshell:614:sco-inetmgr:615:sco-sysmgr:616:sco-dtmgr:617:dei-icda:618:digital-evm:619:sco-websrvrmgr:620:escp-ip:621:collaborator:622:aux_bus_shunt:623:cryptoadmin:624:dec_dlm:625:asia:626:passgo-tivoli:627:qmqp:628:rda:630:ipp:631:bmpp:632:servstat:633:ginad:634:rlzdbase:635:ldaps:636:lanserver:637:mcns-sec:638:msdp:639:entrust-sps:640:repcmd:641:sanity:643:dwr:644:pssc:645:ldp:646:dhcp-failover:647:rrp:648:aminet:649:obex:650:ieee-mms:651:udlr-dtcp:652:repscmd:653:aodv:654:tinc:655:spmp:656:rmc:657:tenfold:658:url-rendezvous:659:mac-srvr-admin:660:hap:661:pftp:662:purenoise:663:mdqs:666:doom:666:disclose:667:mecomm:668:meregister:669:vacdsm-sws:670:vacdsm-app:671:vpps-qua:672:cimplex:673:acap:674:dctp:675:vpps-via:676:vpp:677:ggf-ncp:678:mrm:679:entrust-aaas:680:entrust-aams:681:xfr:682:corba-iiop:683:corba-iiop-ssl:684:mdc-portmapper:685:hcp-wismar:686:asipregistry:687:realm-rusd:688:elcsd:704:agentx:705:borland-dsj:707:entrust-kmsh:709:entrust-ash:710:cisco-tdp:711:netviewdm1:729:netviewdm2:730:netviewdm3:731:netgw:741:netrcs:742:flexlm:744:fujitsu-dev:747:ris-cm:748:kerberos-adm:749:rfile:750:pump:751:qrh:752:rrh:753:tell:754:nlogin:758:con:759:ns:760:rxe:761:quotad:762:cycleserv:763:omserv:764:webster:765:phonebook:767:vid:769:cadlock:770:rtip:771:cycleserv2:772:submit:773:rpasswd:774:entomb:775:wpages:776:multiling-http:777:wpgs:780:concert:786:qsc:787:mdbs_daemon:800:device:801:fcp-udp:810:itm-mcell-s:828:pkix-3-ca-ra:829:rsync:873:iclcnet-locate:886:iclcnet_svinfo:887:accessbuilder:888:cddbp:888:omginitialrefs:900:xact-backup:911:ftps-data:989:ftps:990:nas:991:telnets:992:imaps:993:ircs:994:pop3s:995:vsinet:996:maitrd:997:busboy:998:garcon:999:puprouter:999:cadlock:1000:surf:1010:";
%connected = reverse %connected;

##sort and assign hash index array
my @ports = sort by_number keys %connected;

##look for list argument
&list if $ARGV[0] eq "list";

##attempt to connect to all ports in hash index, then display open ports
foreach $port (@ports) {
    $sock = IO::Socket::INET->new("$peer:$port");
    print "\nPort $port $connected{$port} open\n" if ($sock);
}
print "Done.\n";
exit;

##usage sub
sub usage {
        print "
  Portscanner 1.0

  Usage: portscan <server>
         portscan list\n\n";
	exit;
}

##list sub
sub list {
    foreach $port (@ports) {
	print "Port $port $connected{$port}\n";
    }
    exit;
}

##hash index sort sub
sub by_number {
    if ( $a < $b ) { -1 }
    elsif ( $a > $b ) { 1 }
    else { 0 }
}

=head1 NAME

    Portscanner 1.0 - Reports listening ports and their associated service

    =head1 Author

    James Loope, cronus@pcis.net

    =head1 Copyright

    Do with it what you please.

    =head1 DESCRIPTION

    See README

    =head1 README

    A portscanner for those of us who haven't memorized the common ports map. It scans all common
    ports between 1 and 1023 and reports open ports and their common use.

    =head1 PREREQUISITES

    This script requires IO::Socket

    =pod OSNAMES

    Linux

    =pod SCRIPT CATEGORIES

    Networking

    =cut
