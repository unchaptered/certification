## Basic Architecture

Applications that run in traditional Linux containers access system resources in the same way that regular (non-containerized) applications do: by making system calls directly to the host kernel.

- Application
- - System Calls -
- Kernel
- - Hardware - 

### Use Cases - Bugs

If there are certain bugs at the Kernel level, the application can take advantages of it to achieve various use-cases like privilege escalation, and others.

### Seccomp

Kernel feature like seccomp filters can provide better isolation the application and host kernel, but they require the user to create a predefined whitelist of system calls.

In practice, it's often difficult to know which system calls will be reqquired by an application beforehand.

### Overview of gVisor

The core of gVisor is a kernel that runs as a normal, unprivileged process that supports most LInux system calls.
gVisor intercepts all system calls made by the application, and does the necessary work to service them thus providing a strong isolation boundary.

### Exploring gVisor

It primarily replaces runc (default runtime) which had few series vulnerabilities. <br>
It comes with an OCI runtime named runsc and hence can act as a drop-in replacement to the runc.

### Exploring dmseg

`dmesg` (diagnostic message) is a command on most Unix-like operating systems that prints the message buffer of the kernel.

1. gVisor based Pod.
2. Default runtime class Pod.

### Challenges

Generally oragnization makes use of sandboxes like gVisor for the applications that are not entirely trusted (cloning repo from GitHub and running that application). <br>
It can lead to certain performance degradation.
