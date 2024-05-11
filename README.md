# Sim2Real-AXS2024 Real-Robot Final Stage


实机操作步骤如下：


## 1. 下载容器
### 1.1 登录团队docker

运行以下代码，使用Access Tokens登录docker账户：
```
$ docker login
$ 在此处键入Access Tokens，已通过邮箱提供。
```

## 2. 创建并执行容器
### 2.1 使用脚本文件创建并执行容器
首先确保scripts文件拥有权限：
```
sudo chmod a+x scripts/*
```
运行 run_ausim.sh 创建ausim用户容器
```
./scripts/run_ausim.sh
```
注：需要确保run_ausim.sh中镜像的标签与最新版本保持一致，目前为`v3.2`

容器创建完毕后，可通过执行脚本启动容器
```
./scripts/exec_ausim.sh
```
注：环境位于baseline的conda虚拟环境中，若未正常激活请手动激活：
```
conda activate baseline
```

### 2.2 利用命令行创建并执行容器
请确保镜像的标签与最新版本保持一致，目前为`v3.2`:
```bash
sudo docker run -it --name ausim --network=host \
    --gpus all \
    --privileged \
    --device=/dev/ttyUSB0 \
    --device=/dev/input/js0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -v $HOME/Desktop/shared:/shared \
    littledt/icra2024-sim2real-axs-ausim:v3.2 \
/bin/bash
```
创建完成后可以通过命令行启动容器：
```bash
xhost +
sudo docker start ausim
sudo docker exec -it ausim /bin/bash
```
注：环境位于baseline的conda虚拟环境中，若未正常激活请手动激活：
```
conda activate baseline
```

## 3. 实机操作步骤说明
经过调试确认，需要按照顺序执行以下步骤，造成不便，敬请谅解。
前提条件：需要确认镜像版本，v3为未适配roscore版本，v3.2为最新适配roscore版本，但因测试时间有限存在不稳定的情况。

！！！下文因镜像版本不同可能存在不同步骤
！！！AXS2024_Ausim_Test1.py均需要严格按照以下步骤执行，v3.2内的AXS2024_Ausim_Test2.py不需要考虑roscore是否已开启。

roscore需要在baseline用户容器中启动

### 3.1 关闭roscore、rosmaster
通过在终端使用Ctrl+C或执行以下命令行，终止已启用的roscore、rosmaster

```
$ ps -ef | grep rosmaster
>> xxxx rosmaster
$ sudo kill -9 xxxx
```
或者通过查找python程序，终止roscore:
```
$ ps -ef | grep python
>> yyyy roscore
$ sudo kill -9 yyyy
```

### 3.2 在baseline用户容器中启用roscore
确保位于前面创建的 "ausim:v3" 容器中的baseline虚拟环境中
在终端中执行：
```bash
roscore
```
注:为了避免问题，建议不使用&后台运行；若需要终止运行后台任务，需手动查询PID并终止。


## 3.3 启动实车
## 3.4 启动hdl_localization

确保位于前面创建的 "ausim:v3" 容器中的baseline虚拟环境中,在终端执行：

```bash
roslaunch hdl_localization hdl_localization.launch
```

**注**：考虑到调试过程中定位效果不佳，我们将launch文件中的`ndt_neighbor_search_method`更改为"DIRECT1"。

## 3.5 启动底盘控制组件

```bash
python /root/Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/ros_base_control.py
```
至此需要确保雷达定位正常，底盘控制为等待输入状态.
若出现异常情况，请使用2D Pose Estimate进行姿态矫正.

## 4. 执行策略

本次一共准备了两个策略文件，分别为AXS2024_Ausim_Test1.py以及AXS2024_Ausim_Test2.py
在做完以上步骤后，请优先执行AXS2024_Ausim_Test1.py，待该程序执行完毕后，关闭上述底盘控制及hdl组件，重启并矫正后执行AXS2024_Ausim_Test1.py.

在ausim容器的conda基线环境下在终端执行：

```bash
python /root/Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/AXS2024_Ausim_Test1.py
```

第一组测试执行完毕后，进行第二组测试：
```bash
python /root/Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/AXS2024_Ausim_Test2.py
```

### 4.1 潜在问题
如果出现下述情况，无法正常执行策略文件
(assets/error1.png)
请按照3.1以及3.2重启并运行

当执行完AXS2024_Ausim_Test1.py后，若程序仍不停止，需要手动终止进程，关闭roscore的方法一致，但需要根据出问题的程序类型选择kill对应的程序.
```
$ ps -ef | grep python
>> xxxx rosmaster
>> yyyy roscore
>> zzzz python
$ sudo kill -9 yyyy
$ sudo kill -9 zzzz
```


上述步骤为 Real-Robot Final Stage的说明。若有任何关于我们提交的Docker镜像或操作说明的疑问，请随时与我联系(邮箱:2310295083@email.szu.edu.cn)。
感谢清华大学智能产业研究院（AIR）提供的场景支持和实物部署支持，感谢测试人员的耐心测试。
