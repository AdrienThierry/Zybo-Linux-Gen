# Zybo-Linux-Gen
A collection of scripts that automatically generate everything needed to run Linux on a Zybo board.

## Dependencies
* Vivado toolchain
* dtc (device tree compiler)
* uboot-tools (for the _mkimage_ tool)

## Usage
Everything can be launched using **build.sh**

When everything is built, copy the contents of the automatically generated **sd_card** folder at the root of an SD card and put it in the Zybo.

If no option is used, everything will be built.

| Option                         | Description                                                                                                                 |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| -t [path] \| --toolchain [path] | **(optional)** Vivado toolchain location (default is **[HOME dir]/Xilinx/Vivado/[version]**) |
| -p \| --project                | generate Vivado project                                                                                                     |
| -b \| --bitstream              | generate bitstream                                                                                                          |
| -e \| --export                 | export hardware to SDK                                                                                                      |
| -f \| --fsbl                   | generate FSBL                                                                                                               |
| -d \| --devicetree             | generate device tree                                                                                                        |
| -r \| --rootfs                 | build rootfs                                                                                                                |
| -k \| --kernel                 | build Linux kernel                                                                                                          |
| -u \| --uboot                  | build uboot                                                                                                                 |
| -i \| --image                  | build boot image                                                                                                            |
