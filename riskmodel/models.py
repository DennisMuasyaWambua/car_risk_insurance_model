from django.db import models

# Create your models here.
class EngineDatabase(models.Model):
     engine_rpm = models.IntegerField(default=0)
     g_x = models.DecimalField(decimal_places=2, max_digits=8)
     g_y = models.DecimalField(decimal_places=2, max_digits=8)
     g_z = models.DecimalField(decimal_places=2, max_digits=8)
     throttle_position = models.DecimalField(decimal_places=2, max_digits=8)

