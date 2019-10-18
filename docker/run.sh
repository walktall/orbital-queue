# Start pg with /opt/pgdata mapped to /var/lib/postgresql/data
# docker run --name orbital-pg -e POSTGRES_USER=postgres \ 
# 		   -e POSTGRES_PASSWORD=postgres  -v /opt/pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres:12.0

# How to find pg host:
# docker network ls
# docker network inspect bridge

# Start orbital
docker pull allenwq/orbital:latest
docker run --name orbital -e DATABASE_HOST=172.17.0.2 -e DATABASE_PORT=5432 -e DATABASE_USERNAME=postgres -e DATABASE_PASSWORD=postgres \
           -e SECRET_KEY_BASE=d9492c73adfa8c34677155ef584526f961e9cacddaf30e519f27be028fb6f442047a53fda12d57cc3ff192aa9a570142afcb77d32d436cf1c564cd445b8fce72 \
           -p 3000:3000 -e RAILS_SERVE_STATIC_FILES=true -e RAILS_RELATIVE_URL_ROOT='/orbital' -d allenwq/orbital:latest