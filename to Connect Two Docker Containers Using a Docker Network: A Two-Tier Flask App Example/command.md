**getting this error
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker ps -a
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
db1680ef50a3 flaskapp "python app.py" About a minute ago Exited (1) 1 second ago adoring_neumann 24dd771a52f8 mysql "docker-entrypoint.s…" 7 minutes ago Up 59 seconds 3306/tcp, 33060/tcp mysql ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker images REPOSITORY TAG IMAGE ID CREATED SIZE flaskapp latest 9592d8159f1d 4 minutes ago 363MB python 3.9-slim 085da638e1b8 3 weeks ago 122MB mysql latest f6b0ca07d79d 5 weeks ago 934MB ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$
```




```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker network ls
NETWORK ID     NAME       DRIVER    SCOPE
44782c18ecd8   bridge     bridge    local
63beb41ec3a9   host       host      local
ad8cfd902953   none       null      local
a41aa45b6240   two-tier   bridge    local
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker run -d --name mysql   --network two-tier   -e MYSQL_ROOT_PASSWORD=root   -e MYSQL_DATABASE=flaskdb   -p 3306:3306   mysql
docker: Error response from daemon: Conflict. The container name "/mysql" is already in use by container "da38622d22023762e165e2c662c6790bafb77483219abf5be15faed86644bf75". You have to remove (or rename) that container to be able to reuse that name.

Run 'docker run --help' for more information
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker rm -f mysql || true
mysql
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker ps -a
CONTAINER ID   IMAGE      COMMAND           CREATED         STATUS    PORTS     NAMES
6bdc9dba786c   flaskapp   "python app.py"   4 minutes ago   Created             flaskapp
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker run -d --name mysql   --network two-tier   -e MYSQL_ROOT_PASSWORD=root   -e MYSQL_DATABASE=flaskdb   -p 3306:3306   mysql
69f86134c35ebf285e19f01951c574f4da6f71b7e2e500d33fc957e6e5f5de43
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker ps -a
CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS         PORTS                                                    NAMES
69f86134c35e   mysql      "docker-entrypoint.s…"   2 seconds ago   Up 2 seconds   0.0.0.0:3306->3306/tcp, [::]:3306->3306/tcp, 33060/tcp   mysql
6bdc9dba786c   flaskapp   "python app.py"          4 minutes ago   Created                                                                 flaskapp
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker rm -f flaskapp || true
flaskapp
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker run -d --name flaskapp --network two-tier \            
  --link mysql:mysql \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=flaskdb \
  -p 5000:5000 flaskapp
4cc24d3583eb7cf3a9f52fdd72094183eb61d8d45c159fd19c803239974cda99
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$
```
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ 
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker ps -a
CONTAINER ID   IMAGE      COMMAND                  CREATED              STATUS              PORTS                                                    NAMES
4cc24d3583eb   flaskapp   "python app.py"          5 seconds ago        Up 4 seconds        0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp              flaskapp
69f86134c35e   mysql      "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3306->3306/tcp, [::]:3306->3306/tcp, 33060/tcp   mysql
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$
```
