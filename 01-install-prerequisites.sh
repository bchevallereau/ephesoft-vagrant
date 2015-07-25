echo ''
echo ' 01...Installing pre-requisites'
echo ''

# Install unzip
echo '    Unzip'
yum -y -q install unzip >> /var/log/ephesoft-install.log 2>&1

# Install mysql
echo '    MariaDB'
cd /tmp
if [ ! -f /etc/yum.repos.d/MariaDB.repo ]
  then
    echo "      Creating MariaDB YUM repository..."
	cp /vagrant/files/MariaDB.repo /etc/yum.repos.d
fi
echo "      Installling MariaDB..."
yum -y -q install MariaDB-server MariaDB-client >> /var/log/ephesoft-install.log  2>&1
echo "      Starting MariaDB..."
service mysql start >> /var/log/ephesoft-install.log 2>&1

echo "      Configure MariaDB..."
# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root'" >> /var/log/ephesoft-install.log 2>&1
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'" >> /var/log/ephesoft-install.log 2>&1
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'" >> /var/log/ephesoft-install.log 2>&1
# Create the ephesoft user
mysql -e "CREATE USER 'ephesoft'@'localhost' IDENTIFIED BY 'ephesoft';" >> /var/log/ephesoft-install.log 2>&1
# Grant permissions
mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'ephesoft'@'localhost';" >> /var/log/ephesoft-install.log 2>&1
# Create database
mysql -e "CREATE DATABASE IF NOT EXISTS ephesoft;" >> /var/log/ephesoft-install.log 2>&1
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES;" >> /var/log/ephesoft-install.log 2>&1

# Install gnome
echo '    Gnome'
yum -y -q install gnome-vfs2.x86_64 >> /var/log/ephesoft-install.log

# Install checkinstall
echo '    checkinstall'
cd /tmp
wget -q ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/ikoinoba/CentOS_CentOS-6/x86_64/checkinstall-1.6.2-3.el6.1.x86_64.rpm >> /var/log/ephesoft-install.log
yum -y -q install checkinstall-1.6.2-3.el6.1.x86_64.rpm >> /var/log/ephesoft-install.log  2>&1

# Install autoconf
echo '    autoconf'
cd /tmp
wget -q ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/monkeyiq:/centos6updates/CentOS_CentOS-6/noarch/autoconf-2.69-12.2.noarch.rpm >> /var/log/ephesoft-install.log
yum -y -q install autoconf-2.69-12.2.noarch.rpm >> /var/log/ephesoft-install.log  2>&1

