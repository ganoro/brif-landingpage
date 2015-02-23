echo "**** LOADING CONFIGURATION"

export PATH="/var/lib/jenkins/local/bin:$PATH"
if [ "$1" = "staging" ];then
	config_string="<?php \$station_name = 'staging'; \$station_mode = 'production'; \$cookiepolicy = 'http://brif.us'; \$client_email = '808248997275-ol6kol8h23j018iug3d5odi9vhrja9j5@developer.gserviceaccount.com'; \$client_id = '808248997275-ol6kol8h23j018iug3d5odi9vhrja9j5.apps.googleusercontent.com'; \$scope = 'profile https://mail.google.com https://www.google.com/m8/feeds https://www.googleapis.com/auth/drive';"
	subdomain="staging"
elif [ "$1" = "production" ]
then
	config_string="<?php \$station_name = 'production'; \$station_mode = 'production'; \$cookiepolicy = 'http://brif.us'; \$client_email = '808248997275-ou0vtokaht54knr34697a1epd5m0j5rf@developer.gserviceaccount.com';\$client_id = '808248997275-ou0vtokaht54knr34697a1epd5m0j5rf.apps.googleusercontent.com'; \$scope = 'profile https://mail.google.com https://www.google.com/m8/feeds https://www.googleapis.com/auth/drive';"
	subdomain="www"	
elif [ "$1" = "localhost" ]
then
	:
   	# do nothing, localhost is set by default 
else
   echo "USAGE:\n\n\tbuild.sh <station_name>\n"
   exit
fi

rm -rf .git

# Mime-type detection is not always reliable - https://github.com/s3tools/s3cmd/issues/198
if [ "$1" = "production" ];then
	s3cmd sync --delete-removed --no-mime-magic  --exclude=*.css . s3://$subdomain.brif.us --cf-invalidate 
	s3cmd -m text/css sync --delete-removed --no-mime-magic  --include=*.css . s3://$subdomain.brif.us --cf-invalidate 
elif [ "$1" = "staging" ]
then
	s3cmd sync --delete-removed --no-mime-magic --exclude=*.css . s3://$subdomain.brif.us
	s3cmd -m text/css sync --delete-removed --no-mime-magic --include=*.css . s3://$subdomain.brif.us
fi

