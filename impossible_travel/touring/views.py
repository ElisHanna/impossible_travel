from django.shortcuts import render
from django.views import generic
from .models import Area, Commodity, Direction, Entertaiment, Hotel, Tour

def index(request):
    """
    Отображение главной страницы сайта
    """
    num_directions=Direction.objects.all().count()
    num_areas=Area.objects.all().count()
    num_entertaiments=Entertaiment.objects.all().count()
    num_hotels=Hotel.objects.all().count()
    context = {'num_directions':num_directions,
               'num_areas':num_areas,
               'num_entertaiments':num_entertaiments,
               'num_hotels':num_hotels
               }

    return render(request, 'index.html', context=context)

class DirectionListView(generic.ListView):
    model = Direction

class DirectionDetailView(generic.DetailView):
    model = Direction

class AreaListView(generic.ListView):
    model = Area

class AreaDetailView(generic.DetailView):
    model = Area

class HotelListView(generic.ListView):
    model = Hotel

class HotelDetailView(generic.DetailView):
    model = Hotel

class EntertaimentListView(generic.ListView):
    model = Entertaiment