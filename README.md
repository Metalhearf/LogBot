# LogBot - SVN Log Generator

----
## What is LogBot ?

Logbot is a bash script that helps users to generate logtime, in a work environment using SVN ([Apache Subversion](https://subversion.apache.org/)), with a bit of pseudo-randomness to fake human activity.

----
## Installation
Clone the repository
* `git clone https://github.com/Metalhearf/logbot`

----
## Configuration
1. Add your custom SVN repositories (must be an existing one) in the config file located here :
[./config/logbot.conf](https://github.com/Metalhearf/logbot/blob/master/config/logbot.conf)

2. Run LogBot once, and if no errors occured, turn off the testing mode by setting :
`TESTING=false`

3. (Optionnal) Change other values listed in the configuration file to suit your needs.

----
## Usage
1. Go to your LogBot installation directory
2. Run it :
 * `bash logbot.sh`


----
## Automate LogBot

By using [Cron](https://doc.ubuntu-fr.org/cron), you can make LogBot start at specific and periodic hours.

##### Example
If you have to generate logs every day of the week from 9am to 10am, you can add this to your crontab. (Reminder : `crontab -e`)

Let's say, the `svn up` command gives you +30 minutes of logtime.

`0 9 * * 1-5 bash /home/bob/logbot/logbot.sh >> /home/bob/logbot/logs/logbot.log`

`30 9 * * 1-5 bash /home/bob/logbot/logbot.sh >> /home/bob/logbot/logs/logbot.log`

----
## Compatibility
* Linux
    * Everything should work just fine.

* Mac
    * You need to install **gshuf** for LogBot to run.

        `brew install coreutils`

* Windows
    * Not supported.

----
## Disclaimer

This software is for educational purposes only. The author is not responsible for its use.
