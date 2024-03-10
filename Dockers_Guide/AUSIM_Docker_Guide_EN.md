
# Docker Container Setup and Execution Guide

This guide details the steps to pull, setup, and run the AUSIM Docker container for the ICRA2024-Sim2Real-AXS challenge.

## 1. Creating the Container

Ensure the image tag matches the latest version, currently `v1.1`:

```bash
sudo docker run -it --name ausim --network=host \
    --gpus all \
    --privileged \
    --device=/dev/ttyUSB0 \
    --device=/dev/input/js0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -v $HOME/Desktop/shared:/shared \
    littledt/icra2024-sim2real-axs-ausim:v1.1 \
/bin/bash
```

## 2. Starting the Container

Ensure the conda environment is set to baseline:

```bash
xhost +
sudo docker start ausim
sudo docker exec -it ausim /bin/bash
```

## 3. Launching the Roscore Service

Execute in the terminal with the ausim container running under the conda baseline environment:

```bash
roscore
```

**Note**: Subsequently, you can start the simulator, ros TF publish, and IK service in the omniGibson container provided by the competition committee.

## 4. Initiating hdl_localization

Execute in the terminal with the ausim container running under the conda baseline environment:

```bash
roslaunch hdl_localization hdl_localization.launch
```

**Note**: Considering the poor localization performance during debugging, we changed the `ndt_neighbor_search_method` in the launch file to "DIRECT1".

## 5. Enabling the Control Components

Execute in the terminal with the ausim container running under the conda baseline environment:

```bash
python /root /Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/ros_base_control.py
```

## 6. Starting the Main Program AXS2024_Ausim.py

Execute in the terminal with the ausim container running under the conda baseline environment:

```bash
python /root/Workspace/AXS_baseline/ICRA2024-Sim2Real-AXS/src/airbot/Ausim/AXS2024_Ausim.py
```

Following these steps will execute our team's solution for this challenge. If you have any questions about our Docker image or the operation instructions, please feel free to contact me at (2310295083@email.szu.edu.cn).
