from typing import Any
from django.contrib import admin
from django.db.models.fields.related import ForeignKey
from django.forms.models import ModelChoiceField
from django.http.request import HttpRequest
from .models import Area, Commodity, Direction, Hotel, Tour , Entertaiment, Profile
from django.utils.safestring import mark_safe

admin.site.register(Commodity)
admin.site.register(Direction)

@admin.register(Area)
class AreaAdmin(admin.ModelAdmin):
    list_display = ('name', 'direction')
    list_filter = ['direction']
    
@admin.register(Entertaiment)
class EntertaimentAdmin(admin.ModelAdmin):
    list_display = ('name', 'cost')
    list_filter = ['area']

@admin.register(Hotel)
class HotelAdmin(admin.ModelAdmin):
    list_display = ('name', 'area', 'cost_per_night')
    list_filter = ['area']

@admin.register(Tour)
class TourAdmin(admin.ModelAdmin):
    list_display = ('tourist', 'hotel', 'checkin_date', 'checkout_date', 'cost', 'id', 'area')
    list_filter = ('tourist', 'hotel')

    # def formfield_for_foreignkey(self, db_field, request, **kwargs):
    #     if db_field.name == 'entertaiments':
    #         kwargs['queryset'] = Entertaiment.objects.filter(area = request.area)
    #     return super().formfield_for_foreignkey(db_field, request, **kwargs)

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'date_of_birth')
    readonly_fields = ['photo']
    def photo(self, obj):
        return mark_safe(f'<img src="{obj.photo.url}" width="100" height="100">')