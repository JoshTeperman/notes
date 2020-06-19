### When
Running rails server
### Error
```
could not connect to server: Connection refused (PG::ConnectionBad)
Is the server running on host "localhost" (::1) and accepting
	TCP/IP connections on port 5432?
could not connect to server: Connection refused
	Is the server running on host "localhost" (127.0.0.1) and accepting
	TCP/IP connections on port 5432?
```
### Solution
https://stackoverflow.com/questions/19828385/pgconnectionbad-could-not-connect-to-server-connection-refused

Stale `pid` ('process id') file. Postgres didn't delete the `pid` file last time the server shut down. The `pid` file is used to ensure there is only once instance of postgress running at any one time, so when you start the server again postgres thinks there's already an instance running.

To check if there is a `pid` file: `ls /usr/local/var/postgres/ | grep postmaster.pid`

If so, `rm /usr/local/var/postgres/postmaster.pid`

And restart the server.

Otherwise, print server log for more detailed error messages: `cat /usr/local/var/postgres/server.log`


### When
Dumping production database
### Solution
`--exclude-table="notify_user_notifications" --exclude-table="notify_user_deliveries"`


### When
If your rails is frozen when booting up.
### Solution
Quickest way i find to kill it is to press `ctrl-z` to put the app into background, then do this `kill -9 $(jobs -p)`
