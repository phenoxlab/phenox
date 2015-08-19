#C language API

# Basic function and getting self state fuction
### void pxinit_chain()    
Startup CPU1(flight control system) and initialzie parameters which are set in parameter.c. 
### int pxget_cpu1ready()
After executing `pxinit_chain()`, CPU1 starts initialization for 3 seconds, including IMU calibraion. During initialization, put Phenox on the ground and do not move it.  
 - Return 1 when CPU1 finishes initilization normally.  
 - Return 0 when CPU1 does not finish initilization.  
If user move Phenox2 during initialization, this function returns 0 forever, so please execute `reboot` to reboot Phenox2 and try it again.

### pxget_motorstatus()
- Return 1 when Phenox2 rotates motors.
- Return 0 when Phenox2 does not rotate motors.

### void pxget_pconfig(px_pconfig *param)
Save struct of physical parameters (`px_pconfig`) to local variable "param".

### void pxset_pconfig(px_pconfig *param)
Reflect physical parameters which is set in local variable "param" to CPU1(flight control system). If users want to change parameters partially, copy current physical parameters using `pxget_pconfig()`, change parameters, and call this function as follows. 
```bash
  px_selfstate st;
  pxget_selfstate(&st);
  st.duty_hover = 1800;
  pxset_pconfig(&st);
~~~

### void pxget_selfstate(px_selfstate *state)
Copy struct of selfstate (`px_selfstate`) local variable "state". Please see [Selfstate](../dev/state.md) for each members.

### void pxset_keepalive()
Send keep alive message from CPU0(Linux) to CPU1(flight control system). This function must be called periodically to CPU1 by users.

### int pxget_battery()
 - Return 1 when battery is nearly out.
 - Return 0 when battery is not nearly out.

When Phenox2 is in flight state (`PX_UP` or `PX_HOVER`) and battery becomes nearly out, CPU1 goes Phenox2 to down state (`PX_DOWN`) automatically. Down state conitinues for specified time which is written in `downtime_max`, a member of `px_config` struct (Please see [Parameters](../dev/api.md)).
Then, users have to shutdown Phenox2 by executing `halt` command manually.


### px_flymode pxget_operate_mode()
 Get current flight mode. 
 - `PX_HALT` means Phenox2 is suspend state.  
 - ~PX_UP~ means Phenox2 is up state.  
 - ~PX_HOVER~ means Phenox2 is hover state.  
 - ~PX_DOWN~ means Phenox2 is down state.  
 
### void pxset_operate_mode(`px_flymode` mode)
Change flight mode to 4 states of `px_flymode` (`PX_HALT`, `PX_UP`, `PX_HOVER`, `PX_DOWN`).   
If argument "mode" is set to `PX_UP`, Phenox2 starts rotating propllers (inserting 3 second of startup period if previous state is `PX_HALT`) and going up for a specified time which is written in `uptime_max`, a member of `px_config` struct. Then, Phenox2 enters `PX_HOVER` state automatically by CPU1. 
When flight mode is `PX_UP` state, Phenox2 makes static thrust specified in ~duty_up", a member of `px_config` struct, in which ultrasonic sensor is not used to controll height.  
If  current flight mode is `PX_HOVER` and argument "mode" is set to `PX_DOWN`, Phenox2 goes down for a specified time which is written in `downtime_max`, a member of `px_config` struct. Then, Phenox2 enters `PX_HALT` state automatically by CPU1. 

### void pxset_visioncontrol_xy(float tx, float ty)
Controll horizontal movement(axis X and Y) when it is in hovering state(`pxget_operate_mode() == PX_HOVER`), estimated by visual feature points of bottom camera.
Phenox2 calculate deviation of target potision(`tx`,`ty`) from current position (`vision_tx`, `vision_tx`  defined in `px_selfstate`), and try to go to target position (`tx`,`ty`). 

Behavior to track the target position is defined by two parameters for each axis,  which are named `pgain_vision_tx`, `pgain_vision_ty`(P-gain) and `dgain_vision_tx`, `dgain_vision_ty` (D-gain), members of  `px_pconfig`.

Horizontal position (`vision_tx`, `vision_tx`) is represented by image coordinate, so users need to fix it to real coordinate considering height from the ground.
For actual usage, please refer to [Move Phenox2 horizontally during flight(autonomous)](../tut/controll_move.md)

### void pxset_rangecontrol z(float tz)
Controll vertical movement(axis Z) when it is in hovering state(`pxget_operate_mode() == PX_HOVER`), estimated by ultrasonic snesor .

Phenox2 calculate deviation of target potision(`tz`) from current position (`height` defined in `px_selfstate`), and try to go to target position (`tz`). 

Behavior to track the target position is defined by two parameters which are named `pgain_sonar_tz`(P-gain) and `dgain_sonar_tz`(D-gain), members of `px_pconfig`.

### void pxset_dst_degx(float val)
Controll angle of `degX`, which is defined in [Principal Axes](../start/directions.md) when Phenox2 is in hovering state(`pxget_operate_mode() == PX_HOVER`).

This function is not affected by horizontal location estimated by visual feature points of bottom camera (`vision_tx`, `vision_tx`  defined in `px_selfstate`), but only angle calculated using IMUs(`degx` in `px_selfstate`).   

Argument `val` is represented in 180 degrees notation, and -10~10 is recommended for safety drive.  

When this function is called, previsouslly called `pxset_visioncontrol_xy()` is disabled, and vice versa.

For actual usage, please refer to [Controll Phenox2 with joystick (manual)](../tut/controll_manual.md)

### void pxset_dst_degy(float val)
Controll angle of `degY`, which is defined in [Principal Axes](../start/directions.md) when Phenox2 is in hovering state(`pxget_operate_mode() == PX_HOVER`).

This function is not affected by horizontal location estimated by visual feature points of bottom camera (`vision_tx`, `vision_tx`  defined in `px_selfstate`), but only angle calculated using IMUs(`degy` in `px_selfstate`).   

Argument `val` is represented in 180 degrees notation, and -10~10 is recommended for safety drive.  

When this function is called, previsouslly called `pxset_visioncontrol_xy()` is disabled, and vice versa.

For actual usage, please refer to [Controll Phenox2 with joystick (manual)](../tut/controll_manual.md)

### void pxset_dst_degz(float val)
Controll angle of `degZ`, which is defined in [Principal Axes](../start/directions.md) when Phenox2 is in hovering state(`pxget_operate_mode() == PX_HOVER`).

Argument `val` is represented in 180 degrees notation, and is represented as relative angle from the angle of start hovering.

### int pxset_visualselfposition(float tx,float ty)
Fix `vision_tx`, `vision_tx` defined in `px_selfstate` to specified value "tx","ty". Thus, this function affects the result of `pxset_visioncontrol_xy()` function. (For this reasons, argument of `pxset_visioncontrol_xy()` shuld be given as relative potision from `vision_tx`, `vision_tx`).

This function is used when users want to reset current horizontal positions estimated by visual feature points of bottom camera.

For actual usage, please refer to [Fly Phenox2 with colored landmark(autonomous)](../tut/controll_color.md)

# Visual Processing
### int pxget_imgfullwcheck(px_cameraid cam, IplImage **img)
Copy image derived from specified camera given by argument "cam" (`PX_FRONT_CAM`, `PX_BOTTOM_CAM`) to "img" (IplImage is the structure defined by OpenCV).

"img" needs to be initialized by using `cvCreateImage` before this function is called. The image size is fixed to QVGA (320x240) and can be obtained  30 frame per second.

Also, users have to call `pxset_img_seq()` periodically (about 100 times per second) to when this function is used.

### void pxset_img_seq(px_cameraid cam)
This function preprocess image before users get image by calling `pxget_imgfullwcheck()`.

Specifically, this functions copy images from private memory in which image data is written by FPGA, to another private double buffers converting YUV422 format to RGB format.

This function must be called periodically (about 100 times per second) by users  if users want to use `pxget_imgfullwcheck()`. 

### int pxset_imgfeature_query(px_cameraid cam)
This fuction sends a query to CPU1 to get numbers and each locations of visual feature points derived by a camera which is specified by argument "cam" (`PX_FRONT_CAM`, `PX_BOTTOM_CAM`) . 
 - Return 1 when a query is accepted by CPU1.
 - Return -1 when a query is already accepted by CPU1.

### int pxget_imgfeature(px_imgfeature *ft,int maxnum)
This function returns the number of visual feature points after `pxset_imgfeature_query()` is called.
 - Return number of visual feature points, and information of visual feature points are saved to "ft". 
 - Return -1 when CPU1 is in processing, or no query of `pxset_imgfeature_query()` is received by CPU1.

Struct `px_imgfeature` consists of location of a visual feature point(`cx`,`cy`) and that of 5 frames before(`pcx`,`pcy`).

Argument "ft" needs to be initialized with maximum numbers of visual feature points to be saved (argument "maxnum").

### int pxset_blobmark_query(px_cameraid cam, float min_y, float max_y, float min_u,float max_u, float min_v, float max_v)

This function sends a query to CPU1 to calculate mass and center of color blob, which is filtered by following arguments represented in YUV422 space,
 - "min_y" < y < "max_y"  
 - "min_u" < u < "max_u"  
 - "min_v" < v < "max_v"  
,which is derived by a camera which is specified by argument "cam" (`PX_FRONT_CAM`, `PX_BOTTOM_CAM`). 
  
 - Return 1 when a query is accepted by CPU1.
 - Return -1 when a query is already accepted by CPU1.

For actual usage, please refer to [Fly Phenox2 with colored landmark(autonomous)](../tut/controll_color.md)

### int pxget_blobmark(float *x,float *y, float *size)
This function returns the mass and center of color blob after `pxset_blobmark_query()` is called.

 - Return 1, location of center of color blob is copied to "x" and "y", and total mass of color blob is copied to "size"
 - Return -1 when CPU1 is in processing, or no query of `pxset_blobmark_query()` is received by CPU1.

For actual usage, please refer to [Fly Phenox2 with colored landmark(autonomous)](../tut/controll_color.md)

# Sound processing
### int pxget_whisle_detect()
This function detects 3kHz of whisle sound.
 - Return 1 when Phenox2 detects 3kHz sound after `pxset_whisle_detect_reset()` is called.
 - Return 0 when Phenox2 doesn't detect 3kHz sound after `pxset_whisle_detect_reset()` is called.

The sensitivity to detect whisle can be changed by modifying `whisleborder` a member of `px_pconfig`.

### void pxset_whisle_detect_reset()
This function resets current state of whisle detection and be used before `pxget_whisle_detect()` is called. 

### int pxset_sound_recordquery(float recordtime)
This function sends a query to CPU1 to record sound for a specified period given by argumenr "recordtime".

The format of sound signal is aligned to short 16bit raw data, and sampling rate is 10 kHz.

### int pxget_sound_recordstate()
This function returns the state of CPU1 after `pxset_sound_recordquery()` is called.  

 - Return 1 when CPU1 finishes a query of `pxset_sound_recordquery()`.  
 - Return -1 when CPU1 is in processing, or no query of `pxset_sound_recordquery()` is received by CPU1.  

### int pxget_sound(short *buffer, float recordtime)
This function writes sound data to "buffer" for the time period specified by "recordtime".  

The format of sound signal is aligned to short 16bit raw data, and sampling rate is 10 kHz.  

Before calling this function, users need to call `pxset_sound_recordquery()` and gets "1" from `pxget_sound_recordstate()`.  

Also, "buffer" needs to be initialized beforehand to save enough time of data specified by "recordtime".  

For actual usage, please refer to [Get image and sound](../tut/build.md).

# Debug
### void pxset_led(int led, int state)
This function turns on and off(on = 1, off = 0) of specified LED (0,1).

### void pxset_buzzer(int state)
This function turns on and off buzzer(on = 1, off = 0), and frequency of buzzer is 4kHz.
### void pxset_systemlog()
This functions writes log of CPU1 to "/mnt/boot/systemlog.txt" and needs to be called periodically by users.
