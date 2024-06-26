import uuid

from django.db import models
from django.urls import reverse
from django.contrib.auth.models import User
from django.conf import settings

class Direction(models.Model):
    """
    Модель вселенной
    """

    name = models.CharField(max_length=50, help_text='Желаемая вселенная')
    description = models.CharField(max_length=500, help_text='Описание вселенной', null=True)

    def __str__(self):
        return self.name
    
    def get_absolute_url(self):
        return reverse('direction-detail', args=[str(self.id)])


class Area(models.Model):
    """
    Модель местности
    """

    name = models.CharField(max_length=50, help_text='Желаемая местность')
    description = models.CharField(max_length=500, help_text='Описание')
    direction = models.ForeignKey('Direction', on_delete=models.SET_NULL, null=True)
    

    def __str__(self):
        return self.name

    def get_absolute_url(self):
        return reverse('area-detail', args=[str(self.id)])


class Commodity(models.Model):
    """
    Модель удобств в гостинице
    """

    name = models.CharField(max_length=30, help_text='Доступные удобства')

    def __str__(self):
        return self.name


class Hotel(models.Model):
    """
    Модель гостиницы
    """

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
    """
    Модель вариантов досуга
    """

    name = models.CharField(max_length=50, help_text='Название отеля')
    description = models.CharField(max_length=500, help_text='Описание')
    area = models.ForeignKey(Area, on_delete=models.SET_NULL, null=True)
    cost = models.PositiveSmallIntegerField(help_text='Цена', null=True)   

    def __str__(self):
        return self.name
    
    
class Tour(models.Model):
    """
    Модель тура
    """

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, help_text="Уникальный идентификатор тура")
    area = models.ForeignKey(Area, on_delete=models.SET_NULL, null=True)
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
    
    def cost(self):

        total_ents_cost = 0
        for entertaiment in self.entertaiments.all():
            total_ents_cost += entertaiment.cost

        return self.hotel.cost_per_night * ((self.checkout_date - self.checkin_date).days) + total_ents_cost


class Profile(models.Model):
    """
    Модель профиля
    """
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    date_of_birth = models.DateField(blank=True, null=True)
    photo = models.ImageField(upload_to='media/users_photos', blank=True)

    def __str__(self):
        
        return f'Профиль пользователя {self.user.username}'