# Phenox ライブラリ
Phenox library consists of two directories ("phenox/library", "phenox/work"). APIs and their definition are in "phenox/library", and user projects and tutorials are in "phenox/work".  Projects in "phenox/work" can call APIs of Phenox library by including "pxlib.a", "pxlib.h" and "pxlib.so".

In each projects, users need to set physical parameters to operate Phenox2 in "parameter.c" in C language project. 

# Create and build  custom project 
## C language project
The most simple way to create a project is to copy template from tutorials.
```bash
phenox# cd /root/phenox/work/
phenox# cp -a tutorial_sample myproject
```
After rewriting main.c and parameter.c, build using following command.
```bash
phenox# cd /root/phenox/work/myproject
phenox# make clean all
```
   
Compiled project can be executed by running "./main"
```bash
phenox#  ./main
```

