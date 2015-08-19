# Get image and sound

This tutorial explains following works using Ubuntu14.04 as host-PC.

1. Start up Phenox2 from external supply plug, and try two communication method (using serial communication board and ssh connection).  
2. Check how to use APIs of image processing sound processing.
3. Create and build user's custom project.
4. Changing source code and rebuild project. 

# 1. Setup supply power and communication
Please setup supply power using external supply plug as described in [Power supply](../start/power.md), and setup communication using serial communication board as described in [Communication](../start/com.md).

Then, turn power switch on and finish to login to Phenox2 with serial communication board. 
 
# 2. ssh connection 
Please setup communication using ssh as described in [Communication](../start/com.md).

Now, user communicates with Phenox2 with two method (wired and wireless method).
From now on, please choose prefered communication method. 

# 3. Create project
Copy tutorial to make custom projects as follows..

```bash
phenox# cd /root/phenox/work/
phenox# cp -a tutorial1 myproject1
```
# 4. Build project
Build  myproject1 as default setting.
```bash
phenox# cd /root/phenox/work/myproject1
phenox# make clean all
```
Now, executable file "main" is created.

# 5. Execute program
The sequence of this tutorial program are as follows.

1. Initialize CPU1(flight control system) for 3 seconds.
2. Get 10 pcs of images with visual feature points taken from front camera.
3. 5 seconds of recording of sound, and save it as `sound.raw`.
4. Waiting for whisle sound made by users.

Before running program, please put Phenox2 on the ground and do not move it until message "CPU0:Finished Initialization" appears. If users move Phenox2 during initialization, CPU1 detects movement and stops initialization. When this happens, please reboot Phenox2 by "reboot" command.

Now, let's start "main".
```bash
phenox# ./main
```

After 10pcs of images are saved, message "CPU0: sound record for 5.0 seconds" appears, so please talk something to Phenox2.

After that, message "CPU0: waiting for whisle" appears, so please blow 3kHz whisle near Phenox2. Then, program is finished.

If user login to Phenox2 using ssh with X11 forwarding option, users can directly access to the directory with file manager as following command.

```bash
phenox# nautilus .
```

Directory is also accessible from host-PC by reading contents of microSD. Insert microSD card of host-PC, and check folder of `/root/phenox/work/myproject1`.

# 6. Changing source code and rebuild

Please read source code of main.c and parameter.c, edit something, and try rebuild. 
```bash
cd /root/phenox/work/myproject1
make clean all
```
Then, modified "main" program is created.

# 7. shutdown
To shutdown Phenox2, type following command.
```bash
phenox# halt
```
