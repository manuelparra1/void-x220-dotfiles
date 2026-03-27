- [x] 1. Introduction to VPNs
- [x] 2. IPsec (Internet Protocol Security)
- [x] 3. Cisco IPsec Tunnel Mode Configuration
- [x] 4. Encrypted GRE Tunnel with IPSEC
- [x] 5. IPSec Static Virtual Tunnel Interface
- [ ] 6. IPSec VTI Virtual Tunnel Interface
- [x] 7. Introduction to DMVPN
- [x] 8. DMVPN Phase 1 Basic Configuration
- [x] 9. DMVPN Phase 1 EIGRP Routing
- [x] 10. DMVPN Phase 1 OSPF Routing
- [x] 11. DMVPN Phase 1 BGP Routing
- [x] 12. DMVPN Phase 2 Basic Configuration
- [x] 13. DMVPN Phase 2 EIGRP Routing
- [x] 14. DMVPN Phase 2 OSPF Routing
- [x] 15. DMVPN Phase 2 BGP Routing
- [x] 16. DMVPN Phase 3 Basic Configuration
- [ ] 17. DMVPN Phase 3 RIP Routing
- [x] 18. DMVPN Phase 3 EIGRP Routing
- [x] 19. DMVPN Phase 3 OSPF Routing
- [x] 20. DMVPN Phase 3 BGP Routing
- [x] 21. DMVPN over IPsec
- [x] 22. DMVPN Per-Tunnel QoS
- [x] 23. DMVPN IPv6 over IPv4
- [x] 24. DMVPN Dual Hub Single Cloud
- [x] 25. DMVPN Dual Hub Dual Cloud
- [ ] 26. Introduction to FlexVPN
- [ ] 27. FlexVPN Site-to-Site Smart Defaults
- [ ] 28. FlexVPN Site-to-Site without Smart Defaults
- [ ] 29. FlexVPN PKI Authentication
- [ ] 30. FlexVPN IKEv2 Routing
- [ ] 31. FlexVPN Hub and Spoke
- [ ] 32. FlexVPN Spoke to Spoke
- [ ] 33. FlexVPN Spoke to Spoke Pool and BGP
- [ ] 34. FlexVPN Remote Access AnyConnect
- [ ] 35. MPLS over FlexVPN
- [ ] 36. L2TPv3 (Layer 2 Tunnel Protocol Version 3)
- [ ] 37. Group Encrypted Transport VPN (GETVPN)

```shell
$ pwd
/home/dusts/Downloads/NetworkLessons - VPNs

$ ls
'Introduction to VPNs.md'
'DMVPN Phase 3 Basic Configuration.md'
'DMVPN Phase 2 OSPF Routing.md'
'DMVPN Phase 1 BGP Routing.md'
'DMVPN Phase 2 Basic Configuration.md'
'Introduction to DMVPN.md'
'DMVPN Phase 1 OSPF Routing.md'
'DMVPN Phase 3 EIGRP Routing.md'
'DMVPN Phase 1 EIGRP Routing.md'
'DMVPN Phase 2 BGP Routing.md'
'DMVPN Phase 1 Basic Configuration.md'
'DMVPN Phase 2 EIGRP Routing.md'
'DMVPN over IPsec.md'
'DMVPN Phase 3 OSPF Routing.md'
'DMVPN Phase 3 BGP Routing.md'
'IPSec (Internet Protocol Security).md'
'Encrypted GRE Tunnel with IPSEC.md'
'Cisco IPsec Tunnel Mode Configuration.md'
'IPSec Static Virtual Tunnel Interface.md'
file_0020.md
'DMVPN Per-Tunnel QoS.md'
'DMVPN IPv6 over IPv4.md'
'DMVPN Dual Hub Dual Cloud.md'
'DMVPN Dual Hub Single Cloud.md'
images
vpns_course_list.html
vpns_course_list.md
```

> Can you help write a script that renames all these markdown files with a number prefix like `vpn_00x_` I use this markdoiwn list tracker to see what I have and they are numbered sequentially

```bash
#!/bin/bash
cd "/home/dusts/Downloads/NetworkLessons - VPNs"

declare -A map=(
  ["Introduction to VPNs.md"]="vpn_001_Introduction_to_VPNs.md"
  ["IPSec (Internet Protocol Security).md"]="vpn_002_IPsec_Internet_Protocol_Security.md"
  ["Cisco IPsec Tunnel Mode Configuration.md"]="vpn_003_Cisco_IPsec_Tunnel_Mode_Configuration.md"
  ["Encrypted GRE Tunnel with IPSEC.md"]="vpn_004_Encrypted_GRE_Tunnel_with_IPSEC.md"
  ["IPSec Static Virtual Tunnel Interface.md"]="vpn_005_IPSec_Static_Virtual_Tunnel_Interface.md"
  ["IPSec VTI Virtual Tunnel Interface.md"]="vpn_006_IPSec_VTI_Virtual_Tunnel_Interface.md"
  ["Introduction to DMVPN.md"]="vpn_007_Introduction_to_DMVPN.md"
  ["DMVPN Phase 1 Basic Configuration.md"]="vpn_008_DMVPN_Phase_1_Basic_Configuration.md"
  ["DMVPN Phase 1 EIGRP Routing.md"]="vpn_009_DMVPN_Phase_1_EIGRP_Routing.md"
  ["DMVPN Phase 1 OSPF Routing.md"]="vpn_010_DMVPN_Phase_1_OSPF_Routing.md"
  ["DMVPN Phase 1 BGP Routing.md"]="vpn_011_DMVPN_Phase_1_BGP_Routing.md"
  ["DMVPN Phase 2 Basic Configuration.md"]="vpn_012_DMVPN_Phase_2_Basic_Configuration.md"
  ["DMVPN Phase 2 EIGRP Routing.md"]="vpn_013_DMVPN_Phase_2_EIGRP_Routing.md"
  ["DMVPN Phase 2 OSPF Routing.md"]="vpn_014_DMVPN_Phase_2_OSPF_Routing.md"
  ["DMVPN Phase 2 BGP Routing.md"]="vpn_015_DMVPN_Phase_2_BGP_Routing.md"
  ["DMVPN Phase 3 Basic Configuration.md"]="vpn_016_DMVPN_Phase_3_Basic_Configuration.md"
  ["DMVPN Phase 3 RIP Routing.md"]="vpn_017_DMVPN_Phase_3_RIP_Routing.md"
  ["DMVPN Phase 3 EIGRP Routing.md"]="vpn_018_DMVPN_Phase_3_EIGRP_Routing.md"
  ["DMVPN Phase 3 OSPF Routing.md"]="vpn_019_DMVPN_Phase_3_OSPF_Routing.md"
  ["DMVPN Phase 3 BGP Routing.md"]="vpn_020_DMVPN_Phase_3_BGP_Routing.md"
  ["DMVPN over IPsec.md"]="vpn_021_DMVPN_over_IPsec.md"
  ["DMVPN Per-Tunnel QoS.md"]="vpn_022_DMVPN_Per-Tunnel_QoS.md"
  ["DMVPN IPv6 over IPv4.md"]="vpn_023_DMVPN_IPv6_over_IPv4.md"
  ["DMVPN Dual Hub Single Cloud.md"]="vpn_024_DMVPN_Dual_Hub_Single_Cloud.md"
  ["DMVPN Dual Hub Dual Cloud.md"]="vpn_025_DMVPN_Dual_Hub_Dual_Cloud.md"
)

for old in "${!map[@]}"; do
  new="${map[$old]}"
  if [[ -f "$old" ]]; then
    mv "$old" "$new" && echo "Renamed: $old → $new"
  fi
done
```

Save as `rename_vpn.sh`, make executable (`chmod +x rename_vpn.sh`), then run `./rename_vpn.sh`. Script maps each file to its sequential `vpn_00X_` name based on your checklist and safely renames only existing files.
