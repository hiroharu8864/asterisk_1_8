asterisk_1_8 Cookbook
=====================
Recipe for install asterisk1.8 to CentOS  
VagrantのCentOS環境にAsterisk1.8のインストールを行う。

PreRequirement
-----
$ vagrant box add base64 CentOS-6.3-x86_64-v20130101.box

Usage
-----
#### asterisk_1_8::default
TODO: Write usage instructions for each cookbook.

```vm.box
   cfg.vm.box = "base64"
```

```json
  "run_list":[
    "recipe[asterisk_11::default]",
    "recipe[asterisk_11::ntp]",
    "recipe[asterisk_11::asterisk]"
  ]
```

License and Authors
-------------------
Authors: Hiroharu Tanaka
