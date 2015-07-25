echo
echo "--- Ephesoft Installation ---"
echo
echo "    OS: CentOS 6.5"
echo "    Version: Ephesoft Community 4.0.2.0"
echo

export INSTALLER_PATH=/vagrant
export INSTALLER=$INSTALLER_PATH/Ephesoft_Community_Release_4.0.2.0.zip

cd $INSTALLER_PATH

sh 00-download.sh
sh 01-install-prerequisites.sh

echo 
echo ' 02...Installing ephesoft'
echo

echo "   Unzipping $INSTALLER"

# Clean
rm -rf /tmp/ephesoft
rm -rf /var/log/ephesoft-install.log

# Create folders
mkdir -p /opt/app

# Unzip the installer in /tmp
unzip -q $INSTALLER -d /tmp/ephesoft
chmod +x /tmp/ephesoft/install
chmod +x /tmp/ephesoft/install-helper

# Run the installer
echo "   Installing Ephesoft (be aware that this process can take between 10 and 20 minutes, so be patient)"
cd /tmp/ephesoft
cp -f /vagrant/files/ephesoft-config.properties /tmp/ephesoft/Response-Files/config.properties
./install -silentinstall > /tmp/out >> /var/log/ephesoft-install.log

# Wait the installation to finish
while ! grep "============ Ephesoft installed successfully =============" /var/log/ephesoft-install.log
do
	sleep 60;
	echo "     Will check if the installation is completed in 1 minute..."
done


# Start ephesoft
echo "   Starting Ephesoft"
sh /opt/app/Ephesoft/JavaAppServer/bin/startup.sh >> /var/log/ephesoft-install.log

# Wait that ephesoft is started
while ! grep "INFO  org.apache.catalina.startup.Catalina- Server startup" /opt/app/Ephesoft/JavaAppServer/logs/catalina.out
do
	sleep 30;
	echo "     Will check if the Ephesoft is started in 30 seconds..."
done

echo "   Ephesoft is started... Just open the browser on http://127.0.0.1/"