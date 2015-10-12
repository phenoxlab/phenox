# Fly Phenox2(autonomous)

This tutorial explains following works using Ubuntu14.04 as host-PC.

1. Startup Phenox2 from battery, connect to host-PC using ssh.  
2. Check self state (px_selfstate).
3. Prepare flight space checking number of visual feature points from bottom camera.
4. Put Phenox2 on the ground, and blow whisle to start hovering autonomously.

Also, please take care of following points.

 - Prepare wide and planer space(3m x 3m at least) without any object on the ground.  
 - Try experiment in indoor environment, and turn off air conditioner.  
 - Remember that flying Phenox2 can be stopped immediately by holding one of legs and tilt it largely.
  
# 1. Setup supply power and communication
Please setup supply power using battery as described in [Power supply](../start/power.md), and setup communication using ssh as described in [Communication](../start/com.md).
 
# 2. Create project
Copy tutorial to make custom projects as follows..

```bash
phenox# cd /root/phenox/work/
phenox# cp -a tutorial_autohover myproject_autohover
```
# 3. Build project
Build  myproject_autohover as default setting.
```bash
phenox# cd /root/phenox/work/myproject_autohover
phenox# make clean all
```
Now, executable file "main" is created.

# 4. Execute program
The sequence of this tutorial program are as follows.

1. Initialize CPU1(flight control system) for 3 seconds.
2. Wait for whisle sound printing selfstate. 
3. Start hovering when whisle sound is detected.
4. Hovers at same position. Users grub one of legs of Phenox2 and tilt it largely to stop Phenox2.

Before running program, please put Phenox2 on the ground and do not move it until message "CPU0:Finished Initialization" appears. If users move Phenox2 during initialization, CPU1 detects movement and stops initialization. When this happens, please reboot Phenox2 by "reboot" command.

Now, let's start "main".
```bash
phenox# ./main
```

After initialization, members of selfstate (`degx`, `degy`, `degz`, `vision_tx`, `vision_ty`, `vision_tz`, `height`) and number of feature points are printed in terminal.

# 5. Prepare flight environment (needed only first time of flight)
Please hold Phenox2 and move above flight space to check number of feature points, and put markers on the ground if needed. 15 feature points are enough to estimate self position stably.

# 6. Fly Phenox2
After flight space is prepared, put Phenox2 on the ground, and blow whisle near Phenox2 strongly. Phenox2 operates 3 seconds of start up of motors, and takes off (`PX_UP`). Then, Phenox2 enters hover state (`PX_HOVER`) and try to fly at same position.

# 7. Stop Phenox2
Flying Phenox2 can be stopped immediately by holding one of legs and tilt it largely.

To shutdown Phenox2, type following command.
```bash
phenox# halt
```

##Movie of flight
[![Alt text for your video](http://img.youtube.com/vi/CYNWzuIqtWc/0.jpg)](http://www.youtube.com/watch?v=CYNWzuIqtWc)
