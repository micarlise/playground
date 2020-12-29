# Expose loadbalancer services to hostNetwork on Mac OS X #

** Load docker-tuntap-osx submodule before following these instructions ** 

```
git submodule update -- init
```

1. stop docker desktop
2. install tuntap kernel extensions
```
brew tap homebrew/cask
brew install --cask tuntap
```
3. replace hyperkit
```
./docker-tuntap-osx/sbin/docker_tap_install.sh
```
4. restart docker desktop (if not already started)
5. setup tun1 interface
```
./docker-tuntap-osx/sbin/docker_tap_up.sh
```