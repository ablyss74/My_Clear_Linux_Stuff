#  Unofficial CL Installer
### 
### 
### This is small shell script I made to create a Clear Linux installation on a separate sdd drive or use simply as an ISO with libvirtd,
### As the default GUI installer is sometimes buggy and no clear XFS option.
### Once installation is complete use gparted to manually resize the new SDD partition to full capacity if desired ( practical for desktop environments ),
### Then use the BIOS UEFI boot menu to boot.
### Don't forget to update your password.

### 

###     - Stable Version:
####    - How to install: open terminal type `sudo bash ./unofficial_cl_installer.bash`.
#
###     - SPECS
####    - Super fast installation of Clear linux on separate drive.  
####    - Easily install to ext[2,3,4], xfs, or f2fs filesystem.
####    - Default Password: foobar0000
####    - 12GB base size, however...
####    - Before rebooting, run gparted to resize the partition for large bundles.


###    - REQUIRED BUNDLES
####   - swupd bundle-add clr-installer
####   - swupd bundle-add gparted #for resizing SDD partition
    

        
