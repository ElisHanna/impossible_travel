from django.shortcuts import render
from django.views import generic
from .models import Area, Commodity, Direction, Entertaiment, Hotel, Tour
from django.contrib.auth.mixins import LoginRequiredMixin

def index(request):
    """
    Отображение главной страницы сайта
    """
    num_directions=Direction.objects.all().count()
    num_areas=Area.objects.all().count()
    num_entertaiments=Entertaiment.objects.all().count()
    num_hotels=Hotel.objects.all().count()
    num_visits=request.session.get('num_visits', 0)
    request.session['num_visits'] = num_visits+1
    context = {'num_directions':num_directions,
               'num_areas':num_areas,
               'num_entertaiments':num_entertaiments,
               'num_hotels':num_hotels,
               'num_visits':num_visits,
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