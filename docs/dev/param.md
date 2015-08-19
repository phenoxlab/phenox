# Parameters
### float duty_hover
Basic thrust when Phenox2 is in hovering state (`PX_HOVER`). PD gain parameters  specified by P-gain(`pgain_sonar_tz`) and D-gain(`dgain_sonar_tz`) are added to this basic thrust, which is measured by ultrasonic sensor..

This parameters should be changed according to payload of Phenox2, ranging from 1800 to 2200.

### float duty_hover_max
Maximum thrust when Phenox2 is in hovering state (`PX_HOVER`).
This parameters should be changed according to payload of Phenox2, ranging from `duty_hover+150` to `duty_hover+250`.

### float duty_hover_min
Minimum thrust when Phenox2 is in hovering state (`PX_HOVER`).
This parameters should be changed according to payload of Phenox2, ranging from `duty_hover-150` to `duty_hover-250`.

### float duty_up
Thrust when Phenox2 is in rise state (`PX_UP`).  
This parameters should be changed according to payload of Phenox2, ranging from `duty_hover+150` to `duty_hover+250`.

### float duty_down
Thrust when Phenox2 is in down state (`PX_DOWN`).  
This parameters should be changed according to payload of Phenox2, ranging from `duty_hover-150` to `duty_hover-250`.

### float duty_bias_front
Additional thrust to front motor.
This parameters should be changed according to the location of a center of mass, ranging from `-300` to `300`.

### float duty_bias_back
Additional thrust to back motor.
This parameters should be changed according to the location of a center of mass, ranging from `-300` to `300`.

### float duty_bias_left
Additional thrust to left motor.
This parameters should be changed according to the location of a center of mass, ranging from `-300` to `300`.

### float duty_bias_right
Additional thrust to right motor.
This parameters should be changed according to the location of a center of mass, ranging from `-300` to `300`.

### float pgain_vision_tx
P-gain parameter of X axis specified by `pxset_visioncontrol_xy()`.

### float pgain_vision_ty
P-gain parameter of Y axis specified by `pxset_visioncontrol_xy()`.

### float dgain_vision_tx
D-gain parameter of X axis specified by `pxset_visioncontrol_xy()`.

### float dgain_vision_ty
D-gain parameter of Y axis specified by `pxset_visioncontrol_xy()`.

### float pgain_sonar_tz
P-gain parameter of Z axis specified by `pxset_rangecontrol_z()`.

### float dgain_sonar_tz
D-gain parameter of Z axis specified by `pxset_rangecontrol_z()`.

### int whisleborder
Border of whisle detection used by `pxget_whisle_detect()`.
When this value is smaller, whisle detection has more sensitivity to detect smaller sound.

### float uptime_max
Time (second) of rise state (PX_UP) when `pxset_operate_mode(PX_UP)` is called.
Phenox2 enters `PX_HOVER` state automatically by CPU1 after this time.

### float downtime_max
Time (second) of down state (PX_DOWN) when `pxset_operate_mode(PX_DOWN)` is called.
Phenox2 enters `PX_HALT` state automatically by CPU1 after this time.

### int featurecontrast_front
Contrast of visual feature points detection of front camera  used by `pxset_imgfeature_query()` and `pxget_imgfeature()` functions.
If this value is larger, less visual feature points are found, but become more robust to noise.

### int featurecontrast_bottom
Contrast of visual feature points detection of bottom camera used by `pxset_imgfeature_query()` and `pxget_imgfeature()` functions.
If this value is larger, less visual feature points are found, but become more robust to noise.

### float pgain_degx
P-gain around degX during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### float pgain_degy
P-gain around degY during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### float pgain_degz
P-gain around degZ during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### float dgain_degx
D-gain around degX during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### float dgain_degy
D-gain around degY during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### float dgain_degz
D-gain around degZ during flight state(`PX_UP`,`PX_HOVER`,`PX_DOWN`). Change this value according to payload and external noise.

### int pwm_or_servo
Reserved parameter.

### int propeller_monitor
Reserved parameter. 
