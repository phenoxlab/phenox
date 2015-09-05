# Extend Hardware

## I2C communication support
Phenox2 has I2C(Inter-Integrated Circuit) port to communicate with external I2C device, and I2C slave (other MCU, or sensors) can be connected to Phenox2.
  
Required command of I2C communication is conducted in Linux system of Phenox2 by using functions of "i2c-tools".
  
Here we explain example of how Phenox2 communicates with 3-axis accelerometer(KXP84-2050).
  
In Fig1, pin assign of I2C port is shown. Please solder 4 line of wires between Phenox2 to I2C slave.

![Fig.1  Pin assign of I2C master of Phenox2] (/img/phenox/i2c.jpg)
<div align="center">Fig.1  Pin assign of I2C master of Phenox2</div>

After power is supplied to I2C slave port, Please input command "i2cdetect" in Linux system of Phenox2 as shown in Fig.2.

![Fig.2 Running "i2cdetect" finds I2C slaves] (/img/phenox/i2c_com1.jpg)
<div align="center">Fig.2 Running "i2cdetect" finds I2C slaves</div>

Here we find that the number "0x18"  is shown, which is slave address of I2C slave(KXP84-2050).
  
Then, we are going to read acceleration value from this sensor, by sending "i2cget" command to access to register 0x04 . 

![Fig.3 Get data from specified register of I2C slave using "i2cget"] (/img/phenox/i2c_com2.jpg)
<div align="center">Fig.3 Get data from specified register of I2C slave using "i2cget"</div>

Here accelaration continues to change, and the result of "i2cget" changes accordingly.
  
Also, data can be written to specified register by using "i2cset" command. 

Please see document of "i2ctools for more detail. 

