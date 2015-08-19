# Selfstate (px_selfstate)

### float degx
Self degree around degX, which is represented in 180 degrees notation. 
Please refer to [Principal Axes](../start/directions.md) for definition.

### float degy
Self degree around degY, which is represented in 180 degrees notation. 
Please refer to [Principal Axes](../start/directions.md) for definition.

### float degz
Self degree around degZ, which is represented in 180 degrees notation. 
Please refer to [Principal Axes](../start/directions.md) for definition.

### float vision_tx
Self location of X axis estimated by visual feature points using bottom camera, which is  represented by image coordinate.

### float vision_ty
Self location of Y axis estimated by visual feature points using bottom camera, which is  represented by image coordinate.

### float vision_tz
Self location of Z axis estimated by visual feature points using bottom camera, which is represented by image coordinate.

### float vision_vx
Self velocity of X axis estimated by visual feature points using bottom camera, which is represented by image coordinate.

### float vision_vy
Self velocity of Y axis estimated by visual feature points using bottom camera, which is represented by image coordinate.

### float vision_vz
Self velocity of Z axis estimated by visual feature points using bottom camera, which is represented by image coordinate.

### float height
Height from ground measured from ultrasonic sensor, which is represented in cm.
This value is always 0 when Phenox2 is not hovering state (`PX_HOVER`) and measureble range is 60cm to 200cm.

### int battery
Indicate battery state, return 1 when battery is nealy out.
