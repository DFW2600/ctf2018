FROM pierrezemb/gostatic:latest
EXPOSE 8043
ADD src/ /srv/http
