# Web Counter

# Deploying on Ubuntu
Clone the repository in the `$HOME/app` folder:
```
git clone https://github.com/jonatasbaldin/web-counter.git $HOME/app
cd $HOME/app
```

## Update APT cache
```
sudo apt-get update
```

## PostgreSQL
Install PostgreSQL:
```
sudo apt install postgresql postgresql-contrib -y
```

Create a user and database on PostgreSQL:
```
# become root
sudo su

# logs into the psql shell
sudo -u postgres psql

# creates the databse
CREATE DATABASE countdb;

# creates the user/password
CREATE USER mary WITH PASSWORD '123456A!';

# allows the user access to the databse
GRANT ALL PRIVILEGES ON DATABASE countdb TO mary;

# grants all privileges in the schema and table for the created used
# required for PostgreSQL 15+
\c countdb
GRANT ALL PRIVILEGES ON SCHEMA public TO mary;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mary;

# exits the psql shell
exit

# exits the root shell
exit
```

## Python
Install the Python virtual environment package:
```
sudo apt install python3-venv -y
```

Install the dependencies necessary to use the `psycopg2`, the package used to connect the Python application to the PostgreSQL database:
```
sudo apt install build-essential libssl-dev python3-dev libpq-dev -y
```

Create a Python virtual environment:
```
python3 -m venv $HOME/app/venv
source $HOME/app/venv/bin/activate
```

Install the Python dependencies:
```
pip install -r requirements.txt
```

## Python Service
Run the Python application as a service (using `systemd`).

Using elevated permissions, create the `/etc/systemd/system/app.service` file with the following content:
```
[Unit]
Description=Python App
After=network.target

[Service]
Environment="DB_NAME=countdb"
Environment="DB_USER=mary"
Environment="DB_PASSWORD=123456A!"
Environment="DB_HOST=localhost"

User=root
# set your correct app folder (the value from $HOME)
WorkingDirectory=/home/ubuntu/app
ExecStart=/home/ubuntu/app/venv/bin/python /home/ubuntu/app/app.py

[Install]
WantedBy=multi-user.target
```

Reload the service daemon:
```
sudo systemctl daemon-reload
```

Enable and start the Python app:
```
sudo systemctl enable app
sudo systemctl start app
sudo systemctl status app
```

## Nginx
Install Nginx:
```
sudo apt install nginx -y
```

Add the following block in the `/etc/nginx/sites-enabled/default` file, at the end of the `server` block:
```
location /api {
    proxy_pass http://127.0.0.1:5000;
    add_header Access-Control-Allow-Origin "*";
}
```

Copy the `index.html` file to the `/var/www/html` folder:
```
sudo cp $HOME/app/index.html /var/www/html/
```

Restart and check the Nginx service:
```
sudo systemctl restart nginx
sudo systemctl status nginx
```

## Testing the Application
Test your application by accessing your environment name or address.
