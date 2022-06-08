#GUIDE:-

1. Clone project

2. Run below commands to install docker and docker-compose
	
      	1. cd scripts && sh install-docker.sh			 #To install docker
        2. cd scripts && sh install-docker-compose.sh	 #To install docker-compose
      	3. cd scripts/ssl && sh install.sh

3. To start containers, Run 
	docker-compose up -d

4. To use different php version, uncomment string from below and run `docker-compose up -d` command.
    	
		1. #image: kalpit/ultimatephpdev:7.2 			#To use php7.2
    	2. image: kalpit/ultimatephpdev:7.1  			#To use php7.1
      	3. #image: kalpit/ultimatephpdev:7.0 			#To use php7.0
    	4. #image: "kalpit/addweb:5.6"	 				#To use php5.6

5. After starting containers, bash into code container with `infonew.sh` script and run below commands,
	
      	1. cd /root/.composer && composer install
      	2. cd /root/.composer && php installer.phar
