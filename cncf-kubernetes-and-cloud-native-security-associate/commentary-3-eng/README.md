## 오답노트

3회독 차에도 틀리는 문제들에 대한 내용들 <br>
대부분 [Keywords](../commentary-2-kor/README.md#key-words)와 관련된 문제들이 많다.

### What security framework focuses on tactics, techniques and procedures (TTPs)?

1. `MITRE ATT&CK` - The MITRE ATT&CK framework focuses on cataloging cyber adversary tactics, techniques, and procedures (TTPs). It provides a comprehensive matrix of known attacker behaviors to help organizations understand and defend against cybersecurity threats.
2. `NIST` - The National Institute of Standards and Technology (NIST) provides cybersecurity frameworks and guidelines, such as the NIST Cybersecurity Framework, but it does not specifically focus on TTPs.
3. `CIS` - The Center for Internet Security (CIS) offers benchmarks and best practices for securing systems but does not concentrate on documenting adversary TTPs.
4. `ISO 27002` - ISO 27002 is an international standard providing guidelines for information security management practices, not specifically focused on the tactics, techniques, and procedures of cyber adversaries.

### John wants to change his pod's container image using a MutatingAdmissionWebhook. Can John change the pod image, and how?

1. Yes, by adding logic that responds to the pod creation request and which modifies the spec.containers[].image field - A MutatingAdmissionWebhook can modify the pod specification, including the container image, by implementing logic that changes the spec.containers[].image field in response to the admission request.

WRONG ANSWERS: 2. Yes, by adding “/image” subresource to MutatingAdmissionWebhook - There is no specific "/image" subresource for MutatingAdmissionWebhook to handle image changes. 3. Yes, by adding ‘match fields’ annotation of mutatingadmissionwebhook - Adding match fields annotation is not a valid method for changing container images; it is used for filtering objects to apply the webhook to. 4. No it is not possible, he needs to use a ValidatingAdmissionWebhook - ValidatingAdmissionWebhooks are used for validation and cannot modify pod specifications. For modifications, a MutatingAdmissionWebhook is required.

### What are the three possible modes/actions of Pod Security Admission (PSA)?

- enforce, audit, warn

### What is the purpose of the kubernetes.io/enforce-mountable-secrets annotation in Kubernetes?

To specify that secrets should be mounted into a pod only if they meet certain criteria defined by the annotation

### How can you bolster container runtime security within a Kubernetes cluster?

- Implementing intrusion detection systems for threat detection

`CORRECT ANSWER`

- Implementing intrusion detection systems for threat detection - Intrusion detection systems monitor container activities to detect and alert on suspicious behaviors, enhancing runtime security.

`WRONG ANSWERS`

- Enabling debug mode to facilitate troubleshooting - Debug mode can expose sensitive information and should not be enabled in production environments.
- Regularly rotating encryption keys to reduce risk of unauthorized access - Important for security but less directly related to container runtime security.
- Enabling Secure execution mode in the Container Runtime - "Secure execution" mode does not exist across container runtimes. Although there are some secure execution environments called "sandbox".
