# Computer Vision Annotation Tol (CVAT)

This repository holds a guide and two small bash scripts that should get CVAT running without going much into detail, so you can start labeling your data as quick as possible. Further tricks, additions, etc. are very much welcomed.

## Installation Guide

This guide aims at setting up CVAT from the GitHub repository: https://github.com/opencv/cvat <br/>
We want to set up CVAT such that we can run the models locally on our own machines. This guide tries to only focus on the important parts for our use-case, such that CVAT can easily be run without looking under the hood.  For a more detailed explanations, we recommend the docs: https://opencv.github.io/cvat/docs/ or the product tour: https://www.youtube.com/playlist?list=PL0to7Ng4Puua37NJVMIShl_pzqJTigFzg

1. Docker Setup <br/>
Since everything is run within docker containers, we initially need to install docker. As this highly depends on the system you are running, we refer to the docker documentations for an installation guide: https://docs.docker.com/engine/install/ubuntu/

2. Nuclio Setup<br/>
The backend used by CVAT to manage and communicate with the local server is Nuclio: https://github.com/nuclio/nuclio <br/>
To install the latest version of Nuclio, just run: `cd /bin && sudo curl -s https://api.github.com/repos/nuclio/nuclio/releases/latest | grep -i "browser_download_url.*nuctl.*$(uname)" |  c
ut -d : -f 2,3 | tr -d \" | sudo wget -O nuctl -qi - && sudo chmod +x nuctl` <br/>

3. CVAT Setup<br/>
Finally, we will clone the CVAT repository: `git clone git@github.com:opencv/cvat.git` <br/>
Having these simple steps done, we can now start working with CVAT and setting up our work environment.

## Quick Start

To make a quick start, it is helpful to first know a little bit about the important parts of the source code. In the following we only talk about parts that you might encounter while using CVAT in application. We will exemplarily show everything for the Segment Anything model as the definition and usage of other models is almost identical:

    cvat
    ├── ...
    ├── serverless                          # Directory for running local models
    │   ├── onnx                            # Models defined in onnx format
    │   ├── openvino                        # Models defined in openvino format
    │   ├── pytorch                         # Models defined in PyTorch
    │   │   ├── facebookresearch            # Models defined in onnx format
    │   │   │   ├── sam/nuclio              # Model directory
    │   │   │   │   ├── function-gpu.yaml   # File defining the runtime environment for GPU
    │   │   │   │   ├── function.yaml       # File defining the runtime environment for CPU
    │   │   │   │   ├── main.py             # Start environment and model
    │   │   │   └── model_handler.py        # Model Wrapper
    │   │   └── ...      
    │   │── tensorflow                      # Models defined in TensorFlow
    │   ├── deploy_cpu.sh                   # File to build the docker container for CPU
    │   └── deploy_gpu.sh                   # File to build the docker container for CPU
    └── ...


### First-time Initialising a Model
To run a model we have to initially build the docker image either for a CPU or a GPU deployment using the following commands: <br/>
Build CPU: `./cvat/serverless/deploy_cpu.sh [path to model directory]` <br/>
Build GPU: `./cvat/serverless/deploy_gpu.sh [path to model directory]` <br/>
That means for the SegmentAnything model, we first run: `./cvat/serverless/deploy_gpu.sh ./cvat/serverless/pytorch/facebookresearch/sam/nuclio`<br/> 
A successful build finished with the following lines:
```
 NAMESPACE | NAME                           | PROJECT | STATE | REPLICAS | NODE PORT 
 nuclio    | pth-facebookresearch-sam-vit-h | cvat    | ready | 1/1      | 32768
```
You can also verify your installation with `docker ps` and check for the just created container.

### Annotate your Data
After setting up our models, we can now get started with labeling. For easy use, we provide two small scripts that start and stop all CVAT required docker containers and additionally all model containers for local deployment. <br/>
In the `up.bash` file, we first need to adjust the environment variable `CVAT_HOST` to the IP address of our local machine such that the web API can reach our computational backend.

The remaining workflow is relatively easy:
1. Fire up the models: `bash up.bash`
2. Go to https://app.cvat.ai/ and start label your data.
3. When you are finished, stop the processes: `bash down.bash`

To get started within the CVAT web API, please read the next section.

### Get Started in the Web API
Now that we know, how to get our backend properly set up, we take a look at the web API which is our main interface.

## Tricks'n'Tweaks
Here you find some tricks and tweaks that we found helpful while working with CVAT.

