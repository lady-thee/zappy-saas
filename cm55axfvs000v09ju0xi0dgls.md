---
title: "Unlocking PostgreSQL:  Running, Setting up Roles, and Databases On Ubuntu"
seoTitle: "How to set up PostgreSQL on Ubuntu"
seoDescription: "you need to set the role and configure the `pg_hba.conf` file"
datePublished: Thu Dec 26 2024 12:30:09 GMT+0000 (Coordinated Universal Time)
cuid: cm55axfvs000v09ju0xi0dgls
slug: unlocking-postgresql-running-setting-up-roles-and-databases-on-ubuntu
cover: https://cdn.hashnode.com/res/hashnode/image/upload/v1735214233574/c2f88375-4cb8-43e3-87fe-102069cdf6aa.jpeg
ogImage: https://cdn.hashnode.com/res/hashnode/image/upload/v1735216003412/76c9bbdf-2e8e-427d-86dd-3b34d52f3e14.jpeg
tags: ubuntu, postgresql, ubuntu-2404

---

# Introduction

Recently, I began working on a transcription project using FastAPI and PostgreSQL. Initially, I intended to use an ORM and PgAdmin to manage my database. However, I later decided to take a different approach. Normally, I use Prisma as my ORM, which requires creating a schema, but this time, I wanted to strengthen my backend and database management skills by working directly with PostgreSQL and writing scripts.

This decision did not come without challenges. I encountered several difficulties while trying to configure and create a database on my Ubuntu Linux desktop environment. In this article, I will guide you through installing and configuring PostgreSQL on Ubuntu, setting up user roles, resolving common errors, and creating databases—all while sharing insights from my own experience.

# First Steps

First, I used Ubuntu version 24.0.1. You can download it from the Ubuntu website or the Microsoft Store. After installing, set up your username and password. Once this is completed, restart the application and mount your local memory using the following command:

```bash
<user>@DESKTOP-Q1OABO1:~$ cd /mnt/c
<user>@DESKTOP-Q1OABO1:/mnt/c$
```

Note: `<user>` is just a placeholder for your actual Linux username. Replace `<user>` with your Linux username. Also, the ID `<@DESKTOP-Q1OABO>` is unique, therefore yours may not look like this but that does not mean it isn’t correct.

What happened there was you navigated into your laptop’s local memory. I prefer doing this so there is a concise location where your packages installed using Ubuntu are stored.

Now we have our environment ready, we can start the show.

# Installation

The next step obviously would be to install PostgreSQL on Ubuntu. In your terminal, type the command:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo apt update
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo apt install postgresql postgresql-contrib
```

Once the installation is complete, we will tell Ubuntu to start the PostgreSQL engine and enable the engine to run in the environment:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo systemctl start postgresql
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo systemctl enable postgresql
```

You can check if Postgresql is successfully started by checking the status:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo systemctl status postgresql
```

If it is successfully started it should show a CLI status report like this:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo systemctl status postgresql
<user>@DESKTOP-Q1OABO1:/mnt/c$ 
[sudo] password for <user>:
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Tue 2024-12-24 14:28:45 WAT; 1 day 18h ago
    Process: 56509 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 56509 (code=exited, status=0/SUCCESS)
```

Note: `<sudo>` means you are running with root privileges, so you will be prompted to input your password for your Linux root user.

Once that is taken care of, the next step would be to set up the Postgres user and roles.

# Configuration: Setting up Roles

PostgreSQL is an open-source relational database management system. It allows you to define user roles to control access and permissions within your database. A Postgres user is the default superuser with role attributes to perform administrative tasks, including creating databases, managing users, and configuring the PostgreSQL instance. Other ‘users’ are referred to as Roles.

A Role is an admin user created by you that can have specific privileges granted to them but they don’t have the superuser role or privileges by default (unless explicitly granted). They can have specific permissions, such as the ability to connect to a database, create tables, or run queries. Roles can be customized to meet security and operational requirements by assigning attributes like `LOGIN`, `CREATEDB`, or `CREATEROLE` .

To create a role we need to first load the Postgres shell:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo -u postgres psql
psql (16.6 (Ubuntu 16.6-0ubuntu0.24.04.1))
Type "help" for help.

postgres=#
```

Now that we are inside the Postgres shell, we can check for the current roles using `\dt` command:

```bash
postgres=# \du
                             List of roles
 Role name |                         Attributes
-----------+------------------------------------------------------------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS
```

Note: `postgres` is the default superuser role created upon installation. To create a new role we can do so directly in the shell:

```bash
postgres=# CREATE <role> WITH PASSWORD <password>;
CREATE ROLE  #That's the expected response
```

Note: Replace `<role>` and `<password>` with the role and password you are creating you’re creating.

The role `<role>` has been created. Now to check, you can run `\du` command again and you will see the expected role you just created:

```bash
postgres=# \du
                             List of roles
 Role name |                         Attributes
-----------+------------------------------------------------------------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS
 <role>     | Cannot login
```

Now we edit the role attributes of `<role>` by granting it specific attributes:

```bash
postgres-# ALTER ROLE <role> LOGIN;
```

And to let it be able to create a database:

```bash
postgres-# ALTER ROLE <role> CREATEDB;
```

Now we have a role with specific attributes:

```bash
postgres=# \du
                             List of roles
 Role name |                         Attributes
-----------+------------------------------------------------------------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS
 <role>    | Create DB
```

But there is a problem, if you try to connect to this user, you will get an error:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo psql -d postgres -U <role>
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  Peer authentication failed for user "<role>"
```

That is because of the issue Ubuntu has.

# Fixing Error: “Peer Authentication failed for user”

Now when you install Postgresql, a bunch of configuration files are created by default. These files are responsible for dictating how Postgres runs on your local machine. To fix the issue, you need to manually configure the `pg_hba.conf` file to accept our user role. To do that, we have to load the page:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo nano /etc/postgresql/16/main/pg_hba.conf
```

When the file loads up all you have to do is edit the file to allow your role to be able to connect via Postgres:

```markdown
# local         DATABASE  USER  METHOD  [OPTIONS]
  host          all      <role>  0.0.0.0/0  md5
# hostssl       DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
# hostnossl     DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
# hostgssenc    DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
# hostnogssenc  DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
```

Now save the file `ctrl + x` . The next thing you have to do is find out the cluster version of the Postgres you are trying to run:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo pg_lsclusters
Ver Cluster Port Status Owner    Data directory              Log file
16  main    5432 online postgres /var/lib/postgresql/16/main /var/log/postgresql/postgresql-16-main.log
```

This will display a table where you see the clusters that are running on the postgres engine. Now when we run the postgres server we use the cluster we configured.

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo systemctl restart postgresql@16-main.service
```

Now if we tried to connect to the role we created it will finally connect:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo psql -d postgres -U <role> -h localhost
Password for user <role>:
psql (16.6 (Ubuntu 16.6-0ubuntu0.24.04.1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

postgres=>
```

Note: Defining the host using `-h localhost` This means we are telling Postgres to run it using the TCP/IP connection instead of the default socket connection. Without that specification the peer authentication error will persist:

```bash
<user>@DESKTOP-Q1OABO1:/mnt/c$ sudo psql -d postgres -U <role>
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  Peer authentication failed for user "<root>"
```

Notice how the sign has changed from `postgres=#` to `postgres=>` . That means you have successfully connected to the `main` cluster and are running Postgres as your created role. We have successfully set up Ubuntu to run Postgresql and have created a user role.

# Creating Database

Now that we have our user role, we can create a database and assign specific role attributes to it. To create a database we run an SQL script:

```bash
postgres=> CREATE DATABASE test;
CREATE DATABASE  #Expected outcome
```

This creates the database `test`. To see the databases created and the owners using the `\list`

```bash
postgres=> \list
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           |

 template0 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 test      | <role>   | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           |

(5 rows)

(END)
```

You can see the test database there and the owner. There you go, you have successfully set up Ubuntu to run PostgreSQL and have created a role and database. Kudos!

## Summary

In summary, these are the steps to install and run PostgreSQL on Ubuntu:

1. Install and set up Ubuntu Linux Desktop
    
2. Install and set up PostgreSQL: `sudo apt install postgresql postgresql-contrib`
    
3. Start Postgresql engine: `sudo systemctl start postgresql`
    
4. Enable PostgreSQL: `sudo systemctl enable postgresql`
    
5. Run PostgreSQL shell as default Postgres user: `sudo -u postgres psql`
    
6. Create a Role: `CREATE ROLE <role> WITH PASSWORD <password>`
    
7. Configure Postgres `pg_hba.conf` file: `sudo nano /etc/postgresql/16/main/pg_hba.conf`
    
8. Restart Postgres: `sudo systemctl restart postgresql`
    
9. Connect to the role and start Postgres as role: `sudo psql -d postgres -U <role> -h localhost`
    
10. Create Database: `CREATE DATABASE <db_name>;`
    

**Common Errors to Watch For**

* **Error:** "Peer Authentication failed for user."  
    *Solution:* Check and configure the `pg_hba.conf` file as explained in this guide.
    
* **Error:** "Could not start PostgreSQL service."  
    *Solution:* Ensure you have sufficient permissions or verify the service status using `$ sudo systemctl status postgresql`.
    

## Conclusion

I wrote this article after spending two days trying to set up PostgreSQL on my Ubuntu Desktop and facing numerous issues. Previously, I typically used PostgreSQL with PgAdmin and relied on an ORM, which meant I didn't have to write SQL scripts directly. However, to gain a better understanding of databases and command-line operations, I decided to take a different approach. I welcome your feedback in the comments section, as I am open to improving both myself and this article.

[*Next Steps: Check out my blog for my next issue on how to connect PostgreSQL to FastAPI Server*](https://shecode3.hashnode.dev/unlocking-postgresql-connecting-to-fastapi-server-creating-tables-on-ubuntu)*.*

Thanks for reading.