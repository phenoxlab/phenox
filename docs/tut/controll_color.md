# Fly Phenox2 tracking colored landmark(autonomous)

##Movie of flight
[![Alt text for your video](http://img.youtube.com/vi/CYNWzuIqtWc/0.jpg)](http://www.youtube.com/watch?v=CYNWzuIqtWc)

This tutorial explains following works using Ubuntu14.04 as host-PC.

1. Fly Phenox2 and let it track colored landmark.

Also, please take care of following points.

 - Prepare wide and planer space(3m x 3m at least) without any object on the ground.  
 - Try experiment in indoor environment, and turn off air conditioner.  
 - This tutorial needs colored landmark and expects no similar color in flight space. So please remove similar colored from flight space.
 - Remember that flying Phenox2 can be stopped immediately by holding one of legs and tilt it largely.
  
# 0. Prepare colored landmark
Please download and print following green mark with A4 size, and put on the center of flight space.  
```http://phenoxlab.com/static/colored_mark.pdf```  
Also, please remove similar color from the flight space.

# 1. Setup supply power and communication
Please setup supply power using battery as described in [Power supply](../start/power.md), and setup communication using ssh as described in [Communication](../start/com.md).
 
# 2. Create project
Copy tutorial to make custom projects as follows..

```bash
phenox# cd /root/phenox/work/
phenox# cp -a tutorial_colormark myproject_colormark
```
# 3. Build project
Build  myproject_colormark as default setting.
```bash
phenox# cd /root/phenox/work/myproject_colormark
phenox# make clean all
```
Now, executable file "main" is created.

# 4. Execute program
The sequence of this tutorial program are as follows.

1. Initialize CPU1(flight control system) for 3 seconds.
2. Wait for whisle sound printing selfstate. 
3. Start hovering when whisle sound is detected.
4. Hovers to track colored landmark keeping same height.

Before running program, please put Phenox2 on the ground and do not move it until message "CPU0:Finished Initialization" appears. If users move Phenox2 during initialization, CPU1 detects movement and stops initialization. When this happens, please reboot Phenox2 by "reboot" command.

Now, let's start "main".
```bash
phenox# ./main
```

After initialization, members of selfstate (`degx`, `degy`, `degz`, `vision_tx`, `vision_ty`, `vision_tz`, `height`) and number of feature points are printed in terminal.

# 5. Prepare flight environment (needed only first time of flight)
Please hold Phenox2 and check whether message ""CPU0: green mark is found at (x x)" is printed on terminal when the bottom camera sees colored landmark. Also move Phenox2 around other flight area and check that no message appears.

# 6. Fly Phenox2
After flight space is prepared, put Phenox2 on the ground closed to colored landmark, and blow whisle near Phenox2 strongly. Phenox2 operates 3 seconds of start up of motors, and takes off (`PX_UP`). Then, Phenox2 enters hover state (`PX_HOVER`) and fly to track colored landmark.

Then, move colored landmark slowly without disturbing height control of Phenox2. Users can see Phenox2 tracks the colored landmark.

# 7. Stop Phenox2
Flying Phenox2 can be stopped immediately by holding one of legs and tilt it largely.

To shutdown Phenox2, type following command.
```bash
phenox# halt
```
