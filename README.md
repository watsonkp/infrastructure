# Infrastructure
Configuration and build files and scripts that create an environment suitable
for development and security research.

This configuration emphasizes ephemeral and disposable deployments where the
valuable data is regularly backed up. Software I am interested in learning is
prioritized over software that may be more suitable to the scale of this
environment.

- [x] SSH certificate authority
- [x] git server version management (SSH, git)
	- [x] SSH protocol access
	- [x] git protocol access
	- [ ] HTTP protocol access
	- [x] git server backup
- [x] YouTrack Agile project management tools
	- [x] YouTrack server backup
- [x] Jenkins continuous delivery automation
	- [ ] Jenkins build nodes
	- [ ] Jenkins server backup
- [x] iOS ad hoc distribution server
- [x] Grafana and Prometheus (cAdvisor, Node Exporter, kube-state-metrics) monitoring host and container metrics
- [x] ElasticSearch, Logstash (FileBeat), Kibana
- [ ] Nmap host and service inventory
- [ ] Windows domain
	- [ ] Windows DNS
	- [ ] Windows DHCP
	- [ ] Users, Groups, Computers, etc. Active Directory objects
	- [ ] Active Directory Certificate Services
	- [ ] Winlogbeat
	- [ ] Sysmon logging

## Deployment specific files
The `.gitignore` file also serves as a list of files the deployment expects, but
are not included in the repository.

### Files required for SSH certificate authority setup
* `ca/ca_user_key`
* `ca/ca_user_key.pub`
* `ca/ca_host_key`
* `ca/ca_host_key.pub`
* `ca/known_hosts`

### git server configuration
* `git/config/git/gitconfig`
* `git/config/git/sshd_config`

### git backup CronJob configuration
* `git/config.yaml`
