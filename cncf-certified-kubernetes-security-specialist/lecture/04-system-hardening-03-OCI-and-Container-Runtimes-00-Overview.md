## Importance of Standardization

In an organization, if image standardization is not set, different developer will use different set of images. <br>
This leads to challenges in troubleshooting, as well as security.

### Open Container Initiative

The Open Container Initiative (OCI) is a Linux Foundation project to design open standards for containrs. <br>
There are two important specifications.

| Specification | Description |
| --- | --- |
| `Image Specification` | Defines how to create an OCI image, which includes an image manifest, a filesystem (layer) serialization, and an image configuration. |
| `Runtime Specification` | Defines how to run the OCI image bundle as a contanier. |

### Docker Workflow

1. Same Docekr UI and commmands
2. User interacts with the Docker Engine
3. Engine communicate with containerd (High-Level Container Runtime)
4. Containerd spins up runc or other OCI compliant runtime to run containers (Low-Level Container Runtime)s

### Container Runtimes

A container runtime is software that executes containers and manages container images on a node. <br>
There are multiple container runtime available. Some of these include:

- Docker
- containerd
- Cri-O
- Podman

### High-Level and Low-Level Runtimes

- `cri-o`
    - Pulling images from registry.
    - Unpacks image into containers root fs
    - Generates OCI runtime spec json describing how to run container
    - Launches OCI compatible runtime (default runc)
- `runC`
    - Runs the container process

