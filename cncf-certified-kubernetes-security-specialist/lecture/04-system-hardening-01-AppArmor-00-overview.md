## Overview of DAC

Discretionary Access Control(DAC) allows restricting access to objects based on the identity of subjects and/or groups to which tey belong.

### Challenges with DAC

Many of the times, the permissions on the files are more than what is needed. <br>
The programs that are running with the user privilege has complete access to the data owned by that user.

### Sample Use-Case

Client has sent you a zip file in the pretext that it contains certain images related to the error that he is facing while using your program. 

It the background, the zip file task some sensitive data from your host and transmits to the internet.

### Mandatory Access Control

Mandatory Access Control is set by the Administrator. <br>
Two important concept: Confined (Not Trusted) and Unconfined (Trusted)

- Process X : Confined
- Process Z : Not Confined

### Confined Process

Confined Proccesses are not trusted. <br>
Everything that process intends to do must be listed in a profile. <br>
If that capability is not listed in the profile, the process will not be allowed to run that.

> 루트 권한이 있어도 Profile에서 허용하지 않는 작업은 할 수 없음

### Sample Use-Case

Client has sent you a zip file in the pretext that it contains certain images related to the error that he is facing while using your program. <br>
In the background, the zip file takes some sensitive data from your host and transmits to the internet.

### Primary Modes of AppArmor

Following are the two primary mode for AppArmor.

| Modes | Description |
| - | - |
| `Enforce` | Enforces the policy defined in the profile | 
| `Complain` | In complain or learning mode, violations of AppArmor profile rules, such as the profiled program accessing files not permitted by the profile, are detected. |