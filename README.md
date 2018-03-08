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
	ignazioc/image_generator:0.1
```