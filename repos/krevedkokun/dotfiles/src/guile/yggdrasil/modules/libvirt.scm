(define-module (yggdrasil modules libvirt)
  #:use-module (gnu home services)
  #:use-module ((gnu packages firmware) #:select (ovmf-x86-64))
  #:use-module ((gnu packages linux) #:select (bridge-utils))
  #:use-module ((gnu packages spice) #:select (spice-vdagent))
  #:use-module ((gnu packages virtualization) #:select (virt-manager))
  #:use-module (gnu services)
  #:use-module ((gnu services sysctl) #:select (sysctl-service-type))
  #:use-module ((gnu services virtualization)
                #:select (libvirt-service-type
                          libvirt-configuration
                          virtlog-service-type))
  #:use-module (guix gexp))

(define (system-services)
  (list
   (simple-service 'libvirt-packages
     profile-service-type
     (list spice-vdagent bridge-utils virt-manager))
   (simple-service 'ovmf-firmware
     special-files-service-type
     `(("/usr/share/OVMF/OVMF_CODE.fd"
        ,(file-append ovmf-x86-64 "/share/firmware/ovmf_x64.bin"))
       ("/usr/share/OVMF/OVMF_VARS.fd"
        ,(file-append ovmf-x86-64 "/share/firmware/ovmf_vars_x64.bin"))))
   (simple-service 'hugepages
     sysctl-service-type
     '(("vm.nr_hugepages" . "4300")))
   (service libvirt-service-type)
   (service virtlog-service-type)))
