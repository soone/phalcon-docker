# Phalcon docker build file

# Usage

## Step 1

git clone  --depth=1 git://github.com/phalcon/cphalcon.git dockerConf/cphalcon

## step 2

docker build -t phalcon-docker ./

## step 3
docker run -it -p 80:80 -v {your phalcon project dir}:/app --rm phalcon-docker
