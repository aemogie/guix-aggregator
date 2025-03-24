(define-module (operating-systems buer files)
  #:use-module (gnu)
  #:export (thinkfan-config))

(define thinkfan-config
  (plain-file "thinkfan.conf"
              "\
fans:
- tpacpi: /proc/acpi/ibm/fan
sensors:
  - hwmon: /sys/devices/platform/coretemp.0/hwmon
    indices: [1,2,3]
levels:
  - [0,                      0,   46]
  - [1,                     44,   48]
  - [2,                     46,   50]
  - [3,                     48,   52]
  - [4,                     50,   54]
  - [5,                     52,   56]
  - [6,                     54,   58]
  - [7,                     56,   60]
  - [\"level full-speed\",  58,  250]"))
