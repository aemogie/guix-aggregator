(define-module (yggdrasil modules connman)
  #:use-module (gnu services)
  #:use-module ((yggdrasil system services networking)
                #:select (iwd-service-type
                          connman-service-type
                          connman-configuration)))

(define (system-services)
  (list
   (service iwd-service-type)
   (service
    connman-service-type
    (connman-configuration
     (main
      '((General
         ((AllowHostnameUpdates . #f)
          (AllowDomainnameUpdates . #f)
          (NetworkInterfaceBlacklist
           vmnet vboxnet virbr ifb docker veth eth wlan)))))
     (vpn-provisioning-files
      `((personal
         .
         ((provider_wireguard
           ((Type . WireGuard)
            (Name . Mullvad)
            (Host . "146.70.165.194")
            (WireGuard.Address . "10.64.111.164/32")
            (WireGuard.PrivateKey . ,(getenv "WG_SECRET")) ; client
            (WireGuard.PublicKey . "czE6NJ8CccA5jnJkKoZGDpMXFqSudeVTzxU5scLP/H8=") ; server
            (WireGuard.EndpointPort . 51820)
            (WireGuard.DNS . "10.64.0.1")
            (WireGuard.AllowedIPs . "0.0.0.0/0")))))))))))
