#Attention after starts running flight control CPU (CPU1)
Phenox2 starts caliblation of IMUs after it starts running flight control CPU (CPU1) for 3 seconds. During the calibration, put Phenox2 on the ground and don't move it. If users move Phenox2 during calibration, CPU1 detects movement and stops initialization. When this happens, please reboot Phenox2 by `reboot` command.
```bash
phenox# reboot
```
Here "starts running flight control CPU" means calling `pxinit_chain()` function of Language C from Linux system (CPU0) of Phenox2. Please refer to [Library](../dev/api) for detail.

#The way to stop flying Phenox2.
Hold one of legs or protector of flying Phenox2 and tilt it largely, and Phenox2 stops running motors immediately. Please wear eye protector when users conduct experiment. Also wearing gloves is recommended to prevent cutting hand by rotating propeller.

#Attention when changing battery 
Due to the compact design of main board, the access to the battery connector is limited. The main board is thin structure and easy to be bent and damaged. So please do not damage the main board when users change battery (Recommended method is described in [Power supply](power.md))

#Environment to fly Phenox2
Phenox2 estimates self-location using a bottom camera and an ultrasonic sonsor attached bottoms side of the frame. Please prepare wide and planer space in indoor (at least 3m x 3m) and cover the floor with visual feature points as shown in Fig.1.   
Also, please turn off air conditioner.

![Fig.1 Floor with many visual feature points and their location] (/img/phenox/feature.png)
<div align="center">Fig.1 Floor with many visual feature points and their location</div>
