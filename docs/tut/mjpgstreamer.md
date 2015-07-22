In this tutorial we will show you how to setup streaming to web browser using `mjpg-streamer` utility. It is assumed that host machine is running Ubuntu14.04, but same steps can easily be applied to other operating systems.

# 1. Switch Phenox2 on
Insert MicroSD card into corresponding slot. Plug battery or power cable into power connector socket on Phenox2 main board. Turn the power switch on. You will see blue LED lit, which means that Linux is now starting.

# 2. Establish ssh connection
1. Connect on the host machine to WiFi network `phenoxnet` using password `phenoxnet`.
2. Open terminal and connect to the Phenox2 with following command:
```bash
ssh root@192.168.2.1
```
If you wish you may use option `-X` to enable X11 forwarding.

# 3. Running `mjpg-streamer`
1. `cd` to `~/mjpg-streamer/mjpg-streamer-experimental/` directory
2. Execute `./start.sh`
3. Open http://192.168.2.1:8080 in you host machine's browser. You can view realtime stream and static snapshots from Phenox2 on corresponding pages. Also you may access http stream directly using address http://192.168.2.1:8080/?action=stream and even open it in VLC player (Note: beacause VLC player uses buffering, time delays can be significant)

# 4. Customizing `mjpg-streamer`
## 4.1. Small introduction to `mjpg-streamer`
`mjpg-streamer` is very small, resource-effective and very fast streaming program. 
`mjpg-streamer` utility acts like a pipe, which connects two different programs. Programs, or so-called plugins, are compiled as shared objects and each represents different input or output methods. `mjpg-streamer` searches for plugins in directory specified by environment variable `LD_LIBRARY_PATH`. To set it to current directory call:
```bash
export LD_LIBRARY_PATH="$(pwd)"
```

By default input plugin is set to input_phenox and output plugin is set to output_http. You can change this if you like, but this feature was not completely tested. Each plugin comes with own settings which you can adjust to your needs. Settings are passed to plugin using command line arguments. Below you can find these arguments and their description:

### input_phenox settings

| Short option | Long option | Description |
|--------------|-------------|-------------|
|`-c` | `--camera`| ID of a camera, 0 for front, 1 for bottom |
|`-q` | `--quality`| JPEG quality, from 1 to 100 |

### output_http settings

| Short option | Long option | Description |
|--------------|-------------|-------------|
|`-w` | `--www`| Folder that contains webpages in flat hierarchy (no subfolders) |
|`-p` | `--port`| TCP port for HTTP server |
|`-c` | `--credentials`| Ask for `username:password` on connect |
|`-n` | `--nocommands`| Disable execution of commands |

### Examples
Executing from `~/mjpg-streamer/mjpg-streamer-experimental/`.
```bash
# First of all specify LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$(pwd)"
# Next, call mjpg-streamer
./mjpg_streamer -i "./input_phenox.so -q 35" -o "./output_http.so -w ./phenox-www"
```
In the above example we've executed `mjpg-streamer` with input_phenox as input plugin and output_http as output plugin. For input_phenox JPEG quality is set to 35, to reduce bandwidth. For output_http webpages directory is set to `./phenox-www`.
...more examples to come...

## 4.2. Modifying input_phenox
Inside input_phenox is running complete control program, so it can be modified to alter Phenox2 behavior. In order to do this, you will need to modify sources of plugin, which are located in `./plugins/input_phenox`. Program source can be found in `main.c`, and parameters declaration -- in `parameter.c`. In order to build project, execute `make clean all` from `mjpg-streamer-experimental` directory.

* Initialization is performed in following function:
```c
int input_run(int id) {
    init_phenox(); // initialize phenox
    // allocate buffer for jpeg compression
    pglobal->in[id].buf = malloc(128 * 1024); 
    ...
}
```
* Main code is located in `worker_thread` function:
```c
void *worker_thread(void *arg) {
	...
    while(!pglobal->stop) {
    	...
    	main code is here
    	...
    }
	...
}
```
* You can also change source image and parameters of compression in following function
```c
tjCompress2(
	tj_compressor,
	(unsigned char*)srcImage->imageData, // source image data
	320, // image width
	0,
	240, // image height
	TJPF_BGR, // input image format
	&(pglobal->in[plugin_number].buf), // output buffer
	&buffsize, // size of output buffer and pointer to compressed image size
	TJSAMP_420, // compression parameter
	jpegquality, // quality settings
	TJFLAG_NOREALLOC|TJFLAG_FASTDCT // forbid memory allocation and use FastDCT
)
```

## 4.3. Building `mjpg-streamer` from scratch
**It is strongly recommended to make sure that date and time set to current**

1. Install prerequisites
  1. Download and extract sources of libjpeg-turbo >= 1.3.0. (for example from http://sourceforge.net/projects/libjpeg-turbo/)
  2. Call `configure --enable-shared`.
  3. Call `make all` and `make install`. Library will be installed to `/opt/libjpeg-turbo` directory
2. Clone source files from following git repository
```bash
git clone git@github.com:ShigiDono/mjpg-streamer.git
```
3. Call `make clean all`
4. You're ready to go!

