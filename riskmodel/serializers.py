from  rest_framework import serializers
from .models import *

class EngineSerializer(serializers.ModelSerializer):
     class Meta:
          model = EngineDatabase
          fields = "__all__"