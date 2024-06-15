# Setup Demo Server

## Quick Start

At the root folder of this repo (location of `docker-compose.yaml`), run:

`docker compose up -d` to start the services

`docker compose down` to stop all services

`docker compose logs -f` to view all output logs, CTRL+C to exit logs view

## Environment Setup

### Edit config/zlmediakit-config.ini

- `api.secret`,choose your password for restapi
  - this must be set and will be used for rest api (eg. webassist/?secret=<secret>)
  - Consider use `openssl rand -hex 8` to generate a random password
- `http.allow_ip_range`, by default it allows all LAN connection, set it to empty ot allow all
- `rtc.externIp`, set it to the ipv4 addr of the host machine, eg. 192.168.88.100

### Get Certificates for Local Area Network

- Install system local CA: `mkcert -install`
- Generate certs: `mkcert 192.168.88.100 localhost 127.0.0.1 ::1`

Then `cat path-to-pem/*key.pem > config/example.com.key.pem`, `cat path-to-pem/*.pem > config/example.com.pem`

And `cat config/example.com.key.pem config/example.com.pem > config/zlmediakit-default.pem`

### Install CA on client side 

*client side means the machine with browsers you would like to watch live streams on*

- Step 1. On the server, run `mkcert -CAROOT` to get the location of the CA files, copy them to your client-side machine
- Step 2. On the client-side machine
  - 2.1 Install `mkcert`
  - 2.2 Replace the CA files under `$(mkcert -CAROOT)` with the ones we just copied in Step 1
  - 2.3 Run `mkcert -install` to install CAs in the system
  - 2.4 Open a browser (Use Chrome) and visit `https://<server-ip>`, there should be no more warnings 

### Set Live Stream Source for Web UI

Visit `https://192.168.88.100` and click the settings button on the top right corner

![image](https://github.com/LonganVision/infra/assets/139405574/0b13ac18-fe2e-4abe-bf32-da5b75f8f044)

Enter the ip address for the host machine of the server, and click `save` button to apply

![image](https://github.com/LonganVision/infra/assets/139405574/f736e9d6-aad3-4d2d-bb76-77c4cf9a83e0)

### Update Static Build Files for Web UI (Optional)

Put all static resources under `config/static`

```bash
.
├── config
│   ├── Caddyfile
│   ├── example.com.key.pem
│   ├── example.com.pem
│   ├── static
│   │   ├── index.html
│   │   └── other_static_files
│   ├── zlmediakit-config.ini
│   └── zlmediakit-default.pem
```

## Push RTMP Streams

Push to `rtmp://192.168.88.100/demo/fvs1`,

or `rtmp://192.168.88.100/demo/fvs2`,

or `rtmp://192.168.88.100/demo/fvs3`,

or `rtmp://192.168.88.100/demo/fvs4`,

...

up to `rtmp://192.168.88.100/demo/fvs9`

Open up `https://192.168.88.100` to view realtime streamings from FVS


### Manual Testing

Push to `rtmp://192.168.88.100/live/test` (eg. `ffmpeg -stream_loop -1 -re -i video.mp4 -vcodec h264 -acodec aac -f flv rtmp://192.168.88.100/demo/fvs1`)

Open up `https://192.168.88.100:8443/webassist/?secret=123456` -> WebRTC Tests -> Choose Resolution(1280x720) -> Play

**Note:** the url param `secret` is the one we set earlier in `zlmediakit_config.ini`

## Architecture

![image](https://github.com/LonganVision/infra/assets/139405574/33a276fa-6b91-4c39-b6b7-a35cf952a9e0)







