---
layout: post
title: "Install Apache Archiva on OSX"
description: ""
category: devops
tags: [java]

---

To setup a local repository proxy, Apache Archiva is one popular choice.

### 1. Download Apache Archiva.

From the [download page](http://archiva.apache.org/download.cgi), download Archiva Standalone distribution, extract it to your local folder (in my case: `/opt/sdata/archiva`).

```bash
$ mkdir -p /opt/sdata/archiva
$ mv ~/Download/apache-archiva-2.2.0-bin.tar.gz /opt/sdata/archiva/
$ cd /opt/sdata/archiva
$ tar zxvf apache-archiva-2.2.0-bin.tar.gz
$ ln -s apache-archiva-2.2.0 current
# /opt/sdata/archiva/current will be the archiva installation folder
```

### 2. Separating the base from installation

By separating `logs`, `data`, `temp`, `conf` sub-folders of archiva, future upgrades will be easier. Here we separate these folders to `/opt/sdata/archiva/var-archiva`, and makes `.../var-archiva` as our `$ARCHIVA_BASE`

```bash
$ mkdir -p /opt/sdata/archiva/var-archiva/logs
$ mkdir -p /opt/sdata/archiva/var-archiva/data
$ mkdir -p /opt/sdata/archiva/var-archiva/temp
$ mkdir -p /opt/sdata/archiva/var-archiva/conf
$ ls ./current/conf
$ cp /opt/sdata/archiva/current/conf/*.* /opt/sdata/archiva/var-archiva/conf/

# test running in console mode
$ sudo ARCHIVA_BASE=/opt/sdata/archiva/var-archiva /opt/sdata/archiva/current/bin/archiva console
```

### 3. Prepare OSX launchd service.

Put this content as file: `/Library/LaunchDaemons/org.apache.archiva.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.apache.archiva</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/sdata/archiva/current/bin/archiva</string>
        <string>console</string>
    </array>
    <key>Disabled</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <!--    
    <key>UserName</key>
    <string>archiva</string>
    -->
    <key>StandardOutPath</key>
    <string>/opt/sdata/archiva/var-archiva/logs/launchd.log</string>
    <!-- Optional - store data separate from installation (see below) -->
    <key>EnvironmentVariables</key>
    <dict>
      <key>ARCHIVA_BASE</key>
      <string>/opt/sdata/archiva/var-archiva</string>
    </dict>
    <!-- Optional: force it to keep running
    <key>KeepAlive</key>
    <true/>
    -->
</dict>
</plist>
```

Change the permission and load into launchd.

```bash
$ sudo chown root:wheel /Library/LaunchDaemons/org.apache.archiva.plist
$ sudo launchctl load -w /Library/LaunchDaemons/org.apache.archiva.plist

# uninstall
$ sudo launchctl unload /Library/LaunchDaemons/org.apache.archiva.plist

# show service status
$ sudo launchctl list | grep archiva
```

### Archiva running port

if you want to use a custom port, edit the file: `/opt/sdata/archiva/var-archiva/conf/jetty.xml`, find the following content:

```xml
<Set name="port"><SystemProperty name="jetty.port" default="8080"/></Set>
```

For instance, change "8080" to "13301".

