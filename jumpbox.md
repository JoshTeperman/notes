ssh -L 5433:agency-production-postgres.ct7f8nr73zfx.ap-southeast-2.rds.amazonaws.com:5432 ec2-user@ec2-13-211-215-204.ap-southeast-2.compute.amazonaws.com -i ~/.ssh/josh.pem
ssh -L 5433:agency-production-postgres.ct7f8nr73zfx.ap-southeast-2.rds.amazonaws.com:5432 ec2-user@ec2-54-206-46-28.ap-southeast-2.compute.amazonaws.com -i ~/.ssh/josh.pem


// force docker update to latest image
docker pull 338325461343.dkr.ecr.ap-southeast-2.amazonaws.com/agency-web:latest

docker run --rm -ti 338325461343.dkr.ecr.ap-southeast-2.amazonaws.com/agency-web exec talenttap-web/production -- bundle exec rails c
