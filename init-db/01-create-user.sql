CREATE USER 'ec2_user'@'%' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON *.* TO 'ec2_user'@'%';
FLUSH PRIVILEGES;
