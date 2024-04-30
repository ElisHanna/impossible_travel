# Generated by Django 5.0.4 on 2024-04-29 12:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('touring', '0003_tour_tourist'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tour',
            name='entertaiments',
        ),
        migrations.AddField(
            model_name='tour',
            name='entertaiments',
            field=models.ManyToManyField(help_text='Заказанные развлечения', to='touring.entertaiment'),
        ),
    ]