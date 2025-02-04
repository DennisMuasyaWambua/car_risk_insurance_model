# Generated by Django 5.1.5 on 2025-02-04 05:28

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='EngineDatabase',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('engine_rpm', models.IntegerField(default=0)),
                ('g_x', models.DecimalField(decimal_places=2, max_digits=8)),
                ('g_y', models.DecimalField(decimal_places=2, max_digits=8)),
                ('g_z', models.DecimalField(decimal_places=2, max_digits=8)),
                ('throttle_position', models.DecimalField(decimal_places=2, max_digits=8)),
            ],
        ),
    ]
