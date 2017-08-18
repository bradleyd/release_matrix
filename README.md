## Release Matrix

Release matrix helps when you need to build an Elixir release across multiple Linux operating systems.  For example, I have a client that needs to be built for `CentOS`, `Ubuntu`, and `Debian`.
I create separate dockerfiles for each OS.  

* The dockerfiles may have different versions of Elixir and sub packages.

I then pass to release matrix, the dockerfiles directory, application directory, and artifact destination path.


```bash
./release_matrix -d  -f /home/bradleyd/Projects/wameku_client/dockerfiles -a /home/bradleyd/Projects/wameku_client -o /tmp
Dockerfiles directory = /home/bradleyd/Projects/wameku_client/dockerfiles
Application directory = /home/bradleyd/Projects/wameku_client
Destination directory = /tmp
Working on /home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.debian...
Working on /home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.fedora...
Working on /home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.centos...
Image: 6db55e57d91d
Container: 1dfcbee662bb48671a9d0d69897a81251792dbdc165b8c045811bd932d5fb86e
/home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.fedora took 39 seconds to complete
Image: f34f2c085468
Container: 13d510afcbaa316bcb58b05bc09c8b085cd851d38bb90c2775d4068e80e0317d
/home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.debian took 39 seconds to complete
Image: 0fa569366b50
Container: b8d7ee2312fd29277ac4861a5c2eac522527728bf085c80b5063442ede989b04
/home/bradleyd/Projects/wameku_client/dockerfiles/Dockerfile.centos took 41 seconds to complete
```

Under `/tmp/` there are 3 releases.

* NOTE the artifact produced is a tar file with the Elixir release inside.


```bash
bradleyd@entanglement:~/Projects/release_matrix$ tar -tf /tmp/wameku-client-centos.tar 
wameku_client.tar.gz
```


## TODO
* Make filenames and project names more generic
* Make this a service
* Create docker images with AWS S3/GCS to push releases to cloud storage
