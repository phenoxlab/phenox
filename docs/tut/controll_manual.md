# Control Phenox2 with joystick (manual)

This tutorial explains following works using Ubuntu14.04 as host-PC.

1. Startup Phenox2 from battery, connect to host-PC using ssh.  
2. Connect PS3 controller to host-PC and control Phenox2 manually from host-PC.

Also, please take care of following points.

 - Prepare wide and planer space(3m x 3m at least) without any object on the ground.  
 - Try experiment in indoor environment, and turn off air conditioner.  
 - Remember that flying Phenox2 can be stopped immediately by holding one of legs and tilt it largely.

# 0. Preparation on host-PC
If users try this tutorial for the first time, install "joystick" and "jstest-gtk".
```bash
hostpc@ sudo apt-get install joystick jstest-gtk
```

Download manual control software from Phenox Lab, then extract and build it.
```bash
hostpc@ wget http://phenoxlab.com/static/phenox_manual.tar.gz
hostpc@ tar zxvf phenox_manual.tar.gz
hostpc@ cd phenox_manual
hostpc@ make clean all
```

Connect PS3 controller (shown in Fig.1) to the host-PC with USB A-B cable, then check that it is recognized by device named such as "/dev/input/js0".
 
![Fig.1 PS3 controller and host-PC] (/img/phenox_tut/joystick.JPG)
<div align="center">Fig.1 PS3 controller and host-PC</div>

Launch "jstest-gtk", and check that values are chenged when users press button or move joystick. 
```bash
hostpc@ jstest-gtk
```

# 1. Setup supply power and communication
First, please check that 4 corners of main board are fixed to silicon ring correctly. Please setup supply power using battery as described in [Power supply](../start/power.md), and setup communication using ssh as described in [Communication](../start/com.md).
 
# 2. Create project
Copy tutorial to make custom projects as follows..

```bash
phenox# cd /root/phenox/work/
phenox# cp -a tutorial_manualnet myproject_manualnet
```
# 3. Build project
Build  myproject_manualnet as default setting.
```bash
phenox# cd /root/phenox/work/myproject_manualnet
phenox# make clean all
```
Now, executable file "main" is created.

# 4. Execute program
The sequence of this tutorial program are as follows.

1. Initialize CPU1(flight control system) for 3 seconds.
2. Launch simple TCP server and wait for coneection from host-PC.
3. After coneection, it is controlled manually according to the input of joystick of host-PC.

Before running program, please put Phenox2 on the ground and do not move it until message "CPU0:Finished Initialization" appears. If users move Phenox2 during initialization, CPU1 detects movement and stops initialization. When this happens, please reboot Phenox2 by "reboot" command.

Now, let's start "main".
```bash
phenox# ./main
```

# 5. Execute manual control program from host-PC and fly Phenox2.
Put Phenox2 on the planer ground so that front camera is heading forward. 

From host-PC, run manual control program (phenox_manual). Change device name according to user's environment.

```bash
hostpc@  cd phenox_manual
hostpc@ ./phenox_manual /dev/input/js0 192.168.2.1
```

When coneection is established correctly, message saying "connected to client" appears on terminal. In this tutorial, simple 2 button and 1 joystick controller is prepared as follows.  
 - cross === Phenox2 enters down state ('PX_DOWN') if it is in hovering state ('PX_HOVER').  
 - triangle === Phenox2 enters up state ('PX_UP') if it is in halt state('PX_HALT').  
 - left joystick === control degx and degy.  
  
To take off Phenox2, press triangle. Then, Phenox2 operates 3 seconds of start up of motors, and takes off (`PX_UP`), and enters hover state (`PX_HOVER`). 
Please move left joystick slowly to control Phenox2 horizontally when Phenox2 is in hovering state.  
Press cross button to let Phenox2 landing. If users want to stop flying Phenox2 immediately, please hold one of legs and tilt it largely.  

To shutdown Phenox2, type following command.
```bash
phenox# halt
```
