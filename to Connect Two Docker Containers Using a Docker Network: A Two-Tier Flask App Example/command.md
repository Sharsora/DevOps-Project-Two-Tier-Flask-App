### AWS EC2 Instance Preparation

1.  **Launch EC2 Instance:**
    * Navigate to the AWS EC2 console.
    * Launch a new instance using the **Ubuntu 22.04 LTS** AMI.
    * Select the **t2.micro** instance type for free-tier eligibility.
    * Create and assign a new key pair for SSH access.


2.  **Configure Security Group:**
    * Create a security group with the following inbound rules:
        * **Type:** SSH, **Protocol:** TCP, **Port:** 22, **Source:** Your IP
        * **Type:** HTTP, **Protocol:** TCP, **Port:** 80, **Source:** Anywhere (0.0.0.0/0)
        * **Type:** Custom TCP, **Protocol:** TCP, **Port:** 5000 (for Flask), **Source:** Anywhere (0.0.0.0/0)
        * **Type:** Custom TCP, **Protocol:** TCP, **Port:** 8080 (for Jenkins), **Source:** Anywhere (0.0.0.0/0)

3.  **Connect to EC2 Instance:**
    * Use SSH to connect to the instance's public IP address.
    ```bash
    ssh -i /path/to/key.pem ubuntu@<ec2-public-ip>
    ```

---

### Install Dependencies on EC2

1.  **Update System Packages:**
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```

2.  **Install Docker:**
    ```bash
    sudo apt install docker.io -y
    ```

3.  **Start and Enable Docker:**
    ```bash
    sudo systemctl start docker
    sudo systemctl enable docker
    ```

    ```bash
    git clone https://github.com/Sharsora/DevOps-Project-Two-Tier-Flask-App.git
    ```
4. **Create a Bridge network:**
   ```bash
   sudo docker network create two-tier -d bridge
   sudo docker network ls
   ```

5. **Build MYSQL image & Run Container:**
   ```bash
   sudo docker run -d --name mysql --network two-tier -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=devops mysql
   ```
   ```bash
   sudo docker ps -a
   ```   
6. **Build Image two-tier-app from Dockerfile:**
   ```bash
   cd DevOps-Project-Two-Tier-Flask-App
   ls -la
   ```
   ```bash
   docker build -t two-tier-app .
   ```
   ```bash
   docker images
   ```

7. **Run two-tier-app Container**
   ```bash
   docker run -d -p 5000:5000 --network two-tier -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_PASSWORD=root -e MYSQL_DB=devops two-tier-app:latest
   ```
   ```bash
   docker ps
   docker logs xxxxx
   ```

   **Check output**

   **Check Database**




**getting this error**
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker ps -a
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
db1680ef50a3 flaskapp "python app.py" About a minute ago Exited (1) 1 second ago adoring_neumann
24dd771a52f8 mysql "docker-entrypoint.s…" 7 minutes ago Up 59 seconds 3306/tcp, 33060/tcp mysql
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker images
REPOSITORY TAG IMAGE ID CREATED SIZE
flaskapp latest 9592d8159f1d 4 minutes ago 363MB
python 3.9-slim 085da638e1b8 3 weeks ago 122MB
mysql latest f6b0ca07d79d 5 weeks ago 934MB
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$
```

**Checked container logs**
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker logs adoring_neumann
Traceback (most recent call last):
  File "/app/app.py", line 46, in <module>
    init_db()
  File "/app/app.py", line 18, in init_db
    cur = mysql.connection.cursor()
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 94, in connection
    ctx.mysql_db = self.connect
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 81, in connect
    return MySQLdb.connect(**kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/__init__.py", line 121, in Connect
    return Connection(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/connections.py", line 200, in __init__
    super().__init__(*args, **kwargs2)
MySQLdb.OperationalError: (2005, "Unknown server host 'mysql' (-3)")
Traceback (most recent call last):
  File "/app/app.py", line 46, in <module>
    init_db()
  File "/app/app.py", line 18, in init_db
    cur = mysql.connection.cursor()
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 94, in connection
    ctx.mysql_db = self.connect
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 81, in connect
    return MySQLdb.connect(**kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/__init__.py", line 121, in Connect
    return Connection(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/connections.py", line 200, in __init__
    super().__init__(*args, **kwargs2)
MySQLdb.OperationalError: (1045, "Access denied for user 'default_user'@'172.18.0.3' (using password: YES)")
Traceback (most recent call last):
  File "/app/app.py", line 46, in <module>
    init_db()
  File "/app/app.py", line 18, in init_db
    cur = mysql.connection.cursor()
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 94, in connection
    ctx.mysql_db = self.connect
  File "/usr/local/lib/python3.9/site-packages/flask_mysqldb/__init__.py", line 81, in connect
    return MySQLdb.connect(**kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/__init__.py", line 121, in Connect
    return Connection(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/MySQLdb/connections.py", line 200, in __init__
    super().__init__(*args, **kwargs2)
MySQLdb.OperationalError: (1045, "Access denied for user 'default_user'@'172.18.0.3' (using password: YES)")
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$
```
logs se problem clear hai. Do alag-alag errors dikh rahe
- Unknown server host 'mysql' (-3) — Flask container build/run karte waqt app ne mysql hostname ko resolve nahi kiya (ya MySQL service ready nahi thi).
- Access denied for user 'default_user' ... — jab connection mil gaya, to credentials galat the.

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
**Solution**

Quick dev fix (fastest) — use correct credentials and link to mysql
Agar aap mysql container already run kar chuke ho (jaisa hamare logs me dikh raha hai), run Flask container with --link and env vars to match MySQL root:

# stop/remove old broken container
```bash
ubuntu@ip-172-31-2-8:~/DevOps-Project-Two-Tier-Flask-App$ sudo docker rm -f flaskapp || true
flaskapp
```
# run flask with link and env vars so host 'mysql' resolves and credentials ok
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

Why: `--link mysql:mysql` makes the name `mysql` resolvable inside the new container (legacy but works). Also ensure your app reads these env vars (next section). If your app currently uses different user (default_user), either change env to match that user/password OR create that DB user in MySQL (commands below).

Recommended: Use docker-compose (best and clean)

Create a docker-compose.yml in your project root — this will make service name resolution automatic and allow depends_on + healthcheck.
