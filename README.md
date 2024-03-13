# Sim2Real-AXS2024
用户端docker操作指南及必要说明

Operation instructions and some necessary instructions for client-side docker[(English)](./Dockers_Guide/AUSIM_Docker_Guide_EN.md)



# Docker 用户镜像操作指南

运行AUSIM-ICRA2024-Sim2Real-AXS挑战赛的步骤如下：

## 1. 创建容器
### 1.1 利用脚本创建容器
运行以下代码，为本项目中的scripts文件增添权限：
```
cd Sim2Real-AXS2024
sudo chmod a+x scripts/*
```
通过运行 run_ausim.sh 创建ausim用户容器
```
./scripts/run_ausim.sh
```
注：需要确保run_ausim.sh中镜像的标签与最新版本保持一致，目前为`v1.2`

### 1.2 利用命令行创建容器
请确保镜像的标签与最新版本保持一致，目前为`v1.2`:

```bash
sudo docker run -it --name ausim --network=host \
    --gpus all \
    --privileged \
    --device=/dev/ttyUSB0 \
    --device=/dev/input/js0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -v $HOME/Desktop/shared:/shared \
    littledt/icra2024-sim2real-axs-ausim:v1.2 \
/bin/bash
```

## 2. 启动容器
### 2.1 利用脚本创建容器
确保scripts中文件拥有权限后，运行 exec_ausim.sh 启动ausim用户容器
```
./scripts/exec_ausim.sh
```

### 2.2 利用命令行创建容器
确保conda环境设置为baseline:

```bash
xhost +
sudo docker start ausim
sudo docker exec -it ausim /bin/bash
```

## 3. 启动roscore服务

在ausim容器的conda基线环境下在终端执行：

```bash
roscore
```

**注**：之后可在竞赛组委会提供的omniGibson容器中启动模拟器、ros TF publish以及IK service。

## 4. 启动hdl_localization

在ausim容器的conda基线环境下在终端执行：

```bash
roslaunch hdl_localization hdl_localization.launch
```

**注**：考虑到调试过程中定位效果不佳，我们将launch文件中的`ndt_neighbor_search_method`更改为"DIRECT1"。

## 5. 启用控制组件

在ausim容器的conda基线环境下在终端执行：

```bash
python /root /Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/ros_base_control.py
```

## 6. 启动主程序AXS2024_Ausim.py

在ausim容器的conda基线环境下在终端执行：

```bash
python /root/Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/AXS2024_Ausim.py
```

完成上述步骤，即可运行我们团队对于本次挑战赛的解决方案。若有任何关于我们提交的Docker镜像或操作说明的疑问，请随时与我联系(邮箱:2310295083@email.szu.edu.cn)。

