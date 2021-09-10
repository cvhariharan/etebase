#! /bin/sh

echo "Running etesync test server"

cd /app

./manage.py collectstatic --noinput
./manage.py migrate
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$2', '$3', '$4')" | python manage.py shell
uvicorn etebase_server.asgi:application --host 0.0.0.0 --port $1