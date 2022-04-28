# Put this line in crontab temporarily

``` bash
* * * * * /usr/bin/env > /tmp/cron-env
```

# Create a script that run others script using cron environement (just below)

``` bash
#!/bin/bash
/usr/bin/env -i $(cat /tmp/cron-env) "$@"
