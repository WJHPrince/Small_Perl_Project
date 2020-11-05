# Introduction
This is an ugly Perl program used to control and display database infomation via CGI.
## Dependence
- DBI
- DBD::Pg
- Template Toolkit
- Digest::MD5
- CGI
- PostgreSQL v10.14
- Apache v2.4.37
## Usage
### First
Set up basic environment on Linux servers, then set username, password and database name for PostgreSQL in `Models/Sqlcontrol.pm`.
Set up database and tables.
### Second
Put `index.html` to root path of the http server(`/var/www/html/` by default).
Put the rest of these files and dictionarys to root path of cgi scripts(`/var/www/cgi-bin/` by default).
### Check 
- Check `action` lable in `index.html`, make sure it is a right path to cgi script:`Control.cgi`.
- Check SELinux rules and firewall rules.
- Check the authority of files, make sure they are all set properly.
### Finish
Start httpd(Apache) and postgresql service.
## 致谢
这里感谢一些提供给我思路和想法的朋友：NULL，fengyunkkx，-以及我BOSS。
