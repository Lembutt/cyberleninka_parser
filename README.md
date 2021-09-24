# Installing chromedriver
To make this app working, firstly, you need to setup chromedriver.

So try typing:

```
user@device:/path/to/proj$ bash ./setup.sh
```
> 
>Note that if you have root privileges, but changed 'root' to custom name, 
> then you can face some problems executing sudo command from this script. So
> you need to redact 33rd line like this:
> 
> ```
> if [ $USER == 'YOUR USERNAME HERE' ]
> ```

If you don't want to use bash script, then follow 
[this guide](https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/).

# Installing config
To setup config of this app, you need to fill 'config.json' with your data and rename it 
(you need to put dot before the name of this file):

```
user@device:/path/to/proj$ mv ./config.json ./.config.json
```


# Installing database
To setup database just install PostgreSQL where you want and do instructions from 
[this file](https://github.com/Lembutt/myfirstparser/blob/main/db_source/before_start.sql).