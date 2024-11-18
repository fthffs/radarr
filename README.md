## Rootless Radarr 🚀  
- #### Built straight from the latest [Radarr release](https://github.com/Radarr/Radarr/releases) 📚. 
- #### The difference between this image and others is that this runs as an *unprivileged user*, using a uid (1000) and gid (1000) 👥. 

## Why run as an unprivileged user? 🔒  
- Running Radarr as an unprivileged user helps to: 
  - Reduce the attack surface of your container 
  - (Possibly) Prevent potential security vulnerabilities in case of a compromise 🤖     

## Usage 📁  
- This image can be used in the same way as any other Docker Radarr image. Simply pull and run it using Docker, make sure the volumes mounted are owned by 1000:1000 (likely your user) 🔄.

**Example docker-compose.yml**
```docker-compose.yml
  radarr:
    image: fthffs/radarr:5.14.0.9383
    container_name: radarr
    environment:
      - TZ=Europe/Stockholm
    volumes:
      - /containers/torrents/radarr:/config
      - /data/media/movies:/data/media/movies
      - /data/torrents/movies:/data/torrents/movies
    restart: unless-stopped
``` 

[Radarr wiki](https://wiki.servarr.com/en/radarr)

[Trash Guides](https://trash-guides.info/Radarr/)
