# Check if the Ephesoft linux installer has been downloaded
if [ ! -f $INSTALLER ]
  then
    echo "Downloading ephesoft... The file is about 810MB large, so you'll need some patience..."
    echo "You can download, as well, ephesoft manually from this URL (http://www.ephesoft.com/Ephesoft_Product/Ephesoft_Community_4.0.2.0_Linux_10_July_2015/Ephesoft_Community_Release_4.0.2.0.zip), and place it in the same folder as your Vagrant file"
    wget -q http://www.ephesoft.com/Ephesoft_Product/Ephesoft_Community_4.0.2.0_Linux_10_July_2015/Ephesoft_Community_Release_4.0.2.0.zip >> /var/log/ephesoft-install.log
fi
