from django.db import models
from django.urls import reverse
from django.contrib.auth.models import User
import uuid
from datetime import date

class Direction(models.Model):

    name = models.CharField(max_length=50, help_text='Желаемая вселенная')
    description = models.CharField(max_length=500, help_text='Описание вселенной', null=True)

    def __str__(self):
        return self.name
    
    def get_absolute_url(self):
        return reverse('direction-detail', args=[str(self.id)])

class Area(models.Model):

    name = models.CharField(max_length=50, help_text='Желаемая местность')
    description = models.CharField(max_length=500, help_text='Описание')
    direction = models.ForeignKey('Direction', on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return self.name

    def get_absolute_url(self):
        return reverse('area-detail', args=[str(self.id)])

class Commodity(models.Model):

    name = models.CharField(max_length=30, help_text='Доступные удобства')

    def __str__(self):
        return self.name


class Hotel(models.Model):

    name = models.CharField(max_length=50, help_text='Название отеля')
    area = models.ForeignKey('Area', on_delete=models.CASCADE, default=None)
    description = models.CharField(max_length=500, help_text='Описание')
    commodity = models.ManyToManyField('Commodity', help_text='Выберите доступные удобства')
    cost_per_night = models.PositiveSmallIntegerField(help_text='Цена за ночь')   

    def __str__(self):
        return self.name
    
    def get_absolute_url(self):
        return reverse('hotel-detail', args=[str(self.id)])

    
class Entertaiment(models.Model):

    name = models.CharField(max_length=50, help_text='Название отеля')
    description = models.CharField(max_length=500, help_text='Описание')
    area = models.ForeignKey(Area, on_delete=models.SET_NULL, null=True)
    cost = models.PositiveSmallIntegerField(help_text='Цена', null=True)   

    def __str__(self):
        return self.name
    
class Tour(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, help_text="Уникальный идентификатор тура")
    hotel = models.ForeignKey(Hotel, on_delete=models.SET_NULL, null=True, blank=True)
    checkin_date = models.DateField(help_text='Дата заселения')
    checkout_date = models.DateField(help_text='Дата выезда')
    entertaiments = models.ManyToManyField(Entertaiment, help_text='Заказанные развлечения')
    cost = models.PositiveSmallIntegerField(help_text='Итоговая стоимость', null=True, blank=True)
    tourist = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return str(self.id)
    
    class Meta:

        permissions=(('can_view', 'Set all tours'),)
    
    # def entertaiments(self):
    #     return (Entertaiment for Entertaiment in self.hotel.area)
    
    # def cost(self):
    #     return int(self.hotel.cost_per_night) * int(((self.checkout_date - self.checkin_date).days)) + all(self.entertaiments.cost)