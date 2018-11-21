## Say it like eBay Kleinanzeigen
This is a **unofficial** sinatra website to generate the text with the eBay Kleinanzeigen style

![](screen.png)
## Run

### Sinatra
```
bundle install
bundle exec rackup config.ru -p 80 -s thin -o 0.0.0.0
```


### Docker
Build your own image
```
docker build -t <your_name>  .

docker run -d \
	-p 8080:80 \
	--restart on-failure \
	<your_name>

```


Or run the one on the hub.

```
docker run -d \
	-p 8080:80 \
	--restart on-failure \
	ignazioc/image_generator:0.2
```


# How to update the docker image:

1. Login to docker `docker login --username=yourhubusername --email=youremail@company.com`
2. Build the docker image `docker build -t ignazioc/image_generator:0.3 .`
3. Push on the hub `docker push ignazioc/image_generator`

For running on a single machine, just run the docker command. For a multi-docker environment find the docker-compose file, change the tag of the image and execute again with `docker-compose up -d` 