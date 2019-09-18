NGINX Upgrade with pushstream
---

Upgrade from default customized **NGINX** to 1.16.0
- `pacman -S nginx` upgrades alone will break RuneUI
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package


### Arch Linux Arm - NGINX with pushstream + PHP-FPM
```sh
file=nginx-1.16.1-1-aarch64.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/nginx/$file
pacman -U $file
rm $file

pacman -Sy php-fpm
```
### `/etc/nginx/nginx.conf`
```
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;
        root         html;
        index        index.php index.html index.htm;
        error_page   500 502 503 504  /50x.html;
		
        location = /50x.html {
            root   html;
        }
		
        location ~* \.php$ {
            fastcgi_pass   unix:/run/php-fpm/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
    }
}
```
### start
```sh
systemctl restart nginx php-fpm
```
