sudo docker rm -f ausim

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
