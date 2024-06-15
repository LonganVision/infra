# Setup Demo Server

## Environment Setup

### zlmediakit-config.ini

- `api.secret`, must be set
- `http.allow_ip_range`, set it empty to allow all
- `rtc.externIp`, set it to the ipv4 addr of the host machine

### Get Certificates for Local Area Network

- `mkcert -install`
- `mkcert 192.168.88.100 localhost 127.0.0.1 ::1`

Then `cat path-to-pem/*key.pem > config/example.com.key.pem`, `cat path-to-pem/*.pem > config/example.com.pem`

And `cat config/example.com.key.pem config/example.com.pem > config/zlmediakit-default.pem`

- `mkcert -CAROOT`

### Static Build Files for web UI (Optional)

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

## Quick Start

`docker compose up -d` to start the services
`docker compose down` to stop all services
`docker compose logs -f` to view all output logs

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







