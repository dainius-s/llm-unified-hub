 
very important to also update the

open AI url in the Web UI to: 


When configuring AWS you must enbale each model individualy as described here:

https://docs.aws.amazon.com/bedrock/latest/userguide/model-access-modify.html
https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess

Very important to find out which AWS bedrock models availabe for your region etc and on-demand 

aws bedrock list-foundation-models --region us-east-1 > out.txt
Get-Content out.txt


to bring all containers up:

docker-compose up -d

to shutdown:
docker-compose down  

