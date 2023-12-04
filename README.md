Time Machine
============

Provide Samba and mDNS services suitable for a macOS Time Machine

## Usage

### 1. mDNS Service

Run an `avahi-daemon` instance to advertise `_smb._tcp`, `_adisk._tcp`, and `_device-info._tcp` SRV and TXT records for macOS instances to discover the SMB file-sharing service as a Time Machine.

```
$ docker run -d --restart always --net host --uts host ghcr.io/jmanero/timemachine avahi-daemon
```



### 2. File Sharing Service

Generate `smb.conf` and run `smbd`. See `Containerfile` ENV statements for configuration options

```
$ docker run -d --restart always --volume $TM_DISK:/data --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro --volume $PRIVATE/passdb.tdb:/var/lib/samba/private/passdb.tdb --publish 445:445/tcp --publish 139:139/tcp --security-opt label=disable --uts host ghcr.io/jmanero/timemachine
```

### 3. Passwords

Use `pdbedit` to configure password bindings for local users. `smbd` is configured uses its own database to store password hashes for enabled users

```
$ docker run -it --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro --volume PRIVATE/passdb.tdb:/var/lib/samba/private/passdb.tdb pdbedit --create --user $USERNAME --homedir /data/$USERNAME
```

> **NOTE**
> - Users must already exist in `/etc/passwd` to add them to the samba password database
> - The `pdbedit` utility has a `--password-from-stdin` flag that can be used to automate user provisioning
