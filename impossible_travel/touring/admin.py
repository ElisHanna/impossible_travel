from django.contrib import admin
from .models import Area, Commodity, Direction, Hotel, Tour , Entertaiment

#admin.site.register(Area)
admin.site.register(Commodity)
admin.site.register(Direction)
#admin.site.register(Entertaiment)
#admin.site.register(Hotel)
admin.site.register(Tour)

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