#!/bin/bash
sleep 10
python3 manage.py migrate
echo "from django.contrib.auth.models import User; User.objects.create_superuser('"`echo $SUPERUSER_NAME`"', 'admin@example.com', '"`echo $SUPERUSER_PASS`"')" | python3 manage.py shell
python3 manage.py runserver 0.0.0.0:8000